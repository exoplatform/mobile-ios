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

#import "WelcomeViewController.h"
#import "SignUpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "eXoViewController.h"
#import "LogoSlogan.h"
#import "defines.h"
#import "eXoViewController.h"
@interface WelcomeViewController ()
@end

@implementation WelcomeViewController
@synthesize delegate;
@synthesize skipButton, pageControl, scrollView;
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
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture"]];
    
    self.captions = [NSArray arrayWithObjects:@"Activity streams", @"Comments and likes", @" Personal dashboards", @"Files management", nil];
    
    [self initSwipedElements];
    [self configureSkipButton];
    [self.view addSubview:[self buttonsContainer]];
    [self insertSeparatorLine];

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
#pragma mark ScrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollingLocked) {
        return;
    }
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)initSwipedElements
{
    images = [self screenshots];
    self.pageControl.numberOfPages = [images count] + 1;
    self.pageControl.currentPage = 0;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, [self swipedViewWidth], [self swipedViewHeight])];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
    CGRect scrollFrame = self.scrollView.frame;
    scrollFrame.origin.y = 0;
    self.scrollView.frame = scrollFrame;
    
    [self.scrollView addSubview:[self logoView]];
    
    for(int i = 0; i < [images count]; i++) {
        UIView *swipedView = [self swipedViewWithCaption:[self.captions objectAtIndex:i] andScreenShot:[images objectAtIndex:i]];
        CGRect frame = swipedView.frame;
        frame.origin.x = [self swipedViewWidth] * (i+1);
        swipedView.frame = frame;
        swipedView.tag = i+1;
        [self.scrollView addSubview:swipedView];
        [swipedView release];
    }
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.pageControl.numberOfPages , self.scrollView.frame.size.height);
    [self.view addSubview:self.scrollView];
}


- (void)configureSkipButton
{
    //config the skip button
    [CloudViewUtils configureButton:self.skipButton withBackground:@"btn_skip"];
    CGRect frame = self.skipButton.frame;
    frame.origin.y = [self applicationViewHeight] - SKIP_BUTTON_BOTTOM_Y_iPhone;
    self.skipButton.frame = frame;
}

- (UIView *)buttonsContainer
{
    UIImage *signupBg = [UIImage imageNamed:@"btn_signup"];
    UIImage *loginBg = [UIImage imageNamed:@"btn_login"];
    float containerY = [self applicationViewHeight] - SIGNUP_LOGIN_BUTTON_BOTTOM_Y_iPhone;
    float orLabelSize = 12;
    float orLabelYMinus = 24; //justify to be vertically center in the container
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        signupBg = [UIImage imageNamed:@"btn_signup_ipad"];
        loginBg = [UIImage imageNamed:@"btn_login_ipad"];
        containerY = [self applicationViewHeight] - SIGNUP_LOGIN_BUTTON_BOTTOM_Y_iPad;
        orLabelSize = 22;
        orLabelYMinus = 43;
    }
    
    UIButton *signupButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, signupBg.size.width, signupBg.size.height)];
    [signupButton setImage:signupBg forState:UIControlStateNormal];
    [signupButton addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(signupBg.size.width, 0, loginBg.size.width, loginBg.size.height)];
    [loginButton setImage:loginBg forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    [CloudViewUtils configure:signupButton withTitle:@"Sign Up" andSubtitle:@"Create an account"];
    [CloudViewUtils configure:loginButton withTitle:@"Log In" andSubtitle:@"Already an account"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, signupBg.size.width + loginBg.size.width, signupBg.size.height)];
    
    UILabel *orLabel = [[UILabel alloc] init];
    orLabel.text = @"or";
    orLabel.backgroundColor = [UIColor clearColor];
    orLabel.font = [UIFont fontWithName:@"Helvetica" size:orLabelSize];
    orLabel.textColor = [UIColor whiteColor];
    CGSize size = [orLabel.text sizeWithAttributes:@{NSFontAttributeName: orLabel.font}];
    CGRect frame = CGRectMake(0,0,size.width, size.width);
    frame.origin.x = signupBg.size.width - size.width/2 + 1;
    frame.origin.y = (view.frame.size.height - orLabelYMinus - orLabel.frame.size.height)/2;
    orLabel.frame = frame;
    
    [view addSubview:signupButton];
    [view addSubview:loginButton];
    [view addSubview:orLabel];
    
    [orLabel release];
    [signupButton release];
    [loginButton release];
    
    frame = view.frame;
    frame.origin.x = (self.view.frame.size.width - frame.size.width)/2;
    frame.origin.y = containerY;
    view.frame = frame;
    
    view.tag = WELCOME_BUTTON_CONTAINER_TAG;
    
    return view;
}

