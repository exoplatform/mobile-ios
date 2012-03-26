//
//  AuthenticateViewController.h
//  Authenticate Screen
//
//  Created by Tran Hoai Son on 5/8/09.
//  Copyright home 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticateViewController.h"
#import "SettingsViewController.h"



//Login page for iPhone
@interface AuthenticateViewController_iPhone : AuthenticateViewController <SettingsDelegateProcotol> {

    SettingsViewController* _settingsViewController;
}


@end
