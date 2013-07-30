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
        self.scrollView.contentSize = CGSizeMake(SCR_WIDTH_LSCP_IPAD * 5, SWIPED_VIEW_HEIGHT_LANDSCAPE_iPad);
    } else {
        self.scrollView.contentSize = CGSizeMake(SCR_WIDTH_PRTR_IPAD * 5, SWIPED_VIEW_HEIGHT_PORTRAIT_iPad);
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self repositionButtonsAndSeparator:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)skipCloudSignup:(id)sender
{
    AppDelegate_iPad *appDelegate = [AppDelegate_iPad instance];

    if(self.shouldBackToSetting) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        appDelegate.window.rootViewController = appDelegate.viewController;
    }
}
- (void)signup:(id)sender
{
    SignUpViewController_iPad *signUpVC = [[SignUpViewController_iPad alloc] initWithNibName:@"SignUpViewController_iPad" bundle:nil];
    //need a navigation controller to fix some bugs related to keyboard
    eXoNavigationController *navCon = [[eXoNavigationController alloc] initWithRootViewController:signUpVC];
    [signUpVC release];
    navCon.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navCon.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:navCon animated:YES];
}

- (void)login:(id)sender
{
    AlreadyAccountViewController_iPad *alreadyVC = [[[AlreadyAccountViewController_iPad alloc] initWithNibName:@"AlreadyAccountViewController_iPad" bundle:nil] autorelease];
    //need a navigation controller to fix some bugs related to keyboard
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self repositionSwipedElements:toInterfaceOrientation];
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)repositionSwipedElements:(UIInterfaceOrientation)toInterfaceOrientation
{
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        images = [NSArray arrayWithObjects:@"ipad-activity-stream-landscape",@"ipad-activity-details-landscape", @"ipad-documents-landscape",@"ipad-apps-landscape", nil];
    } else {
        images = [NSArray arrayWithObjects:@"ipad-activity-stream-portrait",@"ipad-activity-details-portrait", @"ipad-documents-portrait",@"ipad-apps-portrait", nil];
    }

    CGRect frame = self.scrollView.frame;
    CGSize size = [self swipedSizeForOrientation:toInterfaceOrientation];
    frame.size = size;
    self.scrollView.frame = frame;
    
    UIView *logoslogan = [self.scrollView viewWithTag:FIRST_SWIPED_SCREEN_TAG];
    
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        [logoslogan setFrame:CGRectMake(262,74,500,500)];
    } else {
        [logoslogan setFrame:CGRectMake(134, 202, 500, 500)];
    }
    
    UIView *swipedView;
    for(int i = 0; i < [images count]; i++) {
        swipedView = [self.scrollView viewWithTag:i+1];
        frame = swipedView.frame;
        frame.origin.x = self.scrollView.frame.size.width * (i+1);
        frame.size = self.scrollView.frame.size;
        swipedView.frame = frame;
        
        for(UIView *tmpView in [swipedView subviews]) {
            if([tmpView isKindOfClass:UIImageView.class]) {
                UIImage *screenshot = [UIImage imageNamed:[images objectAtIndex:i]];
                UIImageView *imageView = (UIImageView *)tmpView;
                frame = imageView.frame;
                frame.size = screenshot.size;
                imageView.frame = frame;
                imageView.image = screenshot;
            }
            if([tmpView isKindOfClass:UILabel.class]) {
                UILabel *caption = (UILabel *)tmpView;
                frame = caption.frame;
                frame.origin.x = (swipedView.frame.size.width - frame.size.width)/2;
                caption.frame = frame;
            }
        }
    }
    //move scrollview to current page
    [self.scrollView setContentOffset:CGPointMake(self.pageControl.currentPage * [self swipedSizeForOrientation:toInterfaceOrientation].width, self.scrollView.contentOffset.y)];
}

- (void)repositionButtonsAndSeparator:(UIInterfaceOrientation)toInterfaceOrientation
{
    //reposition the buttons and the separator line
    UIView *buttons = [self.view viewWithTag:WELCOME_BUTTON_CONTAINER_TAG];
    CGRect frame = buttons.frame;
    frame.origin.x = ([self swipedViewWidth] - frame.size.width)/2;
    frame.origin.y = UIInterfaceOrientationIsLandscape(toInterfaceOrientation) ? SCR_HEIGHT_LSCP_IPAD - SIGNUP_LOGIN_BUTTON_BOTTOM_Y_iPad : SCR_HEIGHT_PRTR_IPAD - SIGNUP_LOGIN_BUTTON_BOTTOM_Y_iPad;
    buttons.frame = frame;
    
    frame = self.skipButton.frame;
    frame.origin.x = ([self swipedViewWidth] - frame.size.width)/2;
    frame.origin.y = UIInterfaceOrientationIsLandscape(toInterfaceOrientation) ? SCR_HEIGHT_LSCP_IPAD - SKIP_BUTTON_BOTTOM_Y_iPad : SCR_HEIGHT_PRTR_IPAD - SKIP_BUTTON_BOTTOM_Y_iPad;
    self.skipButton.frame = frame;
    
    frame = self.pageControl.frame;
    frame.origin.x = ([self swipedViewWidth] - frame.size.width)/2;
    self.pageControl.frame = frame;
    
    UIImageView *imageView = (UIImageView*)[self.view viewWithTag:WELCOME_SEPARATOR_TAG];
    frame = imageView.frame;
    frame.origin.y = UIInterfaceOrientationIsLandscape(toInterfaceOrientation) ? SCR_HEIGHT_LSCP_IPAD - SEPARATOR_LINE_BOTTOM_Y_iPad - frame.size.height : SCR_HEIGHT_PRTR_IPAD - SEPARATOR_LINE_BOTTOM_Y_iPad - frame.size.height;
    frame.size.width = [self swipedViewWidth];
    imageView.frame = frame;
}


- (CGSize)swipedSizeForOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsLandscape(orientation) ? CGSizeMake(SCR_WIDTH_LSCP_IPAD,SWIPED_VIEW_HEIGHT_LANDSCAPE_iPad) : CGSizeMake(SCR_WIDTH_PRTR_IPAD, SWIPED_VIEW_HEIGHT_PORTRAIT_iPad);
}
@end
