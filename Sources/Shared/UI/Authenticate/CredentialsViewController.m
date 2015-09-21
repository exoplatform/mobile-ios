//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    UITapGestureRecognizer *tapGesure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
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
    NSMutableString* errorMessage = [[NSMutableString alloc] initWithString:@""];
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
    }
}

- (void)setLoginButtonLabel
{
    // Display the selected account name on the Login button
    ServerObj* selectedAcc = [[ApplicationPreferencesManager sharedInstance] getSelectedAccount];
    NSString* label = Localize(@"SignInButton");
    if (selectedAcc != nil) {
        label = [NSString stringWithFormat:@"%@ %@ %@",Localize(@"SignInButton"), Localize(@"SignInButton_In"), selectedAcc.accountName];
    }
    [self.btnLogin setTitle:label forState:UIControlStateNormal];
}

- (void)localizeLabel
{
    [self setLoginButtonLabel];
    
    // Display localized placeholder text
    [self.txtfPassword setPlaceholder:Localize(@"PasswordPlaceholder")];
    
    if ([self.txtfUsername respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        //Chage place holder color to white with 70% bright
        UIColor *color = [UIColor colorWithWhite: 0.70 alpha:1];
        self.txtfUsername.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localize(@"UsernamePlaceholder") attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        LogError(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        [self.txtfUsername setPlaceholder:Localize(@"UsernamePlaceholder")];
    }
    
    if ([self.txtfPassword respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        //Change place holder color to white with 70% brightness
        UIColor *color = [UIColor colorWithWhite: 0.70 alpha:1];
        self.txtfPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localize(@"PasswordPlaceholder") attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        LogError(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        [self.txtfPassword setPlaceholder:Localize(@"PasswordPlaceholder")];
    }
    
}

@end
