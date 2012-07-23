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

-(void)dealloc {
    [_activeField release];
    [_txtfPassword release];
    [_txtfUsername release];
    [_btnLogin release];
    [_authViewController release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // custom actions
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //Add the background image for the login button
    [_btnLogin setBackgroundImage:[[UIImage imageNamed:@"AuthenticateButtonBgStrechable.png"]
                                   stretchableImageWithLeftCapWidth:10 topCapHeight:10]
                         forState:UIControlStateNormal];
    [self.btnLogin setTitle:Localize(@"SignInButton") forState:UIControlStateNormal];
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
	
	if(_bRememberMe || self.bAutoLogin)
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

#pragma mark - Keyboard management
/*- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unRegisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    // Get the size of the keyboard.
    CGSize keyboardSize = [self.view convertRect:[[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue] toView:nil].size;
    
    // Adjust the bottom content inset of your scroll view by the keyboard height.
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = [self.view convertRect:self.view.frame fromView:nil];
    
    aRect.size.height -= keyboardSize.height;
    
    CGPoint fieldPoint = CGPointMake(_vContainer.frame.origin.x + _txtfPassword.frame.origin.x + _vAccountView.frame.origin.x, _vContainer.frame.origin.y + _txtfPassword.frame.origin.y + _vAccountView.frame.origin.y);
    
    // Scroll the target text field into view.
    if (!CGRectContainsPoint(aRect, fieldPoint)) {
        CGPoint scrollPoint = CGPointMake(0.0, fieldPoint.y - keyboardSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
        
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)dismissKeyboard {
    [self.activeField resignFirstResponder];
}
*/
#pragma mark - TextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = nil;
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
        
        [self.authViewController hitAtView:self.view];
	}
	else
	{		
		[self.authViewController doSignIn];
	}
}

@end
