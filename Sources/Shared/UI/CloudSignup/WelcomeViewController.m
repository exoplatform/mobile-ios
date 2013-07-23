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
#import "eXoViewController.h"
#import "LogoSlogan.h"
#import "defines.h"
#import "eXoViewController.h"
@interface WelcomeViewController ()

@end

@implementation WelcomeViewController
@synthesize delegate;
@synthesize skipButton, pageControl, scrollView, shouldDisplayLoginView, receivedEmail;
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
    
    self.captions = [NSArray arrayWithObjects:@"Follow what your connections are sharing", @"Browse and edit your files", @"Interact with your personal dashboards", nil];
    
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
    [receivedEmail release];
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
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)initSwipedElements
{
    
    self.pageControl.numberOfPages = 4;
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
    
    images = [self screenshots];
    
    for(int i = 0; i < [images count]; i++) {
        UIView *swipedView = [self swipedViewWithCaption:[self.captions objectAtIndex:i] andScreenShot:[images objectAtIndex:i]];
        CGRect frame = swipedView.frame;
        frame.origin.x = [self swipedViewWidth] * (i+1);
        swipedView.frame = frame;
        swipedView.tag = i+1;
        [self.scrollView addSubview:swipedView];
        [swipedView release];
    }
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * ([images count] + 1), self.scrollView.frame.size.height);
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
    UIImage *signupBg = [UIImage imageNamed:@"btn_blue"];
    UIImage *loginBg = [UIImage imageNamed:@"btn_black"];
    
    UIButton *signupButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, signupBg.size.width, signupBg.size.height)];
    [signupButton setImage:signupBg forState:UIControlStateNormal];
    [signupButton addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(signupBg.size.width, 0, signupBg.size.width, signupBg.size.height)];
    [loginButton setImage:loginBg forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    [CloudViewUtils configure:signupButton withTitle:@"Sign Up" andSubtitle:@"Create an account"];
    [CloudViewUtils configure:loginButton withTitle:@"Log In" andSubtitle:@"Already an account"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, signupBg.size.width + loginBg.size.width, signupBg.size.height)];
    
    UILabel *orLabel = [[UILabel alloc] init];
    orLabel.text = @"or";
    orLabel.backgroundColor = [UIColor clearColor];
    orLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    orLabel.textColor = [UIColor whiteColor];
    orLabel.frame = CGRectMake(view.frame.size.width/2 - 5, view.frame.size.height/2 - 12, 15,10);
    
    [view addSubview:signupButton];
    [view addSubview:loginButton];
    [view addSubview:orLabel];
    
    [orLabel release];
    [signupButton release];
    [loginButton release];
    
    CGRect frame = view.frame;
    frame.origin.x = (self.view.frame.size.width - frame.size.width)/2;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        frame.origin.y = [self applicationViewHeight] - SIGNUP_LOGIN_BUTTON_BOTTOM_Y_iPad;
    } else {
        frame.origin.y = [self applicationViewHeight] - SIGNUP_LOGIN_BUTTON_BOTTOM_Y_iPhone;
    }
    
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
    frame.origin.y = ([self swipedViewHeight] - frame.size.height)/2 + 30;
    logoSlogan.frame = frame;
    logoSlogan.tag = FIRST_SWIPED_SCREEN_TAG;

    return logoSlogan;
}

- (UIView *)swipedViewWithCaption:(NSString *)caption andScreenShot:(NSString *)imageName
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self swipedViewWidth], [self swipedViewHeight])];
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? SCREENSHOT_Y + 10 : SCREENSHOT_Y, image.size.width, image.size.height)];
    imageView.image = image;
    [view addSubview:imageView];
    [imageView release];
    
    UILabel *captionLabel = [[UILabel alloc] init];
    captionLabel.text = caption;
    captionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 20 : 13];
    captionLabel.backgroundColor = [UIColor clearColor];
    captionLabel.textColor = [UIColor whiteColor];
    captionLabel.textAlignment = NSTextAlignmentCenter;
    CGSize labelSize = [captionLabel.text sizeWithFont:captionLabel.font];
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
            res = [NSArray arrayWithObjects:@"ipad-activity-stream-landscape",@"ipad-documents-landscape",@"ipad-apps-landscape", nil];
        } else {
            res = [NSArray arrayWithObjects:@"ipad-activity-stream-portrait",@"ipad-documents-portrait",@"ipad-apps-portrait", nil];
        }
        
    } else {
        if([eXoViewController isHighScreen]) {
            res = [NSArray arrayWithObjects:@"iphone5-activity-stream",@"iphone5-documents",@"iphone5-apps", nil];
        } else {
            res = [NSArray arrayWithObjects:@"iphone-activity-stream",@"iphone-documents",@"iphone-apps", nil];
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
