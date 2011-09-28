//
//  AuthenticateViewController.m
//  Authenticate Screen
//
//  Created by Tran Hoai Son on 5/8/09.
//  Copyright EXO-Platform 2009. All rights reserved.
//

#import "AuthenticateViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "defines.h"

@implementation AuthenticateViewController_iPhone


#pragma mark - Object Management
-(void)dealloc {
    
    [_settingsViewController release];
    _settingsViewController = nil;
    
    [super dealloc];
}


- (IBAction)onSettingBtn
{
    if (_settingsViewController == nil) {
        
        _settingsViewController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        _settingsViewController.settingsDelegate = self;
    }
    [_settingsViewController startRetrieve];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_settingsViewController];
    
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController presentModalViewController:navController animated:YES];
    
    
}

- (void)platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion {
    
    //Setup Version Platfrom and Application
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
	[userDefaults setObject:platformServerVersion.platformVersion forKey:EXO_PREFERENCE_VERSION_SERVER];
    
	[userDefaults synchronize];
    
    [_hud completeAndDismissWithTitle:@"Success..."];
    
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    appDelegate.isCompatibleWithSocial = compatibleWithSocial;
    [appDelegate performSelector:@selector(showHomeViewController) withObject:nil afterDelay:1.0];
}


#pragma mark - Settings Delegate methods

- (void)doneWithSettings {
    [_tbvlServerList reloadData];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


@end


