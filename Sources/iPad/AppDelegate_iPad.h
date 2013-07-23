//
//  AppDelegate_iPad.h
//  eXo Platform
//
//  Created by Mai Gia on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eXoMobileAppDelegate.h"

#import "AuthenticateViewController_iPad.h"
#import "WelcomeViewController_iPad.h"


@class RootViewController;

@interface AppDelegate_iPad : eXoMobileAppDelegate {
    UIWindow *window;
    //eXoMobileViewController *viewController;
    
    AuthenticateViewController_iPad *viewController;
    
    RootViewController *rootViewController;
    
    WelcomeViewController_iPad *welcomeVC;
    
    BOOL _isCompatibleWithSocial;

    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AuthenticateViewController_iPad *viewController;
@property (nonatomic, retain) RootViewController *rootViewController;
@property BOOL isCompatibleWithSocial;


-(void)showHome;
-(void)backToAuthenticate;


+(AppDelegate_iPad*)instance;

@end


