//
//  eXoAppViewController.h
//  eXoApp
//
//  Created by Tran Hoai Son on 5/8/09.
//  Copyright home 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

//Login page
@interface eXoAppViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> 
{
	UITextField* _txtfUserName;	//Username
	UITextField* _txtfUserPasswd;	//Password
	UITextField* _txtfDomainName;	//Host
	NSString*	 _bSuccessful;	//Login status
	UIActivityIndicatorView* _indicator;	//Loding indicator
	UIBarButtonItem* btnSignIn;	//Login button
	UIBarButtonItem* btnSetting;	//Setting button
	BOOL endGetData;	//Check if it ends get data
	BOOL bRememberMe;	//Remember
	BOOL bAutoLogin;	//Autologin
	BOOL isFirstTimeLogin;	//Is first time login
	
	int			  _selectedLanguage;	//Current language index
	NSDictionary* _dictLocalize;	//Language dictionary
	
	NSThread *endThread;	//Get data thread
}

@property (nonatomic, retain) UITextField *_txtfUserName;
@property (nonatomic, retain) UITextField *_txtfUserPasswd;

-(IBAction)onSignInBtn:(id)sender;	//Login action
-(IBAction)onSettingBtn;	//Setting action
-(void)login;	//Login progress
//Create UITableViewCell
- (UITableViewCell*)containerCellWithLabel:(UILabel*)label view:(UIView*)view;	
- (UITableViewCell*)textCellWithLabel:(UILabel*)label;	
//Create UITextField
+ (UITextField*)textInputFieldForCellWithSecure:(BOOL)secure;	
+ (UITextField*)textAccountInputFieldForCellWithSecure:(BOOL)secure;	

@end


//--------------------------------------------
@interface ContainerCell : UITableViewCell
{
	UIView*	_vContainer;
}
- (void)attachContainer:(UIView*)view;
@end