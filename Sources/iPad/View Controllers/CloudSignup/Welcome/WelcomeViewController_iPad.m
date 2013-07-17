//
//  WelcomeViewController_iPad.m
//  eXo Platform
//
//  Created by vietnq on 7/5/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "WelcomeViewController_iPad.h"
#import "SignUpViewController_iPad.h"
#import "AlreadyAccountViewController_iPad.h"
#import "eXoNavigationController.h"
#import "AppDelegate_iPad.h"
@interface WelcomeViewController_iPad ()

@end

@implementation WelcomeViewController_iPad

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews
{
    self.scrollView.contentSize = CGSizeMake(768 * 4, SWIPED_VIEW_HEIGHT_iPad);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)skipCloudSignup:(id)sender
{
    if(self.shouldBackToSetting) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        AppDelegate_iPad *appDelegate = [AppDelegate_iPad instance];
        appDelegate.window.rootViewController = appDelegate.viewController;
    }
}
- (void)signup:(id)sender
{
    SignUpViewController_iPad *signUpVC = [[[SignUpViewController_iPad alloc] initWithNibName:@"SignUpViewController_iPad" bundle:nil] autorelease];
    signUpVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    signUpVC.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:signUpVC animated:YES];
}

- (void)login:(id)sender
{
    AlreadyAccountViewController_iPad *alreadyVC = [[[AlreadyAccountViewController_iPad alloc] initWithNibName:@"AlreadyAccountViewController_iPad" bundle:nil] autorelease];
    eXoNavigationController *navCon = [[[eXoNavigationController alloc] initWithRootViewController:alreadyVC] autorelease];
    
    navCon.modalPresentationStyle = UIModalPresentationFormSheet;
    navCon.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:navCon animated:YES];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}
@end
