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

@interface MailInputViewController ()

@end

@implementation MailInputViewController
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
- (void)handleCloudResponse:(CloudResponse)response
{
    [self.hud dismiss];

    switch (response) {
        case EMAIL_SENT:
            [self showGreeting];
            break;
        case EMAIL_BLACKLISTED:
            NSLog(@"email blacklisted");
            break;
        case ACCOUNT_CREATED: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already configured" message:@"Redirect to login screen" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
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

- (void)handleError:(NSError *)error
{
    NSLog(@"%@", [error description]);
}

- (void)showGreeting
{
    
    UIView *greetingView = [[[self.view superview] subviews] objectAtIndex:1];
    greetingView.hidden = NO;
    self.view.hidden = YES;
    [UIView transitionFromView:self.view toView:greetingView duration:0.8f options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        
    }];
}

- (void)redirectToLoginScreen
{
    AlreadyAccountViewController_iPhone *viewController = [[AlreadyAccountViewController_iPhone alloc] initWithNibName:@"AlreadyAccountViewController_iPhone" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self.parentViewController presentModalViewController:navigationController animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self redirectToLoginScreen];
}
@end
