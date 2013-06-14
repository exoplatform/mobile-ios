//
//  WelcomeViewController.h
//  eXo Platform
//
//  Created by vietnq on 6/13/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) IBOutlet UIButton *signupButton;

- (IBAction)skipCloudSignup:(id)sender;
- (IBAction)signup:(id)sender;
- (IBAction)login:(id)sender;
@end
