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
@property (nonatomic, retain) WelcomeViewController_iPad *welcomeVC;
@property BOOL isCompatibleWithSocial;


-(void)showHome;
-(void)backToAuthenticate;


+(AppDelegate_iPad*)instance;

@end


