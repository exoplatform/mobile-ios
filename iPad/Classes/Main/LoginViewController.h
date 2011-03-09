//
//  LoginViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 5/31/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Checkbox;
@class SettingViewController;
@class SupportViewController;

//Login page
@interface LoginViewController : UIViewController <UITextFieldDelegate> {
	
	id										_delegate;
	//UI variables
	IBOutlet UIButton*						_btnLogo;	//Company logo
	IBOutlet UIButton*						_btnHelp;	//User guide
	IBOutlet UIButton*						_btnSetting;	//Change language
	IBOutlet UILabel*						_lbHostInstruction;	//Host title
	IBOutlet UILabel*						_lbAccountInstruction;	//Account title
	IBOutlet UILabel*						_lbHost;	//Host label
	IBOutlet UILabel*						_lbRememberMe;	//Remember label
	IBOutlet UILabel*						_lbAutoSignIn;	//Auto sign-in label
	IBOutlet UILabel*						_lbSigningInStatus;	//Loading label
	IBOutlet UIActivityIndicatorView*		_actiSigningIn;	//Loading indicator
	IBOutlet UIButton*						_btnHost;	//Host button
	IBOutlet UITextField*					_txtfHost;	//Host text box
	IBOutlet UIButton*						_btnUsername;	//Username button
	IBOutlet UITextField*					_txtfUsername;	//Username text box
	IBOutlet UIButton*						_btnPassword;	//Password button
	IBOutlet UITextField*					_txtfPassword;	//Password text box
	Checkbox*								_cbxRememberMe;	//Remember check box
	Checkbox*								_cbxAutoSignIn;	//AutoSignIn check box
	IBOutlet UIButton*						_btnSignIn;	//Sign in buuton
	UILabel*								_lbHelpTitle;	//Help label
	NSURLRequest*							_urlHelp;	//Help file URL
	UIWebView*								_wvHelp;	//Display help
	UIButton*								_btnHelpClose;	//Close help page
	
	SettingViewController*					_settingViewController;	//Setting page
	SupportViewController*					_supportViewController;	//Support page
	BOOL									_bDismissSettingView;	//Is dissmiss setting page
	UIPopoverController*					popoverController;
	UIInterfaceOrientation					_interfaceOrientation;	//Divice orientation
	//
	NSString*								_strHost;	//Host
	NSString*								_strUsername;	//Username
	NSString*								_strPassword;	//Passowrd
	
	BOOL									_bRememberMe;	//Is remember
	BOOL									_bAutoSignIn;	//Is auto sign in
	BOOL									_bMoveUp;	// Is move UI up
	
	NSDictionary*							_dictLocalize;	//Language dictionary
	int										_intSelectedLanguage;	//Language index
}


- (void)setDelegate:(id)delegate;	//Set delegate
- (void)setPreferenceValues;	//Set prefrrences
- (void)localize;	//Set language dictionary
- (int)getSelectedLanguage;	//Get current language
- (NSDictionary*)getLocalization;	//Get language dictionary
- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation;	//Change device orientation
//Move UI when typing at host, username, password
- (IBAction)onHostInput:(id)sender;
- (IBAction)onUsernameInput:(id)sender;
- (IBAction)onPasswordInput:(id)sender;
- (void)moveUIControls:(int)intOffset;
- (IBAction)onSettingBtn:(id)sender;	//Show setting
- (IBAction)onHelpBtn:(id)sender;	//Show help
- (IBAction)onCloseBtn:(id)sender;	//Remove support view
//Sign in
- (IBAction)onSignInBtn:(id)sender;
- (void)doSignIn;
- (void)startSignInProgress;
- (void)signInSuccesfully;
- (void)signInFailed;
@end
