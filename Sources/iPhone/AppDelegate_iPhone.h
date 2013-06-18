//
//  AppDelegate_iPhone.h
//  eXo Platform
//
//  Created by Mai Gia on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eXoMobileAppDelegate.h"
#import "AuthenticateViewController_iPhone.h"
#import "HomeViewController_iPhone.h"
#import "HomeSidebarViewController_iPhone.h"
#import "WelcomeViewController_iPhone.h"
//App delegate
@interface AppDelegate_iPhone : eXoMobileAppDelegate <UIAlertViewDelegate> {
    IBOutlet UIWindow*					window;
	IBOutlet UINavigationController*	navigationController;
	
	AuthenticateViewController_iPhone*  _authenticateViewController;	//Login page
	
    HomeViewController_iPhone*          _homeViewController_iPhone;
    
    HomeSidebarViewController_iPhone*   _homeSidebarViewController_iPhone;
    
    BOOL                                _isCompatibleWithSocial;
    UINavigationController*             _navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) UINavigationController* navigationController;
@property (nonatomic, retain) IBOutlet AuthenticateViewController_iPhone *authenticateViewController;
@property (nonatomic, retain) IBOutlet HomeViewController_iPhone* homeViewController_iPhone;
@property (nonatomic, retain) IBOutlet HomeSidebarViewController_iPhone* homeSidebarViewController_iPhone;
@property BOOL isCompatibleWithSocial;

@property (nonatomic, retain) WelcomeViewController_iPhone *welcomeViewController;
+(AppDelegate_iPhone*)instance;


- (void)showHomeViewController;
- (void)showHomeSidebarViewController;
- (void)onBtnSigtOutDelegate;
@end

