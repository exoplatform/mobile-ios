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
#import "eXoMobileAppDelegate.h"
#import "AuthenticateViewController_iPhone.h"
#import "HomeSidebarViewController_iPhone.h"
#import "WelcomeViewController_iPhone.h"
//App delegate
@interface AppDelegate_iPhone : eXoMobileAppDelegate <UIAlertViewDelegate> {
    IBOutlet UIWindow*					window;
	IBOutlet UINavigationController*	navigationController;
	
	AuthenticateViewController_iPhone*  _authenticateViewController;	//Login page
    
    HomeSidebarViewController_iPhone*   _homeSidebarViewController_iPhone;
    
    BOOL                                _isCompatibleWithSocial;
    UINavigationController*             _navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) UINavigationController* navigationController;
@property (nonatomic, retain) IBOutlet AuthenticateViewController_iPhone *authenticateViewController;
@property (nonatomic, retain) IBOutlet HomeSidebarViewController_iPhone* homeSidebarViewController_iPhone;
@property BOOL isCompatibleWithSocial;

+(AppDelegate_iPhone*)instance;


- (void)showHomeViewController;
- (void)showHomeSidebarViewController;
- (void)onBtnSigtOutDelegate;
@end

