//
//  eXoViewController.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATMHud.h"

#define TAG_EMPTY 110


@interface eXoViewController : UIViewController {
    IBOutlet UINavigationBar*           _navigation;
    UILabel *label;
}

// ATMHud to manage loading diplay
@property (nonatomic, readonly) ATMHud *hudLoadWaiting;

// The method for updating position for hud loading. Be default, the method does nothing.
- (void)updateHudPosition;
// getting ATMHud with position has been updated.
- (ATMHud *)hudLoadWaitingWithPositionUpdated;
// display Hud Load view
- (void)displayHudLoader;
// display Hud Load view with message
- (void)displayHUDLoaderWithMessage:(NSString *)message;
// Hide Hud Load view 
- (void)hideLoader:(BOOL)successful;
// Hide Hud Load view immediately
- (void)hideLoaderImmediately:(BOOL)successful;

@end
