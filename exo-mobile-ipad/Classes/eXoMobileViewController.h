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

@interface eXoMobileViewController : UIViewController {

	Connection*							_connection;
	LoginViewController*				_loginViewController;
	MainViewController*					_mainViewController;
	int									_intSelectedLanguage;
	NSDictionary*						_dictLocalize;
}

@property (nonatomic, retain) Connection* _connection;

- (void)setSelectedLanguage:(int)languageId;
- (void)localize;
- (NSDictionary*)getLocalization;
- (int)getSelectedLanguage;
- (Connection*)getConnection;
- (void)showLoginViewController;
- (void)showMainViewController;
@end

