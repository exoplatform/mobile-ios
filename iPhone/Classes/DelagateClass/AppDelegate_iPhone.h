//
//  AppDelegate_iPhone.h
//  eXo Platform
//
//  Created by Mai Gia on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eXoAppViewController;
@class eXoApplicationsViewController;
@class eXoGadgetsViewController;
@class eXoRelationsAndContactViewController;
@class eXoWebViewController;
@class eXoSplash;
@class eXoSetting;

@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
    IBOutlet UIWindow*					window;
	IBOutlet UINavigationController*	navigationController;
	IBOutlet UITabBarController*		tabBarController;
	
	eXoAppViewController*				viewController;
	eXoApplicationsViewController*		applicationsViewController;
	eXoGadgetsViewController*			gadgetsViewController;
	eXoRelationsAndContactViewController* relationAndContactViewController;
	eXoSetting*							settingViewController;
	eXoWebViewController*				webViewController;
	eXoSplash*							_splash;
	
	
	int									_selectedLanguage;
	NSDictionary*						_dictLocalize;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) UINavigationController* navigationController;
@property (nonatomic, retain) UITabBarController* tabBarController;
@property (nonatomic, retain) eXoAppViewController *viewController;
@property (nonatomic, retain) IBOutlet eXoApplicationsViewController* applicationsViewController;
@property (nonatomic, retain) IBOutlet eXoGadgetsViewController* gadgetsViewController;
@property (nonatomic, retain) IBOutlet eXoSetting*	settingViewController;
@property (nonatomic, retain) eXoWebViewController* webViewController;

-(void)login;
- (void)changeToActivityStreamsViewController:(NSDictionary *)dic;
- (void)changeToGadgetsViewController;
- (void)changeToEachGadgetViewController:(NSString*)urlStr;

@end

