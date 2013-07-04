//
//  WelcomeViewController_iPhone.m
//  eXo Platform
//
//  Created by vietnq on 6/13/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "WelcomeViewController_iPhone.h"
#import "AuthenticateViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "SignUpViewController_iPhone.h"
#import "AlreadyAccountViewController_iPhone.h"

float const static SWIPED_SCREEN_SHOT_WIDTH = 220;
float const static SWIPED_SCREEN_SHOT_HEIGHT = 280;

@interface WelcomeViewController_iPhone ()
@end

@implementation WelcomeViewController_iPhone {
    NSArray *images;
}
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
    
    images = [NSArray arrayWithObjects:@"activity-stream",@"documents",@"gadgets", nil];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture"]];
        
    // Do any additional setup after loading the view from its nib.
    
    //insert images to scroll view
    
    [self initSwipedElements];
    
    [self configureSkipButton];
    
    [CloudViewUtils configure:self.signupButton withTitle:@"Sign Up" andSubtitle:@"Create an account"];
    
    [CloudViewUtils configure:self.loginButton withTitle:@"Log In" andSubtitle:@"Already an account"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect scrollViewFrame = self.scrollView.frame;
    scrollViewFrame.origin.y = self.blurryBg.frame.origin.y;
    self.scrollView.frame = scrollViewFrame;
}
- (void)viewDidAppear:(BOOL)animated
{
    
    if(self.shouldDisplayLoginView) {
        [self login:nil];
        self.shouldDisplayLoginView = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)skipCloudSignup:(id)sender
{
    if(self.shouldBackToSetting) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        AppDelegate_iPhone *appDelegate = [AppDelegate_iPhone instance];
        [UIView transitionFromView:appDelegate.window.rootViewController.view
                            toView:appDelegate.navigationController.view
                          duration:0.8f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        completion:^(BOOL finished){
                            appDelegate.window.rootViewController = appDelegate.navigationController;
                        }];
    }
}


- (void)signup:(id)sender
{
    SignUpViewController_iPhone *signupViewController = [[[SignUpViewController_iPhone alloc] initWithNibName:@"SignUpViewController_iPhone" bundle:nil] autorelease];
    signupViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:signupViewController animated:YES];

}

- (void)login:(id)sender
{
    AlreadyAccountViewController_iPhone *alreadyAccountViewController = [[AlreadyAccountViewController_iPhone alloc] initWithNibName:@"AlreadyAccountViewController_iPhone" bundle:nil];
    
    if(self.receivedEmail) {
        alreadyAccountViewController.autoFilledEmail = self.receivedEmail;
        self.receivedEmail = nil;//reset
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:alreadyAccountViewController];
   
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentModalViewController:navigationController animated:YES];
}

#pragma mark ScrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    self.captionLabel.text = [self.captions objectAtIndex:page];
}

- (void)initSwipedElements
{
    CGRect frame;
    UIImageView *imageView;
    
    float initX = (self.scrollView.frame.size.width - SWIPED_SCREEN_SHOT_WIDTH)/2;
    
    for(int i = 0; i < [images count]; i++) {
        
        frame = CGRectMake(self.scrollView.frame.size.width * i + initX, 0 , SWIPED_SCREEN_SHOT_WIDTH, SWIPED_SCREEN_SHOT_HEIGHT);
        imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:[images objectAtIndex:i]];
        
        [self.scrollView addSubview:imageView];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [images count], self.scrollView.frame.size.height);
    
    self.pageControl.currentPage = 0;
    self.captionLabel.text = [self.captions objectAtIndex:0];
}
@end
