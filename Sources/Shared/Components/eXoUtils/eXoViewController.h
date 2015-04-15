//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import <UIKit/UIKit.h>
#import "ATMHud.h"

#define TAG_EMPTY 110


@interface eXoViewController : UIViewController {
    IBOutlet UINavigationBar*           _navigation;
    UIButton * topViewButton;
    UILabel *label;
}

-(void) scrollTableViewToTop:(id) sender;

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
// Update labels when the language changes
- (void)updateLabelsWithNewLanguage;
// Checks if the screen is 4 inches (iPhone 5)
+ (BOOL) isHighScreen;
@end
