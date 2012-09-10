//
//  UserPreferencesManager.h
//  eXo Platform
//
//  Created by exoplatform on 9/10/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
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
