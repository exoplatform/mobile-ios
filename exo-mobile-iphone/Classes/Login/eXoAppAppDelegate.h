//
//  eXoAppAppDelegate.h
//  eXoApp
//
//  Created by Tran Hoai Son on 5/8/09.
//  Copyright EXO-Platform 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eXoAppViewController;
@class eXoApplicationsViewController;
@class eXoGadgetsViewController;
@class eXoEachGadgetViewController;
@class eXoRelationsAndContactViewController;
@class eXoWebViewController;
@class eXoSplash;
@class eXoSetting;
@class eXoMyCalendar;

@interface eXoAppAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
    IBOutlet UIWindow*					window;
	IBOutlet UINavigationController*	navigationController;
	IBOutlet UITabBarController*		tabBarController;
   
	eXoAppViewController*				viewController;
	eXoApplicationsViewController*		applicationsViewController;
	eXoGadgetsViewController*			gadgetsViewController;
	eXoEachGadgetViewController*		eachGadgetViewController;
	eXoRelationsAndContactViewController* relationAndContactViewController;
	eXoSetting*							settingViewController;
	eXoWebViewController*				webViewController;
	eXoSplash*							_splash;
	eXoMyCalendar*						_myCalendar;
	
	
	int									_selectedLanguage;
	NSDictionary*						_dictLocalize;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) UINavigationController* navigationController;
@property (nonatomic, retain) UITabBarController* tabBarController;
@property (nonatomic, retain) eXoAppViewController *viewController;
@property (nonatomic, retain) IBOutlet eXoApplicationsViewController* applicationsViewController;
@property (nonatomic, retain) IBOutlet eXoGadgetsViewController* gadgetsViewController;
@property (nonatomic, retain) IBOutlet eXoEachGadgetViewController* eachGadgetViewController;
@property (nonatomic, retain) IBOutlet eXoSetting*	settingViewController;
@property (nonatomic, retain) eXoWebViewController* webViewController;
@property (nonatomic, retain) eXoMyCalendar* _myCalendar;

-(void)login;
- (void)changeToActivityStreamsViewController:(NSDictionary *)dic;
- (void)changeToGadgetsViewController;
- (void)changeToEachGadgetViewController:(NSString*)urlStr;

@end

