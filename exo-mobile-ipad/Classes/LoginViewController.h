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

@interface LoginViewController : UIViewController <UITextFieldDelegate> {
	
	id										_delegate;
	//UI variables
	IBOutlet UIButton*						_btnLogo;
	IBOutlet UIButton*						_btnHelp;
	IBOutlet UIButton*						_btnSetting;
	IBOutlet UILabel*						_lbHostInstruction;
	IBOutlet UILabel*						_lbAccountInstruction;
	IBOutlet UILabel*						_lbHost;
	IBOutlet UILabel*						_lbRememberMe;
	IBOutlet UILabel*						_lbAutoSignIn;
	IBOutlet UILabel*						_lbSigningInStatus;
	IBOutlet UIActivityIndicatorView*		_actiSigningIn;
	IBOutlet UIButton*						_btnHost;
	IBOutlet UITextField*					_txtfHost;
	IBOutlet UIButton*						_btnUsername;
	IBOutlet UITextField*					_txtfUsername;
	IBOutlet UIButton*						_btnPassword;
	IBOutlet UITextField*					_txtfPassword;
	Checkbox*								_cbxRememberMe;
	Checkbox*								_cbxAutoSignIn;
	IBOutlet UIButton*						_btnSignIn;
	UILabel*								_lbHelpTitle;
	NSURLRequest*							_urlHelp;
	UIWebView*								_wvHelp;
	UIButton*								_btnHelpClose;
	
	SettingViewController*					_settingViewController;
	SupportViewController*					_supportViewController;
	BOOL									_bDismissSettingView;
	UIPopoverController*					popoverController;
	UIInterfaceOrientation					_interfaceOrientation;
	//
	NSString*								_strHost;
	NSString*								_strUsername;
	NSString*								_strPassword;
	
	BOOL									_bRememberMe;
	BOOL									_bAutoSignIn;
	BOOL									_bMoveUp;
	
	NSDictionary*							_dictLocalize;
	int										_intSelectedLanguage;
}


- (void)setDelegate:(id)delegate;
- (void)setPreferenceValues;
- (void)localize;
- (int)getSelectedLanguage;
- (NSDictionary*)getLocalization;
- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (IBAction)onHostInput:(id)sender;
- (IBAction)onUsernameInput:(id)sender;
- (IBAction)onPasswordInput:(id)sender;
- (void)moveUIControls:(int)intOffset;
- (IBAction)onSettingBtn:(id)sender;
- (IBAction)onHelpBtn:(id)sender;
- (IBAction)onCloseBtn:(id)sender;
- (IBAction)onSignInBtn:(id)sender;
- (void)doSignIn;
- (void)startSignInProgress;
- (void)signInSuccesfully;
- (void)signInFailed;
@end
