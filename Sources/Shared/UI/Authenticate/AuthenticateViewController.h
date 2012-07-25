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
}

@property (nonatomic, readonly) SSHUDView *hud; // display loading
@property (nonatomic, retain) JMTabView *tabView;

- (void)doSignIn;	//Login progress
- (void) initTabsAndViews;

// method for managing keyboard behaviours
- (void)dismissKeyboard;
@end
