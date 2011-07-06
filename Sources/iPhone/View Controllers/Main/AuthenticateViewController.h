//
//  AuthenticateViewController.h
//  Authenticate Screen
//
//  Created by Tran Hoai Son on 5/8/09.
//  Copyright home 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSHUDView.h"

//Login page
@interface AuthenticateViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> 
{
	NSString*                   _strBSuccessful;	//Login status
	UIActivityIndicatorView*    _indicator;	//Loding indicator
	UIBarButtonItem*            btnSignIn;	//Login button
	UIBarButtonItem*            btnSetting;	//Setting button
	BOOL                        endGetData;	//Check if it ends get data
	BOOL                        bRememberMe;	//Remember
	BOOL                        bAutoLogin;	//Autologin
	BOOL                        isFirstTimeLogin;	//Is first time login
	int                         _selectedLanguage;	//Current language index
	NSDictionary*               _dictLocalize;	//Language dictionary
	NSThread*                   endThread;	//Get data thread
    
    
    IBOutlet UIButton*          _btnAccount;
    IBOutlet UIButton*          _btnServerList;
    IBOutlet UITextField*       _txtfUsername;
    IBOutlet UITextField*       _txtfPassword;
    IBOutlet UIButton*          _btnLogin;
    IBOutlet UIButton*          _btnSettings;
    IBOutlet UIView*            _vAccountView;
    IBOutlet UIView*            _vServerListView;
    IBOutlet UITableView*       _tbvlServerList;
    IBOutlet UIView*            _contentView;
    
    NSMutableArray*             _arrServerList;
    NSString*                   _strHost;
    int                         _intSelectedServer;

    
    
    SSHUDView *_hud;//Heads up display

}

- (IBAction)onSignInBtn:(id)sender;	//Login action
- (IBAction)onSettingBtn;	//Setting action
- (void)login;	//Login progress
- (IBAction)onBtnAccount:(id)sender;
- (IBAction)onBtnServerList:(id)sender;
- (void)hitAtView:(UIView*)view;
@end
