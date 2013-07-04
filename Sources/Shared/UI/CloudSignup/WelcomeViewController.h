//
//  WelcomeViewController.h
//  eXo Platform
//
//  Created by vietnq on 6/13/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudViewUtils.h"

@interface WelcomeViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) IBOutlet UIButton *signupButton;
@property (nonatomic, retain) IBOutlet UIButton *skipButton;
@property (nonatomic, retain) IBOutlet UIImageView *blurryBg;
@property (nonatomic, retain) IBOutlet UILabel *captionLabel;
@property (nonatomic, retain) NSArray *captions;
// if YES, auto switch to login page, this is used in case when user enters an email that
// is already configured in sign up form, the sign up view will redirect to login view
// the mechanism is dismiss the sign up view first, and display the login view in
// when Welcome view appears (WelcomeViewController#viewDidAppear)
@property (nonatomic, assign) BOOL shouldDisplayLoginView;
// the received email from the sign up view when user enters an already configured email
@property (nonatomic, retain) NSString *receivedEmail;
@property (nonatomic, assign) BOOL shouldBackToSetting;
- (IBAction)skipCloudSignup:(id)sender;
- (IBAction)signup:(id)sender;
- (IBAction)login:(id)sender;

//configure the skip button
- (void)configureSkipButton;
@end
