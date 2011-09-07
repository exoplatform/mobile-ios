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

@class MenuViewController;

//Control login page
@interface eXoMobileViewController : UIViewController {

	LoginViewController*				_loginViewController;	//Login page
	int									_intSelectedLanguage;	//Language index
	NSDictionary*						_dictLocalize;	//Language dictionary
    
    MenuViewController*                 _menuViewController;
    UINavigationController*             _navigationController;
    int                                 _interfaceOrientation;
}

- (void)setSelectedLanguage:(int)languageId;	//Set language
- (void)localize;	//Set language dictionary
- (NSDictionary*)getLocalization;	//Get language dictionary
- (int)getSelectedLanguage;	//Get current language
- (void)showLoginViewController;	//Show login page
- (void)showMainViewController; //Show main view
- (void)showHomeViewController:(BOOL)isCompatibleWithSocial;
- (void)onBtnSigtOutDelegate;
@end

