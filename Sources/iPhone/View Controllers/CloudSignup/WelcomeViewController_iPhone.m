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
#import "eXoViewController.h"

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
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:alreadyAccountViewController];
   
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentModalViewController:navigationController animated:YES];
}

@end
