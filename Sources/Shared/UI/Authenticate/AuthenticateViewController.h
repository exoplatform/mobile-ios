//
//  AuthenticateViewController.h
//  Authenticate Screen
//
//  Created by Tran Hoai Son on 5/8/09.
//  Copyright home 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSHUDView.h"
#import "LoginProxy.h"
#import "ServerPreferencesManager.h"
#import "CredentialsViewController.h"
#import "ServerListViewController.h"
#import "JMTabView.h"

typedef enum {
    AuthenticateTabItemCredentials = 0,
    AuthenticateTabItemServerList = 1
} AuthenticateTabItem;


//Login page

@interface AuthenticateViewController : UIViewController <LoginProxyDelegate, JMTabViewDelegate> 
{
	NSString*                   _strBSuccessful;	//Login status
    IBOutlet UIButton*          _btnSettings;
    CredentialsViewController * _credViewController;
    ServerListViewController * _servListViewController;
    NSDictionary*				_dictLocalize;	//Language dictionary
	int							_intSelectedLanguage;	//Language index
    BOOL                        _bAutoLoginIsDisabled; //Disable Auto Login to sign out but doesn't update the Auto Login setting
    NSString*                   _tempUsername; // Username and Password that have been
    NSString*                   _tempPassword; // typed by the user
}

@property (nonatomic, readonly) SSHUDView *hud; // display loading
@property (nonatomic, retain) JMTabView *tabView;

- (void)doSignIn;	//Login progress
- (CredentialsViewController*) credentialsViewController;
- (void) initTabsAndViews;
- (void)disableAutoLogin:(BOOL)autoLogin;
- (BOOL)autoLoginIsDisabled;
- (void)doneWithSettings;
- (void)saveTempUsernamePassword;

// method for managing keyboard behaviours
- (void)dismissKeyboard;
@end
