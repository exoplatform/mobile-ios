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

@synthesize skipButton, loginButton, signupButton, pageControl, scrollView, shouldDisplayLoginView, receivedEmail;
@synthesize shouldBackToSetting;
@synthesize blurryBg;

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
    [loginButton release];
    [signupButton release];
    [scrollView release];
    [pageControl release];
    [skipButton release];
    [receivedEmail release];
    [blurryBg release];
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

}

@end
