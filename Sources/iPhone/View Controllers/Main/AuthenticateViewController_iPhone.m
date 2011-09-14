//
//  AuthenticateViewController.m
//  Authenticate Screen
//
//  Created by Tran Hoai Son on 5/8/09.
//  Copyright EXO-Platform 2009. All rights reserved.
//

#import "AuthenticateViewController_iPhone.h"
//#import "eXoSettingViewController.h"
#import "AppDelegate_iPhone.h"

@implementation AuthenticateViewController_iPhone


- (IBAction)onSettingBtn
{
    /*
    eXoSettingViewController *setting = [[eXoSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [setting setDelegate:self];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:setting];
    [setting release];
    
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController presentModalViewController:navController animated:YES];
     */
}

- (void)platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial {
    
    [_hud completeAndDismissWithTitle:@"Success..."];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    appDelegate.isCompatibleWithSocial = compatibleWithSocial;
    [appDelegate performSelector:@selector(showHomeViewController) withObject:nil afterDelay:1.0];
    
}


@end


