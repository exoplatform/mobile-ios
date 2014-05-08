//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import <UIKit/UIKit.h>
#import "CloudViewUtils.h"

#define WELCOME_BUTTON_CONTAINER_TAG 1000
#define WELCOME_SEPARATOR_TAG 1001
#define FIRST_SWIPED_SCREEN_TAG 1002

#define SWIPED_VIEW_WIDTH (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 768 : 320
/* size for the swiped area */
#define SWIPED_VIEW_HEIGHT_iPhone 360
#define SWIPED_VIEW_HEIGHT_PORTRAIT_iPad 904
#define SWIPED_VIEW_HEIGHT_LANDSCAPE_iPad 648
#define SWIPED_VIEW_HEIGHT_iPhone5 448
/* coordinate Y of elements */
#define SCREENSHOT_Y 45
#define SCREENSHOT_Y_iPad 45
#define CAPTION_Y  32
#define SIGNUP_LOGIN_BUTTON_BOTTOM_Y_iPad 135
#define SIGNUP_LOGIN_BUTTON_BOTTOM_Y_iPhone 100
#define SKIP_BUTTON_BOTTOM_Y_iPad 45
#define SKIP_BUTTON_BOTTOM_Y_iPhone 50
#define SEPARATOR_LINE_BOTTOM_Y_iPad 140
#define SEPARATOR_LINE_BOTTOM_Y_iPhone 100

@protocol WelcomeViewControllerDelegate

- (void)didSkipSignUp;

@end

@interface WelcomeViewController : UIViewController <UIScrollViewDelegate> {
    NSArray *images;
    BOOL scrollingLocked; //flag to lock the call to scrollViewDidScroll to avoid paging problem (MOB-1572)
}

@property (assign) id<WelcomeViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *skipButton;
@property (nonatomic, retain) IBOutlet UILabel *captionLabel;
@property (nonatomic, retain) NSArray *captions;
@property (nonatomic, assign) BOOL shouldBackToSetting;
- (IBAction)skipCloudSignup:(id)sender;
- (IBAction)signup:(id)sender;
- (IBAction)login:(id)sender;

//configure the skip button
- (void)configureSkipButton;
- (void)initSwipedElements;
- (float)swipedViewWidth;
- (float)swipedViewHeight;
- (UIView *)swipedViewWithCaption:(NSString *)caption andScreenShot:(NSString *)imageName;
- (UIView *)logoView;
- (NSArray *)screenshots;
@end
