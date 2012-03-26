//
//  eXoMobileAppDelegate.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 5/31/10.
//  Copyright home 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eXoMobileViewController;

@interface eXoMobileAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    eXoMobileViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet eXoMobileViewController *viewController;

@end

