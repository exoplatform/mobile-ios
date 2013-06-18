//
//  MailInputViewController.m
//  eXo Platform
//
//  Created by vietnq on 6/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "MailInputViewController.h"
#import "CloudUtils.h"
#import "ExoCloudProxy.h"
#import "LanguageHelper.h"
#import "AppDelegate_iPhone.h"
#import "AlreadyAccountViewController_iPhone.h"
#import "WelcomeViewController_iPhone.h"

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
    self.errorLabel.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    [_errorLabel release];
    [_mailTf release];
    [_hud release];
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
    if([CloudUtils checkEmailFormat:self.mailTf.text]) {
        ExoCloudProxy *cloudProxy = [[ExoCloudProxy alloc] init];
        cloudProxy.delegate = self;
        cloudProxy.email = self.mailTf.text;
        
        [self.mailTf resignFirstResponder];
        self.hud.textLabel.text = Localize(@"Loading");
        [self.hud setLoading:YES];
        [self.hud show];
        
        [cloudProxy signUpWithEmail:self.mailTf.text];
    } else {
        self.errorLabel.text = @"Incorrect email format";
    }
}

#pragma mark Handle response from cloud signup service
- (void)cloudProxy:(ExoCloudProxy *)proxy handleCloudResponse:(CloudResponse)response forEmail:(NSString *)email
{

    switch (response) {
        case EMAIL_SENT:
            [self.hud dismiss];
            [self showGreeting];
            break;
        case EMAIL_BLACKLISTED:
            NSLog(@"email blacklisted");
            break;
        case ACCOUNT_CREATED: {
            [self.hud setHidden:YES];
            emailAddress = email;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:Localize(@"AccountAlreadyExists") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert setTag:ALERT_VIEW_ALREADY_ACCOUNT_TAG];
            [alert show];
            break;
        }
            
        case NUMBER_OF_USERS_EXCEED:
            NSLog(@"number of users exceed");
            break;
        default:
            break;
    }
}

- (void)cloudProxy:(ExoCloudProxy *)proxy handleError:(NSError *)error
{
    [self.hud setHidden:YES];
    NSLog(@"%@", [error description]);
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:Localize(@"CloudServerNotAvailable") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
    [alert show];
}

- (void)showGreeting
{
    
    UIView *greetingView = [[[self.view superview] subviews] objectAtIndex:1];
    greetingView.hidden = NO;
    self.view.hidden = YES;
    [UIView transitionFromView:self.view toView:greetingView duration:0.8f options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        // change the title of cancel button to OK
        UINavigationBar *navigationBar = (UINavigationBar *)[self.parentViewController.view viewWithTag:SIGNUP_NAVIGATION_BAR_TAG];
        UINavigationItem *navigationItem = (UINavigationItem *) [[navigationBar items] objectAtIndex:0];
        UIBarButtonItem *button = navigationItem.rightBarButtonItem;
        button.title = @"OK";
    }];
}

- (void)redirectToLoginScreen:(NSString *)email;
{
    
    UIViewController *welcomeView = self.parentViewController.presentingViewController;
    
    if([welcomeView isMemberOfClass:[WelcomeViewController class]]) {
        WelcomeViewController *welcomeView = (WelcomeViewController *)welcomeView;
        welcomeView.receivedEmail = email;
        welcomeView.shouldDisplayLoginView = YES;
        [self.parentViewController dismissModalViewControllerAnimated:NO];
    } else {
        //TO-DO:handle the case user start the sign up from setting view
        // and he enters a configured email
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.hud setHidden:NO];
    [self.hud dismiss];
    
    if(alertView.tag == ALERT_VIEW_ALREADY_ACCOUNT_TAG) {
        [self redirectToLoginScreen:emailAddress];
    }
}
@end
