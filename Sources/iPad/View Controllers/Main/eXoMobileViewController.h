//
//  eXoMobileViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 5/31/10.
//  Copyright home 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;
@class MainViewController;
@class Connection;

//Control login page
@interface eXoMobileViewController : UIViewController {

	Connection*							_connection;	//Interact with server
	LoginViewController*				_loginViewController;	//Login page
	MainViewController*					_mainViewController;	//Detain view of splitview
	int									_intSelectedLanguage;	//Language index
	NSDictionary*						_dictLocalize;	//Language dictionary
}

@property (nonatomic, retain) Connection* _connection;

- (void)setSelectedLanguage:(int)languageId;	//Set language
- (void)localize;	//Set language dictionary
- (NSDictionary*)getLocalization;	//Get language dictionary
- (int)getSelectedLanguage;	//Get current language
- (Connection*)getConnection;	//Get connection
- (void)showLoginViewController;	//Show login page
- (void)showMainViewController; //Show main view
@end

