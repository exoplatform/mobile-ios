//
//  MailInputViewController.m
//  eXo Platform
//
//  Created by vietnq on 6/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "MailInputViewController.h"

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
    if([self mailIsCorrect:self.mailTf.text]) {
        [self showGreeting];
    } else {
        self.errorLabel.text = @"Incorrect email format";
    }
}
// check if a given mail is in correct format
- (BOOL)mailIsCorrect:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]{2,}\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

- (void)showGreeting
{
    UIView *greetingView = [[[self.view superview] subviews] objectAtIndex:1];
    [UIView transitionFromView:self.view toView:greetingView duration:0.5f options:UIViewAnimationOptionCurveEaseIn completion:^(BOOL finished) {
        self.view.hidden = YES;
        greetingView.hidden = NO;
    }];
}
@end
