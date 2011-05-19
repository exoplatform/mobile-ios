//
//  LoginViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 5/31/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSHUDView.h"

@class Checkbox;
@class SupportViewController;
@class iPadSettingViewController;
@class iPadServerManagerViewController;
@class iPadServerAddingViewController;
@class iPadServerEditingViewController;
@class ServerObj;

//Login page
@interface LoginViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {
	
	id										_delegate;

	NSString*								_strUsername;	//Username
	NSString*								_strPassword;	//Passowrd
	
	BOOL									_bRememberMe;	//Is remember
	BOOL									_bAutoSignIn;	//Is auto sign in
	BOOL									_bMoveUp;	// Is move UI up
	
	NSDictionary*							_dictLocalize;	//Language dictionary
	int										_intSelectedLanguage;	//Language index
    
    
    BOOL                                    bRememberMe;        //Remember
	BOOL                                    bAutoLogin;         //Autologin
    BOOL                                    isFirstTimeLogin;	//Is first time login
    NSString*                               _strBSuccessful;	//Login status
    
    IBOutlet UILabel*						_lbSigningInStatus;	//Loading label
    IBOutlet UIActivityIndicatorView*		_actiSigningIn;	//Loading indicator
    
    IBOutlet UIButton*          _btnAccount;
    IBOutlet UIButton*          _btnServerList;
    IBOutlet UILabel*           _lbUsername;
    IBOutlet UILabel*           _lbPassword;
    IBOutlet UITextField*       _txtfUsername;
    IBOutlet UITextField*       _txtfPassword;
    IBOutlet UIButton*          _btnLogin;
    IBOutlet UIButton*          _btnSettings;
    IBOutlet UIView*            _vLoginView;
    IBOutlet UIView*            _vAccountView;
    IBOutlet UIView*            _vServerListView;
    IBOutlet UITableView*       _tbvlServerList;
    IBOutlet UIView*            _vContainer;
    
    NSMutableArray*             _arrServerList;
    NSString*                   _strHost;
    int                         _intSelectedServer;
    
    iPadSettingViewController*          _iPadSettingViewController;
    iPadServerManagerViewController*    _iPadServerManagerViewController;
    iPadServerAddingViewController*     _iPadServerAddingViewController;
    iPadServerEditingViewController*    _iPadServerEditingViewController;
    
    NSMutableArray*             _arrViewOfViewControllers;
    UIInterfaceOrientation      _interfaceOrientation;
    SSHUDView*                  _hud;
}

@property (nonatomic, retain) NSDictionary* _dictLocalize;

- (void)setDelegate:(id)delegate;	//Set delegate
- (void)setPreferenceValues;	//Set prefrrences
- (void)localize;	//Set language dictionary
- (int)getSelectedLanguage;	//Get current language
- (NSDictionary*)getLocalization;	//Get language dictionary
- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation;	//Change device orientation

- (void)moveUIControls:(int)intOffset;
- (void)moveUp:(BOOL)bUp;
- (void)doSignIn;
- (void)startSignInProgress;
- (void)signInSuccesfully;
- (void)signInFailed;

- (IBAction)onSignInBtn:(id)sender;	//Login action
- (IBAction)onSettingBtn:(id)sender;	//Setting action
- (IBAction)onBtnAccount:(id)sender;
- (IBAction)onBtnServerList:(id)sender;

- (void)pushViewIn:(UIView*)view;
- (void)pullViewOut:(UIView*)viewController;
- (void)moveView;
- (void)onBackDelegate;
- (void)jumpToViewController:(int)index;
- (void)showiPadServerManagerViewController;
- (void)showiPadServerAddingViewController;
- (void)showiPadServerEditingViewControllerWithServerObj:(ServerObj*)serverObj andIndex:(int)index;
- (void)editServerObjAtIndex:(int)intIndex withSeverName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl;
- (void)deleteServerObjAtIndex:(int)intIndex;
@end
