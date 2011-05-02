//
//  AppDelegate_iPhone.h
//  eXo Platform
//
//  Created by Mai Gia on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eXoMobileAppDelegate.h"

@class eXoAppViewController;
@class eXoApplicationsViewController;
@class eXoGadgetsViewController;
@class eXoWebViewController;
@class eXoSplashViewController;
@class eXoSettingViewController;

@class HomeViewController_iPhone;

//App delegate
@interface AppDelegate_iPhone : eXoMobileAppDelegate <UIAlertViewDelegate> {
    IBOutlet UIWindow*					window;
	IBOutlet UINavigationController*	navigationController;
	IBOutlet UITabBarController*		tabBarController;
	
	eXoAppViewController*				viewController;	//Login page
	eXoApplicationsViewController*		applicationsViewController;	//Main app page
	eXoGadgetsViewController*			gadgetsViewController;	//Gadgeta page
	eXoSettingViewController*			settingViewController;	//Setting page
	eXoWebViewController*				webViewController;	//Display help or file content
	eXoSplashViewController*			_splash;	//Splash view
	
    HomeViewController_iPhone*          _homeViewController;
    
	
	int									_selectedLanguage;	//Language index
	NSDictionary*						_dictLocalize;	//Language dictionary
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) UINavigationController* navigationController;
@property (nonatomic, retain) UITabBarController* tabBarController;
@property (nonatomic, retain) eXoAppViewController *viewController;
@property (nonatomic, retain) IBOutlet eXoApplicationsViewController* applicationsViewController;
@property (nonatomic, retain) IBOutlet eXoGadgetsViewController* gadgetsViewController;
@property (nonatomic, retain) IBOutlet eXoSettingViewController*	settingViewController;
@property (nonatomic, retain) eXoWebViewController* webViewController;

-(void)login;	//Login action
- (void)changeToActivityStreamsViewController:(NSDictionary *)dic;	//Show main view of application
- (void)changeToGadgetsViewController;	//Display gadget view controller
- (void)showHomeViewController;

@end

