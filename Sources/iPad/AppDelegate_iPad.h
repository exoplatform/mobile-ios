//
//  AppDelegate_iPad.h
//  eXo Platform
//
//  Created by Mai Gia on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eXoMobileAppDelegate.h"



@class eXoMobileViewController;
@class RootViewController;

@interface AppDelegate_iPad : eXoMobileAppDelegate {
    UIWindow *window;
    eXoMobileViewController *viewController;
    
    
    RootViewController *rootViewController;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet eXoMobileViewController *viewController;
@property (nonatomic, retain) RootViewController *rootViewController;

-(void)showHome;

+(AppDelegate_iPad*)instance;

@end


