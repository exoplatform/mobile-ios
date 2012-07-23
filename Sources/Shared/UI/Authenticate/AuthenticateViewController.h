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
//	BOOL                        _bRememberMe;	//Remember
//	BOOL                        _bAutoLogin;	//Autologin
  //  IBOutlet UIButton*          _btnAccount;
  //  IBOutlet UIButton*          _btnServerList;
 //   IBOutlet UITextField*       _txtfUsername;
 //   IBOutlet UITextField*       _txtfPassword;
 //   IBOutlet UIButton*          _btnLogin;
    IBOutlet UIButton*          _btnSettings;
 //   IBOutlet UIView*            _vAccountView;
 //   IBOutlet UIView*            _vServerListView;
 //   IBOutlet UITableView*       _tbvlServerList;
 //   IBOutlet UIView*            _vContainer;
 //   IBOutlet UIView*            _vLoginView;
    CredentialsViewController * _credViewController;
    ServerListViewController * _servListViewController;
        
    NSDictionary*							_dictLocalize;	//Language dictionary
	int										_intSelectedLanguage;	//Language index
}

@property (nonatomic, readonly) SSHUDView *hud; // display loading
//@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) JMTabView *tabView;

//@property (nonatomic, assign) UITextField *activeField;

//- (IBAction)onSignInBtn:(id)sender;	//Login action
- (IBAction)onSettingBtn;	//Setting action
- (void)doSignIn;	//Login progress
//- (IBAction)onBtnAccount:(id)sender;
//- (IBAction)onBtnServerList:(id)sender;
- (void)hitAtView:(UIView*)view;
- (IBAction)onHitViewBtn:(id)sender;
- (void) initTabViews;

// methods for managing keyboard behaviours
/*- (void)registerForKeyboardNotifications;
- (void)unRegisterForKeyboardNotifications;
- (void)keyboardWasShown:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)dismissKeyboard;*/
@end
