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

#import "MailInputViewController.h"
#import "CloudUtils.h"
#import "ExoCloudProxy.h"
#import "LanguageHelper.h"
#import "AppDelegate_iPhone.h"
#import "LanguageHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "CloudViewUtils.h"
#import "defines.h"

int const ALERT_VIEW_ALREADY_ACCOUNT_TAG = 1000;
int const SIGNUP_NAVIGATION_BAR_TAG = 1001;

@interface MailInputViewController ()

@end

@implementation MailInputViewController {
    NSString *emailAddress;
}

@synthesize errorLabel = _errorLabel;
@synthesize mailTf = _mailTf;
@synthesize hud = _hud;
@synthesize instructionLabel = _instructionLabel;
@synthesize createButton = _createButton;
@synthesize warningIcon = _warningIcon;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    [self configElements];
    
    [CloudViewUtils adaptCloudForm:self.view];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mailTf becomeFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
     _errorLabel = nil;
    [_errorLabel release];
   _mailTf = nil;
    [_mailTf release];
    _hud = nil;
    [_hud release];
    _instructionLabel = nil;
    [_instructionLabel release];
    _createButton = nil;
    [_createButton release];
    _warningIcon = nil;
    [_warningIcon release];
}

- (SSHUDView *)hud {
    if (!_hud) {
        _hud = [[SSHUDView alloc] initWithTitle:Localize(@"Loading")];
        _hud.completeImage = [UIImage imageNamed:@"19-check.png"];
        _hud.failImage = [UIImage imageNamed:@"11-x.png"];
    }
    return _hud;
}

- (void)createAccount:(id)sender
{
    
    self.warningIcon.hidden = YES;
    self.errorLabel.hidden = YES;
    
    if([CloudUtils checkEmailFormat:self.mailTf.text]) {
        ExoCloudProxy *cloudProxy = [[ExoCloudProxy alloc] initWithDelegate:self andEmail:self.mailTf.text];
        
        [self dismissKeyboards];
        self.hud.textLabel.text = Localize(@"Loading");
        [self.hud setLoading:YES];
        [self.hud show];
        
        [cloudProxy signUp];
    } else {
        self.errorLabel.hidden = NO;
        self.warningIcon.hidden = NO;
    }
}

#pragma mark Handle response from cloud signup service
- (void)cloudProxy:(ExoCloudProxy *)proxy handleCloudResponse:(CloudResponse)response forEmail:(NSString *)email
{

    [self.hud setHidden:YES];
    switch (response) {
        case EMAIL_SENT:
            [self.hud dismiss];
            [self showGreeting];
            break;
        case EMAIL_BLACKLISTED:
        {
            [self.hud setHidden:YES];
            [self showAlert:@"EmailIsBlacklisted"];
            break;
        }
            
        case ACCOUNT_CREATED: {
            [self.hud setHidden:YES];
            emailAddress = email;
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:Localize(@"AccountAlreadyExists") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
            [alert setTag:ALERT_VIEW_ALREADY_ACCOUNT_TAG];
            [alert show];
            break;
        }
            
        case NUMBER_OF_USERS_EXCEED:
        {
            [self.hud setHidden:YES];
            [self showAlert:@"NumberOfUsersExceed"];
            break;
        }
        
        case TENANT_RESUMING:
        {
            [self.hud setHidden:YES];
            [self showAlert:@"TenantResuming"];
            break;
        }
        case SERVICE_UNAVAILABLE:
        {
            [self.hud setHidden:YES];
            [self showAlert:@"ServiceUnavailable"];
            break;
        }
        case INTERNAL_SERVER_ERROR:
        {
            [self.hud setHidden:YES];
            [self showAlert:@"SignupInternalServerError"];
            break;
        }
        default:
            break;
    }
}

- (void)cloudProxy:(ExoCloudProxy *)proxy handleError:(NSError *)error
{
    [self.hud setHidden:YES];
    [self showAlert:@"NetworkConnectionFailed"];
}

- (void)showGreeting
{
    
    UIView *greetingView = [[[self.view superview] subviews] objectAtIndex:1];
    greetingView.hidden = NO;
    self.view.hidden = YES;
    [UIView transitionFromView:self.view toView:greetingView duration:0.8f options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        // change the title of cancel button to OK
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UINavigationItem *navigationItem = self.parentViewController.navigationItem;
            UIBarButtonItem *button = navigationItem.rightBarButtonItem;
            button.title = @"OK";
        } else {
            UINavigationBar *navigationBar = (UINavigationBar *)[self.parentViewController.view viewWithTag:SIGNUP_NAVIGATION_BAR_TAG];
            UINavigationItem *navigationItem = (UINavigationItem *) [[navigationBar items] objectAtIndex:0];
            UIBarButtonItem *button = navigationItem.rightBarButtonItem;
            button.title = @"OK";
        }
    }];
}

- (void)redirectToLoginScreen:(NSString *)email;
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.hud setHidden:NO];
    [self.hud dismiss];
    
    if(alertView.tag == ALERT_VIEW_ALREADY_ACCOUNT_TAG) {
        [self redirectToLoginScreen:emailAddress];
    }
}

#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self createAccount:nil];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string length] > 0) {
        self.createButton.enabled = YES;
    } else {
        if(range.location == 0) {//delete all the text, disable create button
            self.createButton.enabled = NO;
        }
    }
    return YES;
}

// config the outlets
- (void)configElements
{
    self.mailTf.delegate = self;
    
    [self.createButton setEnabled:NO];
    
    [CloudViewUtils configureTextField:self.mailTf withIcon:@"icon_mail"];
    [CloudViewUtils configureButton:self.createButton withBackground:@"blue_btn"];
    
    self.errorLabel.text = Localize(@"IncorrectEmailFormat");
    self.errorLabel.hidden = YES;
    self.warningIcon.hidden = YES;
}

#pragma mark - Keyboard management

-(void)manageKeyboard:(NSNotification *) notif {
    
}

- (void)dismissKeyboards
{
    [self.mailTf resignFirstResponder];
}

- (void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:Localize(message) delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
    [alert show];

}

@end
