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

#define kHeigthNeededToGoUpSubviewsWhenEditingUsername -85
#define kHeigthNeededToGoUpSubviewsWhenEditingPassword -150

@implementation AuthenticateViewController_iPhone


#pragma mark - Object Management
-(void)dealloc {
    
    [_settingsViewController release];
    _settingsViewController = nil;
    
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_bAutoLogin)
    {
        _vContainer.alpha = 1;
        [self onSignInBtn:nil];
    }
    else
    {
        //Start the animation to display the loginView
        [UIView animateWithDuration:1.0 
                         animations:^{
                             _vContainer.alpha = 1;
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
    [_hud completeAndDismissWithTitle:Localize(@"Success")];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if(platformServerVersion != nil){
        //Setup Version Platfrom and Application
        [userDefaults setObject:platformServerVersion.platformVersion forKey:EXO_PREFERENCE_VERSION_SERVER];
        if([platformServerVersion.isMobileCompliant boolValue]){
            AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
            appDelegate.isCompatibleWithSocial = compatibleWithSocial;
            [appDelegate performSelector:@selector(showHomeViewController) withObject:nil afterDelay:1.0];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"Error") 
                                                            message:Localize(@"NotCompliant") 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
    } else {
        [userDefaults setObject:@"" forKey:EXO_PREFERENCE_VERSION_SERVER];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
    //Check the textfield to go up the content of the view
    CGRect frameToGo = self.view.frame;
    
    if (textField == _txtfUsername) {
        frameToGo.origin.y = kHeigthNeededToGoUpSubviewsWhenEditingUsername;
    } else {
        frameToGo.origin.y = kHeigthNeededToGoUpSubviewsWhenEditingPassword;
    }
    
    [UIView animateWithDuration:0.3 
                     animations:^{
                         self.view.frame = frameToGo;
                     }
     ];
    
	return YES;   
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _txtfUsername) 
    {
        [_txtfPassword becomeFirstResponder];
    }
    else
    {    
        [_txtfPassword resignFirstResponder];
        
        //Replace the frame at the good position
        CGRect frameToGo = self.view.frame;
        frameToGo.origin.y = 0;
        
        [UIView animateWithDuration:0.3 
                         animations:^{
                             self.view.frame = frameToGo;
                         }
         ];
        
        [self onSignInBtn:nil];
    }    
	return YES;
}

#pragma mark - Settings Delegate methods

- (void)doneWithSettings {
    [_btnSettings setTitle:Localize(@"Settings") forState:UIControlStateNormal];
    [_btnLogin setTitle:Localize(@"SignInButton") forState:UIControlStateNormal];
    [_tbvlServerList reloadData];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


@end


