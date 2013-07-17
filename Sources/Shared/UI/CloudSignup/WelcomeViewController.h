//
//  WelcomeViewController.h
//  eXo Platform
//
//  Created by vietnq on 6/13/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudViewUtils.h"
#define WELCOME_BUTTON_CONTAINER_TAG 1000
#define SWIPED_VIEW_WIDTH (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 768 : 320
#define SWIPED_VIEW_HEIGHT_iPhone 360
#define SWIPED_VIEW_HEIGHT_iPad 904
#define SWIPED_VIEW_HEIGHT_iPhone5 448
#define SCREENSHOT_Y 40
#define CAPTION_Y  30

@interface WelcomeViewController : UIViewController <UIScrollViewDelegate> {
    NSArray *images;
}

@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *skipButton;
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
- (void)initSwipedElements;
@end
