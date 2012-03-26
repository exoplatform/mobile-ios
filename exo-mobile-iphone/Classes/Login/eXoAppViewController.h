//
//  eXoAppViewController.h
//  eXoApp
//
//  Created by Tran Hoai Son on 5/8/09.
//  Copyright home 2009. All rights reserved.
//

#import <UIKit/UIKit.h>


//@interface eXoAppViewController : UIViewController <UITextFieldDelegate, UIWebViewDelegate> {
//	IBOutlet UITextField* _txtfUserName;
//	IBOutlet UITextField* _txtfUserPasswd;
//}
//
//@property (nonatomic, retain) UITextField *_txtfUserName;
//@property (nonatomic, retain) UITextField *_txtfUserPasswd;
//
//-(IBAction)onSignInBtn:(id)sender;
//-(IBAction)onGadgetsBtn:(id)sender;
//@end

@interface eXoAppViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> 
{
	UITextField* _txtfUserName;
	UITextField* _txtfUserPasswd;
	UITextField* _txtfDomainName;
	UITextField* _txtfDomainName1;	
	NSString*	 _bSuccessful;
	UIActivityIndicatorView* _indicator;
	UIBarButtonItem* btnSignIn;
	UIBarButtonItem* btnSetting;
	BOOL endGetData;
	BOOL bRememberMe;
	BOOL bAutoLogin;
	
	int			  _selectedLanguage;
	NSDictionary* _dictLocalize;
	
	//NSThread *startThread;
	NSThread *endThread;
}

@property (nonatomic, retain) UITextField *_txtfUserName;
@property (nonatomic, retain) UITextField *_txtfUserPasswd;

-(IBAction)onSignInBtn:(id)sender;
-(IBAction)onSettingBtn;
-(void)login;
- (UITableViewCell*)containerCellWithLabel:(UILabel*)label view:(UIView*)view;
- (UITableViewCell*)textCellWithLabel:(UILabel*)label;
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