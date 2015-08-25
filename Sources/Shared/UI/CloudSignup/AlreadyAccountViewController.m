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

#import "AlreadyAccountViewController.h"
#import "ApplicationPreferencesManager.h"
#import "ExoCloudProxy.h"
#import "CloudUtils.h"
#import "LanguageHelper.h"
#import "LoginProxy.h"
#import "UserPreferencesManager.h"
#import <QuartzCore/QuartzCore.h>
#import "CloudViewUtils.h"
#import "defines.h"

@interface AlreadyAccountViewController ()

@end

@implementation AlreadyAccountViewController
@synthesize passwordTf, emailTf, mailErrorLabel, autoFilledEmail;
@synthesize hud = _hud;
@synthesize loginButton;
@synthesize containerView = _containerView;
@synthesize onpremiseButton;
@synthesize warningIcon = _warningIcon;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"Get Started";
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = button;

    [self configElements];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture"]];
    
    [CloudViewUtils adaptCloudForm:self.containerView];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    //if the view is redirect from sign up view, auto fill the email entered in sign up view
    if(self.autoFilledEmail) {
        self.emailTf.text = self.autoFilledEmail;
        [self.passwordTf becomeFirstResponder];
    } else {
        [self.emailTf becomeFirstResponder];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    emailTf = nil;
    mailErrorLabel = nil;
    autoFilledEmail = nil;
    _hud = nil;
    loginButton = nil;
    _containerView = nil;
    onpremiseButton = nil;
    _warningIcon = nil;
}

- (void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)login:(id)sender
{
    // hide the error message
    self.warningIcon.hidden = YES;
    self.mailErrorLabel.hidden = YES;
    
    if([CloudUtils checkEmailFormat:self.emailTf.text]) {
        [self dismissKeyboards];
        [self.hud show];

        ExoCloudProxy *cloudProxy = [[ExoCloudProxy alloc] initWithDelegate:self andEmail:self.emailTf.text];
        [cloudProxy getInfoForMail:self.emailTf.text andCreateLead:NO];//get info about username, tenant name, tenant status first
    } else {
        self.mailErrorLabel.hidden = NO;
        self.warningIcon.hidden = NO;
    }
}

- (void)connectToOnPremise:(id)sender
{
    
}

#pragma mark ExoCloudProxyDelegate methods
- (void)cloudProxy:(ExoCloudProxy *)cloudProxy handleCloudResponse:(CloudResponse)response forEmail:(NSString *)email
{
    switch (response) {
        case SERVICE_UNAVAILABLE: {
            self.hud.hidden = YES;
            [self showAlert:@"ServiceUnavailable"];
            break;
        }
        case TENANT_CREATION: {
            self.hud.hidden = YES;
            [self showAlert:@"TenantCreation"];
            break;
        }
        case TENANT_ONLINE:
            //if the tenant is online, check user existance
            [cloudProxy checkUserExistance];
            break;
        case TENANT_RESUMING: {
            self.hud.hidden = YES;
            [self showAlert:@"TenantResuming"];
            break;
        }
        case TENANT_NOT_EXIST: {
            self.hud.hidden = YES;
            [self showAlert:@"TenantNotExist"];
            break;
        }
            
        case USER_EXISTED: {
            //if user existed, login the user
            NSString *serverUrl = [CloudUtils serverUrlByTenant:cloudProxy.tenantName];
            
            LoginProxy *loginProxy = [[LoginProxy alloc] initWithDelegate:self username:cloudProxy.username password:self.passwordTf.text serverUrl:serverUrl];
            
            loginProxy.delegate = self;
            [loginProxy authenticate];
            break;
        }
            
        case USER_NOT_EXISTED:
            self.hud.hidden = YES;
            [self showAlert:@"UserNotExist"];
            break;
        default:
            break;
    }
}

- (void)cloudProxy:(ExoCloudProxy *)cloudProxy handleError:(NSError *)error
{
    self.hud.hidden = YES;
    [self showAlert:@"NetworkConnectionFailed"];
}

#pragma mark LoginProxyDelegate methods
- (void)loginProxy:(LoginProxy *)proxy platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion
{
    
    //1 account is already configured, next time starting app, display authenticate screen
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:EXO_CLOUD_ACCOUNT_CONFIGURED];
}

- (void)loginProxy:(LoginProxy *)proxy authenticateFailedWithError:(NSError *)error
{
    self.hud.hidden = YES;
    [self showAlert:@"IncorrectPassword"];
}


- (SSHUDView *)hud {
    if (!_hud) {
        _hud = [[SSHUDView alloc] initWithTitle:Localize(@"Loading")];
        _hud.completeImage = [UIImage imageNamed:@"19-check.png"];
        _hud.failImage = [UIImage imageNamed:@"11-x.png"];
    }
    return _hud;
}

#pragma mark UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.hud dismiss];
    self.hud.hidden = NO;
}

#pragma mark UITextFieldDelegate methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string length] > 0) {
        if(textField == self.emailTf && [self.passwordTf.text length] > 0) {
            self.loginButton.enabled = YES;
        }
        if(textField == self.passwordTf && [self.emailTf.text length] > 0) {
            self.loginButton.enabled = YES;
        }
    } else {
        if(range.location == 0) {//delete all the text, disable login button
            self.loginButton.enabled = NO;
        }
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.passwordTf) {
        [textField resignFirstResponder];
        [self login:nil];
    } else {
        [textField resignFirstResponder];
        [self.passwordTf becomeFirstResponder];
    }
    return YES;
}
#pragma mark Utils

- (void)configElements
{
    self.loginButton.enabled = NO;
    self.emailTf.delegate = self;
    self.passwordTf.delegate = self;
    
    self.mailErrorLabel.text = Localize(@"IncorrectEmailFormat");
    self.mailErrorLabel.hidden = YES;
    self.warningIcon.hidden = YES;
    
    [CloudViewUtils configureButton:self.onpremiseButton withBackground:@"white_btn"];
    [CloudViewUtils configureButton:self.loginButton withBackground:@"blue_btn"];
    
    [CloudViewUtils configureTextField:self.emailTf withIcon:@"icon_mail"];
    [CloudViewUtils configureTextField:self.passwordTf withIcon:@"icon_lock"];
    [CloudViewUtils setTitleForButton:self.onpremiseButton with1stLine:@"Connect to an" and2ndLine:@"On Premise Installation"];
}

#pragma mark - Keyboard management

- (void)dismissKeyboards
{
    [self.emailTf resignFirstResponder];
    [self.passwordTf resignFirstResponder];
}

- (void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"Authorization") message:Localize(message) delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
@end
