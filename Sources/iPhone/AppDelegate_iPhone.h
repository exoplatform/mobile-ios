//
//  AppDelegate_iPhone.h
//  eXo Platform
//
//  Created by Mai Gia on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eXoMobileAppDelegate.h"


@class AuthenticateViewController;
@class HomeViewController_iPhone;

//App delegate
@interface AppDelegate_iPhone : eXoMobileAppDelegate <UIAlertViewDelegate> {
    IBOutlet UIWindow*					window;
	IBOutlet UINavigationController*	navigationController;
	
	AuthenticateViewController*         authenticateViewController;	//Login page
	
    HomeViewController_iPhone*          _homeViewController_iPhone;
    BOOL                                _isCompatibleWithSocial;
    UINavigationController*             _navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) UINavigationController* navigationController;
@property (nonatomic, retain) IBOutlet AuthenticateViewController *authenticateViewController;
@property (nonatomic, retain) IBOutlet HomeViewController_iPhone* homeViewController_iPhone;
@property BOOL isCompatibleWithSocial;

+(AppDelegate_iPhone*)instance;


- (void)showHomeViewController;
- (void)onBtnSigtOutDelegate;
@end

