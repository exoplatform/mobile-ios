//
//  SettingsViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 13/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServerManagerViewController;


@protocol SettingsDelegateProcotol <NSObject>

-(void)doneWithSettings;

@end

@interface SettingsViewController : UITableViewController {
	    
    BOOL                            bRememberMe;
	BOOL                            bAutoLogin;
	NSString*                       languageStr;
	
	UISwitch*                       rememberMe;
	UISwitch*                       autoLogin;
	
    NSMutableArray*                 _arrServerList;
    int                             _intSelectedServer;
    
    UIBarButtonItem*                _doneBarButtonItem;
    ServerManagerViewController*    _serverManagerViewController;

    id<SettingsDelegateProcotol>    _settingsDelegate;
    
}

@property (assign) id<SettingsDelegateProcotol>    settingsDelegate;



-(void)loadSettingsInformations;
-(void)saveSettingsInformations;
-(void)reloadSettingsWithUpdate;


@end
