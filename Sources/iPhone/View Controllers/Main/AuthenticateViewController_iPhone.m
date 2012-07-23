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
#import "LanguageHelper.h"


@implementation AuthenticateViewController_iPhone


#pragma mark - Object Management
-(void)dealloc {
    
    [_settingsViewController release];
    _settingsViewController = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_credViewController.bAutoLogin)
    {
       // _vContainer.alpha = 1;
        [_credViewController onSignInBtn:nil];
    }
    else
    {
        //Start the animation to display the loginView
        [UIView animateWithDuration:0.5 
                         animations:^{
         //                    _vContainer.alpha = 1;
                         }
         ];
    }    

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
    [super platformVersionCompatibleWithSocialFeatures:compatibleWithSocial withServerInformation:platformServerVersion];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if(platformServerVersion != nil){
        //Setup Version Platfrom and Application
        
        [userDefaults setObject:platformServerVersion.platformVersion forKey:EXO_PREFERENCE_VERSION_SERVER];
        [userDefaults setObject:platformServerVersion.platformEdition forKey:EXO_PREFERENCE_EDITION_SERVER];
        if([platformServerVersion.isMobileCompliant boolValue]){
            [self.hud completeAndDismissWithTitle:Localize(@"Success")];
            AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
            appDelegate.isCompatibleWithSocial = compatibleWithSocial;
            [appDelegate performSelector:@selector(showHomeSidebarViewController) withObject:nil afterDelay:1.0];
        } else {
            [self.hud failAndDismissWithTitle:Localize(@"Error")];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"Error") 
                                                            message:Localize(@"NotCompliant") 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
    } else {
        [self.hud failAndDismissWithTitle:Localize(@"Error")];
        [userDefaults setObject:@"" forKey:EXO_PREFERENCE_VERSION_SERVER];
        [userDefaults setObject:@"" forKey:EXO_PREFERENCE_EDITION_SERVER];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"Error") 
                                                        message:Localize(@"NotCompliant") 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    [userDefaults synchronize];
}

#pragma mark - TextField delegate 

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _credViewController.txtfUsername) 
    {
        [_credViewController.txtfPassword becomeFirstResponder];
    }
    else
    {    
        [_credViewController.txtfPassword resignFirstResponder];
                
        [_credViewController onSignInBtn:nil];
    }    
	return YES;
}

#pragma mark - Settings Delegate methods

- (void)doneWithSettings {
    [_btnSettings setTitle:Localize(@"Settings") forState:UIControlStateNormal];
    [_credViewController.btnLogin setTitle:Localize(@"SignInButton") forState:UIControlStateNormal];
    [_servListViewController.tbvlServerList reloadData];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


@end


