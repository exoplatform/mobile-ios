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
#import "defines.h"

#define SWIPED_VIEW_WIDTH 320
#define SWIPED_VIEW_HEIGHT 360
#define SCREENSHOT_Y 40
#define CAPTION_Y  30

@interface WelcomeViewController_iPhone ()
@end

@implementation WelcomeViewController_iPhone
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
    
    images = [NSArray arrayWithObjects:@"screenshot2",@"screenshot2",@"screenshot2", nil];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture"]];
        
    // Do any additional setup after loading the view from its nib.
    
    [self initSwipedElements];
    
    [self configureSkipButton];
        
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
        AuthenticateViewController_iPhone *authenticateVC = [[AuthenticateViewController_iPhone alloc] initWithNibName:@"AuthenticateViewController_iPhone" bundle:nil];
        [appDelegate.navigationController setViewControllers:[NSArray arrayWithObject:authenticateVC]];
        [authenticateVC release];
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
}

- (void)initSwipedElements
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, SWIPED_VIEW_WIDTH, SWIPED_VIEW_HEIGHT)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
    self.pageControl.numberOfPages = 4;
    self.pageControl.currentPage = 0;
    CGRect scrollFrame = self.scrollView.frame;
    scrollFrame.origin.y = 0;
    self.scrollView.frame = scrollFrame;
    
    [self.scrollView addSubview:[self logoView]];
    
    for(int i = 0; i < [images count]; i++) {
        UIView *swipedView = [self swipedViewWithCaption:[self.captions objectAtIndex:i] andScreenShot:[images objectAtIndex:i]];
        CGRect frame = swipedView.frame;
        frame.origin.x = SWIPED_VIEW_WIDTH * (i+1);
        swipedView.frame = frame;
        [self.scrollView addSubview:swipedView];
        [swipedView release];
    }
    self.scrollView.contentSize = CGSizeMake(SWIPED_VIEW_WIDTH * 4, SWIPED_VIEW_HEIGHT);
    [self.view addSubview:self.scrollView];
}

#pragma mark Utils
- (UIView *)logoView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SWIPED_VIEW_WIDTH, SWIPED_VIEW_HEIGHT)];
    UIImage *logo = [UIImage imageNamed:@"logo"];
    float imageX = (SWIPED_VIEW_WIDTH - logo.size.width) / 2;
    float imageY = (SWIPED_VIEW_HEIGHT - logo.size.height) / 2;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:logo];
    imageView.frame = CGRectMake(imageX,imageY,logo.size.width, logo.size.height);
    [view addSubview:imageView];
    [imageView release];
    return view;
}

- (UIView *)swipedViewWithCaption:(NSString *)caption andScreenShot:(NSString *)imageName
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SWIPED_VIEW_WIDTH, SWIPED_VIEW_HEIGHT)];
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREENSHOT_Y, image.size.width/2, image.size.height/2)];
    imageView.image = image;
    [view addSubview:imageView];
    [imageView release];
    
    UILabel *captionLabel = [[UILabel alloc] init];
    captionLabel.text = caption;
    captionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    captionLabel.backgroundColor = [UIColor clearColor];
    captionLabel.textColor = [UIColor lightGrayColor];
    captionLabel.textAlignment = NSTextAlignmentCenter;
    CGSize labelSize = [captionLabel.text sizeWithFont:captionLabel.font];
    float captionX = (SWIPED_VIEW_WIDTH - labelSize.width) / 2;
    [captionLabel setFrame:CGRectMake(captionX, CAPTION_Y, labelSize.width, labelSize.height)];
    
    [view addSubview:captionLabel];
    [captionLabel release];
    
    return view;
}

@end
