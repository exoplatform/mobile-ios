//
//  LoginViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 5/31/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSHUDView.h"
#import "SettingsViewController_iPad.h"
#import "AuthenticateViewController.h"

@class ServerObj;

//Login page
@interface AuthenticateViewController_iPad : AuthenticateViewController <SettingsDelegateProcotol>
{
	id							     _delegate;
    UINavigationController*          _modalNavigationSettingViewController;
    SettingsViewController_iPad*     _iPadSettingViewController;
    UIInterfaceOrientation           _interfaceOrientation;
}

- (void)setDelegate:(id)delegate;	//Set delegate
- (void)setPreferenceValues;	//Set prefrrences
- (void)localize;	//Set language dictionary
- (int)getSelectedLanguage;	//Get current language
- (NSDictionary*)getLocalization;	//Get language dictionary
- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation;	//Change device orientation
- (IBAction)onSettingBtn:(id)sender;	//Setting action
@end
