//
//  WelcomeViewController.m
//  eXo Platform
//
//  Created by vietnq on 6/13/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "WelcomeViewController.h"
#import "SignUpViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

@synthesize skipButton, pageControl, scrollView, shouldDisplayLoginView, receivedEmail;
@synthesize shouldBackToSetting;
@synthesize captions;
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
    self.captions = [NSArray arrayWithObjects:@"Follow what your connections are sharing", @"Browse and edit your files", @"Interact with your personal dashboards", nil];
    [self.view addSubview:[self buttonsContainer]];
}

- (void)viewDidAppear:(BOOL)animated
{
    if(shouldDisplayLoginView) {
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    [scrollView release];
    [pageControl release];
    [skipButton release];
    [receivedEmail release];
    [captions release];
}

- (void)skipCloudSignup:(id)sender
{
    
}

- (void)login:(id)sender
{
    
}

- (void)signup:(id)sender
{
    
}
- (void)scrollViewDidEndScroll:(UIScrollView *)scrollView
{
    
}

- (void)configureSkipButton
{
    //config the skip button
    UIImage *originalImage = [UIImage imageNamed:@"bg_btn_skip"];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:insets];
    
    [self.skipButton setBackgroundImage:stretchableImage forState:UIControlStateNormal];
    
    [[self.skipButton layer] setBorderWidth:0.3f];
    [[self.skipButton layer] setBorderColor:[UIColor grayColor].CGColor];
    [[self.skipButton layer] setCornerRadius:3.0f];
    CGRect frame = self.skipButton.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - 50;
    self.skipButton.frame = frame;
}

- (UIView *)buttonsContainer
{
    UIImage *signupBg = [UIImage imageNamed:@"btn_blue"];
    UIImage *loginBg = [UIImage imageNamed:@"btn_black"];
    
    UIButton *signupButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, signupBg.size.width/2, signupBg.size.height/2)];
    [signupButton setImage:signupBg forState:UIControlStateNormal];
    [signupButton addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(signupBg.size.width/2, 0, signupBg.size.width/2, signupBg.size.height/2)];
    [loginButton setImage:loginBg forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    [CloudViewUtils configure:signupButton withTitle:@"Sign Up" andSubtitle:@"Create an account"];
    [CloudViewUtils configure:loginButton withTitle:@"Log In" andSubtitle:@"Already an account"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, signupBg.size.width/2 + loginBg.size.width/2, signupBg.size.height/2)];
    
    UILabel *orLabel = [[UILabel alloc] init];
    orLabel.text = @"or";
    orLabel.backgroundColor = [UIColor clearColor];
    orLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    orLabel.textColor = [UIColor whiteColor];
    orLabel.frame = CGRectMake(view.frame.size.width/2 - 5, view.frame.size.height/2 - 12, 15,10);
    
    [view addSubview:signupButton];
    [view addSubview:loginButton];
    [view addSubview:orLabel];
    
    [orLabel release];
    [signupButton release];
    [loginButton release];
    
    CGRect frame = view.frame;
    frame.origin.x = (self.view.frame.size.width - frame.size.width)/2;
//    frame.origin.y = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 880 : 386;
    frame.origin.y = [[UIScreen mainScreen] bounds].size.height - 100;
    view.frame = frame;
    view.tag = WELCOME_BUTTON_CONTAINER_TAG;
    
    return view;
}

@end
