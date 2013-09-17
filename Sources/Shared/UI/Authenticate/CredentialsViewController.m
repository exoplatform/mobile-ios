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
@synthesize bRememberMe = _bRememberMe;
@synthesize authViewController = _authViewController;
@synthesize panelBackground = _panelBackground;

-(void)dealloc {
    [_txtfPassword release];
    [_txtfUsername release];
    [_btnLogin release];
    [_authViewController release];
    [_panelBackground release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

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
    
    
    /* Add tap gesture to dismiss keyboard */
    UITapGestureRecognizer *tapGesure = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)] autorelease];
    [tapGesure setCancelsTouchesInView:NO]; // Processes other events on the subviews
    [self.view addGestureRecognizer:tapGesure];
    
    // Make sure the Textfield Delegate methods are called upon events on the 2 text fields
    [self.txtfPassword setDelegate:self];
    [self.txtfUsername setDelegate:self];
    
    [self localizeLabel];
    
    // re-localize label when user changes language
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(localizeLabel) name:EXO_NOTIFICATION_CHANGE_LANGUAGE object:nil];

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


- (void)signInAnimation:(int)animationMode
{    
    if(animationMode == 0) //Normal signIn
    {
        [UIView beginAnimations:nil context:nil];  
        [UIView setAnimationDuration:1.0];  
        [UIView commitAnimations];   
    } else if (animationMode == 1) {
        [self onSignInBtn:nil];
    }
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
    NSMutableString* errorMessage = [[[NSMutableString alloc] initWithString:@""] autorelease];
    BOOL shouldSignIn = YES;
    
    if ([self.txtfUsername.text isEqualToString:@""]) {
        shouldSignIn = NO;
        [errorMessage appendString:@"\n"];
        [errorMessage appendString:Localize(@"UserNameEmpty")];
    }
        
    if ([self.txtfPassword.text isEqualToString:@""]) {
        shouldSignIn = NO;
        [errorMessage appendString:@"\n"];
        [errorMessage appendString:Localize(@"PasswordEmpty")];
    }
    
    if ([[ApplicationPreferencesManager sharedInstance] selectedDomain] == nil) {
        shouldSignIn = NO;
        [errorMessage appendString:@"\n"];
        [errorMessage appendString:Localize(@"SelectedDomainEmpty")];
    }
        
	if (shouldSignIn) {
		[self.authViewController doSignIn];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:Localize(@"Authorization") 
                              message:errorMessage
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil];
		[alert show];
		[alert release];
    }
}

- (void)localizeLabel
{
    [self.btnLogin setTitle:Localize(@"SignInButton") forState:UIControlStateNormal];
    // Display localized placeholder text
    [self.txtfUsername setPlaceholder:Localize(@"UsernamePlaceholder")];
    [self.txtfPassword setPlaceholder:Localize(@"PasswordPlaceholder")];
}

@end