- (void)insertSeparatorLine
{
    UIImage *image = [UIImage imageNamed:@"welcome_separator"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, image.size.height)];
    imageView.image = image;
    float imageY;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        imageY = [self applicationViewHeight] - SEPARATOR_LINE_BOTTOM_Y_iPad - image.size.height;
    } else {
        imageY = [self applicationViewHeight] - SEPARATOR_LINE_BOTTOM_Y_iPhone - image.size.height;
    }
    
    CGRect frame = imageView.frame;
    frame.origin.y = imageY;
    imageView.frame = frame;
    imageView.tag = WELCOME_SEPARATOR_TAG;
    [self.view addSubview:imageView];
    [imageView release];
}
#pragma mark Utils
- (UIView *)logoView
{
    NSString *nibName = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"LogoSlogan_iPad" : @"LogoSlogan_iPhone";
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:nibName
                                                    owner:self options:nil];
    LogoSlogan *logoSlogan;
    for (id object in bundle) {
        if ([object isKindOfClass:[LogoSlogan class]]) {
            logoSlogan = (LogoSlogan *)object;
        }
    }
    logoSlogan.backgroundColor = [UIColor clearColor];
    CGRect frame = logoSlogan.frame;
    frame.origin.x = ([self swipedViewWidth] - frame.size.width)/2;
    frame.origin.y = ([self swipedViewHeight] - frame.size.height)/2;
    
    //iPhone
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        frame.origin.y = frame.origin.y + 30;
    }
    
    logoSlogan.frame = frame;
    logoSlogan.tag = FIRST_SWIPED_SCREEN_TAG;

    return logoSlogan;
}

- (UIView *)swipedViewWithCaption:(NSString *)caption andScreenShot:(NSString *)imageName
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self swipedViewWidth], [self swipedViewHeight])];
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? SCREENSHOT_Y_iPad : SCREENSHOT_Y, image.size.width, image.size.height)];
    imageView.image = image;
    [view addSubview:imageView];
    [imageView release];
    
    UILabel *captionLabel = [[UILabel alloc] init];
    captionLabel.text = caption;
    captionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 23 : 13];
    captionLabel.backgroundColor = [UIColor clearColor];
    captionLabel.textColor = [UIColor whiteColor];
    captionLabel.textAlignment = NSTextAlignmentCenter;
    CGSize labelSize = [captionLabel.text sizeWithAttributes:@{NSFontAttributeName: captionLabel.font}];
    float captionX = (view.frame.size.width - labelSize.width) / 2;
    [captionLabel setFrame:CGRectMake(captionX, CAPTION_Y, labelSize.width, labelSize.height)];
    
    [view addSubview:captionLabel];
    [captionLabel release];
    
    return view;
}

- (NSArray *)screenshots
{
    NSArray *res = [[NSArray alloc] init];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            res = [NSArray arrayWithObjects:@"ipad-activity-stream-landscape",@"ipad-activity-details-landscape", @"ipad-apps-landscape", @"ipad-documents-landscape", nil];
        } else {
            res = [NSArray arrayWithObjects:@"ipad-activity-stream-portrait",@"ipad-activity-details-portrait",@"ipad-apps-portrait",@"ipad-documents-portrait", nil];
        }
        
    } else {
        if([eXoViewController isHighScreen]) {
            res = [NSArray arrayWithObjects:@"iphone5-activity-stream",@"iphone5-activity-details", @"iphone5-apps", @"iphone5-documents", nil];
        } else {
            res = [NSArray arrayWithObjects:@"iphone-activity-stream",@"iphone-activity-details", @"iphone-apps", @"iphone-documents", nil];
        }
    }
    return res;
}

- (float)swipedViewHeight
{
    float height;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        height = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? SWIPED_VIEW_HEIGHT_LANDSCAPE_iPad : SWIPED_VIEW_HEIGHT_PORTRAIT_iPad;
    } else {
        height = [eXoViewController isHighScreen] ? SWIPED_VIEW_HEIGHT_iPhone5 : SWIPED_VIEW_HEIGHT_iPhone;
    }
    return height;
}

- (float)swipedViewWidth
{
    float width;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        width = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? SCR_WIDTH_LSCP_IPAD : SCR_WIDTH_PRTR_IPAD;
    } else {
        width = 320;
    }
    return width;
}

- (float)applicationViewHeight {
    float height;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        height =  UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? SCR_HEIGHT_LSCP_IPAD : SCR_HEIGHT_PRTR_IPAD;
    } else {
        height =  [eXoViewController isHighScreen] ? iPHONE_5_SCREEN_HEIGHT : iPHONE_SCREEN_HEIGH;
    }
    return height;
}
@end
