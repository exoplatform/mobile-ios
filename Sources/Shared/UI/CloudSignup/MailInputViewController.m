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
#import "LanguageHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "CloudViewUtils.h"
#import "defines.h"

#define scrollUp 50;

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

    /* Add tap gesture to dismiss keyboard */
    UITapGestureRecognizer *tapGesure = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboards)] autorelease];
    [tapGesure setCancelsTouchesInView:NO]; // Processes other events on the subviews
    [self.view addGestureRecognizer:tapGesure];
    
    // Notifies when the keyboard is shown/hidden
    // Selector must be implemented in _iPhone and _iPad subclasses
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageKeyboard:) name:UIKeyboardDidHideNotification object:nil];
    
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
    [_instructionLabel release];
    [_createButton release];
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
        
        [self.mailTf resignFirstResponder];
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
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:Localize(@"EmailIsBlacklisted") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
            [alert show];
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
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:Localize(@"NumberOfUsersExceed") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
            [alert show];
            break;
        }
        
        case TENANT_RESUMING:
        {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:Localize(@"TenantResuming") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
            [alert show];
            break;
        }
        default:
            break;
    }
}

- (void)cloudProxy:(ExoCloudProxy *)proxy handleError:(NSError *)error
{
    [self.hud setHidden:YES];
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
    UIViewController *presentingVC = self.parentViewController.presentingViewController;
    if([presentingVC isKindOfClass:[WelcomeViewController class]]) {
        WelcomeViewController *welcomeView = (WelcomeViewController *)presentingVC;
        welcomeView.receivedEmail = email;
        welcomeView.shouldDisplayLoginView = YES;
        [self.parentViewController dismissModalViewControllerAnimated:NO];
    }
    //TO-DO: start sign up from setting view
        
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
    if (notif.name == UIKeyboardDidShowNotification) {
        [self setViewMovedUp:YES];
    } else if (notif.name == UIKeyboardDidHideNotification) {
        [self setViewMovedUp:NO];
    }
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect viewRect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        viewRect.origin.y -= scrollUp;
    }
    else
    {
        viewRect.origin.y = 0;
    }
    self.view.frame = viewRect;
    [UIView commitAnimations];
}

- (void)dismissKeyboards
{
    [self.mailTf resignFirstResponder];
}

@end
