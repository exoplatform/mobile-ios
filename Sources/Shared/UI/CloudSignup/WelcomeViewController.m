//
//  WelcomeViewController.m
//  eXo Platform
//
//  Created by vietnq on 6/13/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "WelcomeViewController.h"
#import "SignUpViewController.h"
@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

@synthesize loginButton, signupButton, pageControl, scrollView, shouldDisplayLoginView, receivedEmail;

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
    if(self.receivedEmail) {
        [self.receivedEmail release];
    }
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
@end
