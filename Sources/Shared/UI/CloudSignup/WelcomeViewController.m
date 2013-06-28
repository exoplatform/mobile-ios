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

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

@synthesize skipButton, loginButton, signupButton, pageControl, scrollView, shouldDisplayLoginView, receivedEmail;
@synthesize shouldBackToSetting;

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
}

- (void)viewDidAppear:(BOOL)animated
{
    if(shouldDisplayLoginView) {
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    [loginButton release];
    [signupButton release];
    [scrollView release];
    [pageControl release];
    [self.skipButton release];
    [self.receivedEmail release];
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
- (void)scrollViewDidEndScroll:(UIScrollView *)scrollView
{
    
}

- (void)configureSkipButton
{
    //config the skip button
    UIImage *originalImage = [UIImage imageNamed:@"bg_btn_skip.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:insets];
    
    [self.skipButton setBackgroundImage:stretchableImage forState:UIControlStateNormal];
    
    [[self.skipButton layer] setBorderWidth:0.3f];
    [[self.skipButton layer] setBorderColor:[UIColor grayColor].CGColor];
    [[self.skipButton layer] setCornerRadius:3.0f];

}

- (void)configure:(UIButton *)button withTitle:(NSString *)title andSubtitle:(NSString *)subtitle
{
    
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    UIFont *subTitleFont = [UIFont fontWithName:@"Helvetica-Bold" size:8];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:titleFont];
    [titleLabel setText:title];
    [titleLabel setTextColor:[UIColor whiteColor]];
    
    float titleWidth = [[titleLabel text] sizeWithFont:titleFont].width;
    float titleX = (button.frame.size.width - titleWidth) / 2;
    [titleLabel setFrame:CGRectMake(titleX, -10, button.frame.size.width, button.frame.size.height)];
    
    [button addSubview:titleLabel];
    
    UILabel *subtitleLabel = [[UILabel alloc]init];
    [subtitleLabel setBackgroundColor:[UIColor clearColor]];
    [subtitleLabel setFont:subTitleFont];
    [subtitleLabel setText:subtitle];
    [subtitleLabel setTextColor:[UIColor whiteColor]];
    
    float subtitleWidth = [[subtitleLabel text] sizeWithFont:subTitleFont].width;
    float subtitleX = (button.frame.size.width - subtitleWidth) / 2;
    [subtitleLabel setFrame:CGRectMake(subtitleX, 3, button.frame.size.width, button.frame.size.height)];
    
    [button addSubview:subtitleLabel];
    
    [titleLabel  release];
    [subtitleLabel release];
}
@end
