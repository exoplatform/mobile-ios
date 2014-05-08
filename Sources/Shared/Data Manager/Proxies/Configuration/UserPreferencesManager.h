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

#import <Foundation/Foundation.h>

@interface UserPreferencesManager : NSObject

#pragma mark - Properties

#pragma mark * Username/Password
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

#pragma mark * Remember My Stream
/*
 * @Getter: Return 0 if user doesn't choose to remember selected stream, else return value read at the user preference property "selected_stream"
 * @Setter: if user doesn't choose to remember selected stream, keep this value temporary to reserve for method "setrememberSelectedSocialStream:". Else the value is saved to "selected_stream". 
 */
@property (nonatomic, assign) int selectedSocialStream;

/*
 * @Getter: Returns true if the user preference property "selected_stream" doesn't exist or its value is greater than 0, else return false.
 * @Setter: If it's set true, value kepted by "setSelectedSocialStream:" is used to saved into "selected_stream", else a negative number is saved.
 */
@property (nonatomic, assign) BOOL rememberSelectedSocialStream;

#pragma mark * Remember Me and Auto Login
/* 
 login info
 */
@property (nonatomic, assign) BOOL isUserLogged;
@property (nonatomic, assign) BOOL rememberMe;
@property (nonatomic, assign) BOOL autoLogin;

#pragma mark * Show Private Drive
@property (nonatomic, assign) BOOL showPrivateDrive;

#pragma mark - Methods

+ (UserPreferencesManager*)sharedInstance;

#pragma mark * Username/Password
// Save username and password to the user preference.
- (void)persistUsernameAndPasswod;
// Reload username and password from user preference
- (void)reloadUsernamePassword;

@end
