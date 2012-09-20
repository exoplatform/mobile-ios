//
//  SettingsViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 13/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginProxy.h"
#import "PlatformServerVersion.h"
#import "eXoTableViewController.h"
@class UserPreferencesManager;

@protocol ServerManagerProtocol <NSObject>
- (BOOL)addServerObjWithServerName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl;
- (BOOL)editServerObjAtIndex:(int)index withSeverName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl;
- (BOOL)deleteServerObjAtIndex:(int)index;
@end

@protocol SettingsDelegateProcotol

-(void)doneWithSettings;

@end

@interface SettingsViewController : eXoTableViewController <LoginProxyDelegate, ServerManagerProtocol> {
    
    BOOL                            bRememberMe;
	BOOL                            bAutoLogin;
    BOOL                            bVersionServer;
	NSString*                       languageStr;
	
	UISwitch*                       rememberMe;
	UISwitch*                       autoLogin;
    UISwitch*                       _rememberSelectedStream;
    UISwitch*                       _showPrivateDrive;
    
    id<SettingsDelegateProcotol>    _settingsDelegate;
    
    NSArray                         *_listOfSections;
    
}

@property (assign) id<SettingsDelegateProcotol>    settingsDelegate;


-(void)startRetrieve;
-(void)loadSettingsInformations;
-(void)saveSettingsInformations;
-(void)reloadSettingsWithUpdate;
-(void)enableDisableAutoLogin:(id)sender;

@end
