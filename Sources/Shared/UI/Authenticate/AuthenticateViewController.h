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
#import "ApplicationPreferencesManager.h"
#import "CredentialsViewController.h"
#import "ServerListViewController.h"
#import "AuthenticateTabView.h"
#import "ExoCloudProxy.h"

typedef NS_ENUM(NSInteger, AuthenticateTabItem) {
    AuthenticateTabItemCredentials = 0,
    AuthenticateTabItemServerList = 1
} ;


//Login page

@interface AuthenticateViewController : UIViewController <LoginProxyDelegate, JMTabViewDelegate, UIAlertViewDelegate, ExoCloudProxyDelegate>
{
	NSString*                   _strBSuccessful;	//Login status
    IBOutlet UIButton*          _btnSettings;
    CredentialsViewController * _credViewController;
    ServerListViewController *  _servListViewController;
    NSDictionary*				_dictLocalize;	//Language dictionary
	int							_intSelectedLanguage;	//Language index
    int                         _selectedTabIndex;
    BOOL                        _bAutoLoginIsDisabled; //Disable Auto Login to sign out but doesn't update the Auto Login setting
    NSString*                   _tempUsername; // Username and Password that have been
    NSString*                   _tempPassword; // typed by the user
}

@property (nonatomic, readonly) SSHUDView *hud; // display loading
@property (nonatomic, retain) AuthenticateTabView *tabView;
@property (nonatomic, retain) CredentialsViewController *credentialsViewController;
@property (nonatomic, retain) ServerListViewController *accountListViewController;

- (void)doSignIn;	//Login progress
- (void) initTabsAndViews;
- (void)disableAutoLogin:(BOOL)autoLogin;
@property (nonatomic, readonly) BOOL autoLoginIsDisabled;
- (void)doneWithSettings;
- (void)saveTempUsernamePassword;
- (void)showHideSwitcherTab;

// method for managing keyboard behaviours
- (void)dismissKeyboard;
- (void)updateAfterLogOut;
- (void)autoFillCredentials;
@end
