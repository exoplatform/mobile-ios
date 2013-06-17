//
//  MailInputViewController.m
//  eXo Platform
//
//  Created by vietnq on 6/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "MailInputViewController.h"
#import "CloudUtils.h"
#import "ExoCloudProxy.h"
@interface MailInputViewController ()

@end

@implementation MailInputViewController
@synthesize errorLabel;
@synthesize mailTf;

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
    self.errorLabel.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    [errorLabel release];
    [mailTf release];
}

- (void)createAccount:(id)sender
{
    if([CloudUtils checkEmailFormat:self.mailTf.text]) {
        ExoCloudProxy *cloudProxy = [ExoCloudProxy sharedInstance];
        CloudResponse cloudResponse = [cloudProxy signUpWithEmail:self.mailTf.text];
        [self handleCloudResponse:cloudResponse];
    
    } else {
        self.errorLabel.text = @"Incorrect email format";
    }
}


- (void)showGreeting
{
    UIView *greetingView = [[[self.view superview] subviews] objectAtIndex:1];
    [UIView transitionFromView:self.view toView:greetingView duration:0.5f options:UIViewAnimationOptionCurveEaseIn completion:^(BOOL finished) {
        self.view.hidden = YES;
        greetingView.hidden = NO;
    }];
}

- (void)handleCloudResponse:(CloudResponse)cloudResponse
{
    if(cloudResponse == EMAIL_SENT) {
        [self showGreeting];
    } else {
        NSLog(@"sign up failed");
    }
}

@end
