//
//  CredentialsViewController.m
//  eXo Platform
//
//  Created by exoplatform on 7/18/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import "CredentialsViewController.h"
#import "AuthenticateViewController.h"
#import "defines.h"
#import "LanguageHelper.h"

@interface CredentialsViewController ()

@end

@implementation CredentialsViewController

@synthesize activeField = _activeField;
@synthesize txtfUsername = _txtfUsername;
@synthesize txtfPassword = _txtfPassword;
@synthesize btnLogin = _btnLogin;
@synthesize bAutoLogin = _bAutoLogin;
@synthesize authViewController = _authViewController;
@synthesize panelBackground = _panelBackground;

-(void)dealloc {
    _bAutoLoginIsDisabled = NO;
    [_activeField release];
    [_txtfPassword release];
    [_txtfUsername release];
    [_btnLogin release];
    [_authViewController release];
    [_panelBackground release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // By defaut, Auto Login is not disabled, i.e
        // - if it is ON, user will be signed in automatically
        // - if it is OFF, user will stay on the Authenticate page
        _bAutoLoginIsDisabled = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Add the background image for the login button
    [_btnLogin setBackgroundImage:[[UIImage imageNamed:@"AuthenticateButtonBgStrechable.png"]
                                   stretchableImageWithLeftCapWidth:10 topCapHeight:10]
                         forState:UIControlStateNormal];
    [self.btnLogin setTitle:Localize(@"SignInButton") forState:UIControlStateNormal];
    
    /* Add tap gesture to dismiss keyboard */
    UITapGestureRecognizer *tapGesure = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)] autorelease];
    [tapGesure setCancelsTouchesInView:NO]; // Processes other events on the subviews
    [self.view addGestureRecognizer:tapGesure];
    
    // Make sure the Textfield Delegate methods are called upon events on the 2 text fields
    [self.txtfPassword setDelegate:self];
    [self.txtfUsername setDelegate:self];
    // Display localized placeholder text
    [self.txtfUsername setPlaceholder:Localize(@"UsernamePlaceholder")];
    [self.txtfPassword setPlaceholder:Localize(@"PasswordPlaceholder")];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSString* username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME]; 
	if(username)
	{
		[self.txtfUsername setText:username];
	}
	
	if (self.txtfUsername.text.length == 0 && self.txtfPassword.text.length == 0) 
	{
		[self.txtfUsername becomeFirstResponder];
	}
	
	if (self.txtfUsername.text.length > 0)
	{
		[self.txtfPassword becomeFirstResponder];
	}

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	_bRememberMe = [[userDefaults objectForKey:EXO_REMEMBER_ME] boolValue];
	self.bAutoLogin = [[userDefaults objectForKey:EXO_AUTO_LOGIN] boolValue];
    // If Auto Login is disabled, we set the Auto Login variable to NO
    // but we don't save this value in the user settings
    if (_bAutoLoginIsDisabled)
        self.bAutoLogin = NO;
	    
	if(_bRememberMe && self.bAutoLogin)
	{
		NSString* username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
		NSString* password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
		if(username)
		{
			[self.txtfUsername setText:username];
		}
		
		if(password)
		{
			[self.txtfPassword setText:password];
		}
	}
	else 
	{
		[self.txtfUsername setText:@""];
		[self.txtfPassword setText:@""];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"NO" forKey:EXO_IS_USER_LOGGED];
	}
}

-(void) disableAutoLogin:(BOOL)autoLogin {
    _bAutoLoginIsDisabled = autoLogin;
}

#pragma mark - Keyboard management
- (void)dismissKeyboard {
    [self.txtfUsername resignFirstResponder];
    [self.txtfPassword resignFirstResponder];
}

#pragma mark - TextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtfUsername) 
    {
        [self.txtfPassword becomeFirstResponder];
    }
    else
    {    
        [self.txtfPassword resignFirstResponder];        
        [self onSignInBtn:nil];
    }    
	return YES;
}

- (IBAction)onSignInBtn:(id)sender
{
	if([self.txtfUsername.text isEqualToString:@""])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"Authorization")
														message:Localize(@"UserNameEmpty")
													   delegate:self 
											  cancelButtonTitle:@"OK"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
    }
	else
	{		
		[self.authViewController doSignIn];
	}
}

@end
