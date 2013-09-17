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
#import "WelcomeViewController.h"

@class UserPreferencesManager;

@protocol ServerManagerProtocol <NSObject>
- (BOOL)addServerObjWithServerName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl withUsername:(NSString *)username andPassword:(NSString *)password;
- (BOOL)editServerObjAtIndex:(int)index withSeverName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl withUsername:(NSString *)username andPassword:(NSString *)password;
- (BOOL)deleteServerObjAtIndex:(int)index;
@end

@protocol SettingsDelegateProcotol

-(void)doneWithSettings;

@end

@interface SettingsViewController : eXoTableViewController <LoginProxyDelegate, ServerManagerProtocol, WelcomeViewControllerDelegate> {
    
    BOOL                            bVersionServer;
	NSString*                       languageStr;
	
	UISwitch*                       rememberMe;
	UISwitch*                       autoLogin;
    UISwitch*                       _rememberSelectedStream;
    UISwitch*                       _showPrivateDrive;
    
    id<SettingsDelegateProcotol>    _settingsDelegate;
    
    NSMutableArray                  *_listOfSections;
    
}

@property (assign) id<SettingsDelegateProcotol>    settingsDelegate;


-(void)startRetrieve;
-(void)enableDisableAutoLogin:(id)sender;

@end
