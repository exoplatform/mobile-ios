//
//  WelcomeViewController_iPad.m
//  eXo Platform
//
//  Created by vietnq on 7/5/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "WelcomeViewController_iPad.h"
#import "SignUpViewController_iPad.h"
#import "AlreadyAccountViewController_iPad.h"
#import "eXoNavigationController.h"
#import "AppDelegate_iPad.h"
#import "defines.h"
@interface WelcomeViewController_iPad ()

@end

@implementation WelcomeViewController_iPad

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews
{
    if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        self.scrollView.contentSize = CGSizeMake(SCR_WIDTH_LSCP_IPAD * 4, SCR_HEIGHT_LSCP_IPAD - 100);
    } else {
        self.scrollView.contentSize = CGSizeMake(SCR_WIDTH_PRTR_IPAD * 4, SCR_HEIGHT_PRTR_IPAD - 100);
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self repositionSwipedElements];
    
    UIView *buttons = [self.view viewWithTag:WELCOME_BUTTON_CONTAINER_TAG];
    CGRect frame = buttons.frame;
    frame.origin.x = ([self swipedViewWidth] - frame.size.width)/2;
    frame.origin.y = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? 768-100:1024-100;
    buttons.frame = frame;
    
    frame = self.skipButton.frame;
    frame.origin.x = ([self swipedViewWidth] - frame.size.width)/2;
    frame.origin.y = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? 768-50:1024-50;
    self.skipButton.frame = frame;
    
    frame = self.pageControl.frame;
    frame.origin.x = ([self swipedViewWidth] - frame.size.width)/2;
    self.pageControl.frame = frame;
    
    UIImageView *imageView = (UIImageView*)[self.view viewWithTag:WELCOME_SEPARATOR_TAG];
    frame = imageView.frame;
    frame.origin.y = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? 768 - 120 - frame.size.height : 1024 - 120 - frame.size.height;
    frame.size.width = [self swipedViewWidth];
    imageView.frame = frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)skipCloudSignup:(id)sender
{
    if(self.shouldBackToSetting) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        AppDelegate_iPad *appDelegate = [AppDelegate_iPad instance];
        appDelegate.window.rootViewController = appDelegate.viewController;
    }
}
- (void)signup:(id)sender
{
    SignUpViewController_iPad *signUpVC = [[[SignUpViewController_iPad alloc] initWithNibName:@"SignUpViewController_iPad" bundle:nil] autorelease];
    signUpVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    signUpVC.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:signUpVC animated:YES];
}

- (void)login:(id)sender
{
    AlreadyAccountViewController_iPad *alreadyVC = [[[AlreadyAccountViewController_iPad alloc] initWithNibName:@"AlreadyAccountViewController_iPad" bundle:nil] autorelease];
    eXoNavigationController *navCon = [[[eXoNavigationController alloc] initWithRootViewController:alreadyVC] autorelease];
    
    navCon.modalPresentationStyle = UIModalPresentationFormSheet;
    navCon.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:navCon animated:YES];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)repositionSwipedElements
{
    
    images = [self screenshots];
    CGRect frame = self.scrollView.frame;
    frame.size.width = [self swipedViewWidth];
    frame.size.height = [self swipedViewHeight];
    self.scrollView.frame = frame;
    for(UIView *view in [self.scrollView subviews]) {
        [view removeFromSuperview];
    }
    
    [self.scrollView insertSubview:[self logoView] atIndex:0];
        
    for(int i = 0; i < [images count]; i++) {
        
        UIView *viewiTmp = [self swipedViewWithCaption:[self.captions objectAtIndex:i] andScreenShot:[images objectAtIndex:i]];
        frame = viewiTmp.frame;
        frame.origin.x = self.scrollView.frame.size.width * (i+1);
        viewiTmp.frame = frame;
        [self.scrollView insertSubview:viewiTmp atIndex:i+1];
        [viewiTmp release];
    }
}
@end
