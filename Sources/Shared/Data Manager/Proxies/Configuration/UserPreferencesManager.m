//
//  UserPreferencesManager.m
//  eXo Platform
//
//  Created by exoplatform on 9/10/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import "UserPreferencesManager.h"
#import "ApplicationPreferencesManager.h"
#import "defines.h"

#pragma mark - Constants
/*
 * Key of User Preference to save selected stream tab order. it contains domain name and username to distinguish amongs users.
 */

#define SELECTED_DOMAIN                     [ApplicationPreferencesManager sharedInstance].selectedDomain
#define EXO_SELECTED_STREAM                 [NSString stringWithFormat:@"%@_%@_selected_stream", SELECTED_DOMAIN, self.username]
#define EXO_REMEMBER_MY_STREAM              [NSString stringWithFormat:@"%@_%@_remember_my_stream", SELECTED_DOMAIN, self.username]
/*
 * Keys for login settings
 */
#define EXO_REMEMBER_ME                     @"remember_me"
#define EXO_AUTO_LOGIN                      @"auto_login"
/* key for showing prive drive */
#define EXO_PREFERENCE_SHOW_PRIVATE_DRIVE   [NSString stringWithFormat:@"%@_%@_show_private_drive", SELECTED_DOMAIN, self.username]

@implementation UserPreferencesManager

#pragma mark - Properties
#pragma mark * Username/Password
@synthesize username = _username;
@synthesize password = _password;

#pragma mark * Remember My Stream
@synthesize selectedSocialStream;
@synthesize rememberSelectedSocialStream;

#pragma mark * Remember Me and Auto Login
@synthesize isUserLogged = _isUserLogged;
@synthesize autoLogin;
@synthesize rememberMe;

#pragma mark * Show Private Drive
@synthesize showPrivateDrive;


#pragma mark - Methods

#pragma mark * Lifecycle
+ (UserPreferencesManager*)sharedInstance
{
	static UserPreferencesManager *sharedInstance;
	@synchronized(self)
	{
		if(!sharedInstance)
		{
			sharedInstance = [[UserPreferencesManager alloc] init];
		}
		return sharedInstance;
	}
	return sharedInstance;
}

- (id) init
{
	self = [super init];
    if (self) 
    {        
        [self reloadUsernamePassword];
        // At the startup time, the user is always unsigned.
        _isUserLogged = NO;
    }	
	return self;
}

- (void) dealloc
{
    [_username release];
    [_password release];
	[super dealloc];
}

#pragma mark * Username & Password management
- (void)persistUsernameAndPasswod {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.username forKey:EXO_PREFERENCE_USERNAME];
    [userDefaults setObject:self.password forKey:EXO_PREFERENCE_PASSWORD];
}

- (void)reloadUsernamePassword {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    self.username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
    self.username = self.username ? self.username : @"";
    self.password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
    self.password = self.password ? self.password : @"";
}

#pragma mark * Remember My Stream
- (BOOL)rememberSelectedSocialStream {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [userDefaults objectForKey:EXO_REMEMBER_MY_STREAM];
    return value ? [value boolValue] : YES;
}

- (void)setRememberSelectedSocialStream:(BOOL)agree {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%d", agree] forKey:EXO_REMEMBER_MY_STREAM];
}

- (void)setSelectedSocialStream:(int)selectedIndex {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%d", selectedIndex] forKey:EXO_SELECTED_STREAM];
}

- (int)selectedSocialStream {
    return self.rememberSelectedSocialStream ? [[[NSUserDefaults standardUserDefaults] objectForKey:EXO_SELECTED_STREAM] intValue] : 0;
}

#pragma mark * Remember Me and Auto Login management
- (BOOL)autoLogin {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [userDefaults objectForKey:EXO_AUTO_LOGIN];
    return value ? [value boolValue] : NO;
}

- (void)setAutoLogin:(BOOL)agree {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", agree] forKey:EXO_AUTO_LOGIN];
}

- (BOOL)rememberMe {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [userDefaults objectForKey:EXO_REMEMBER_ME];
    return value ? [value boolValue] : NO;
}

- (void)setRememberMe:(BOOL)agree {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", agree] forKey:EXO_REMEMBER_ME];
}

#pragma mark * Show Private Drive
- (BOOL)showPrivateDrive {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [userDefaults objectForKey:EXO_PREFERENCE_SHOW_PRIVATE_DRIVE];
    return value ? [value boolValue] : YES;
}

- (void)setShowPrivateDrive:(BOOL)agree {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", agree] forKey:EXO_PREFERENCE_SHOW_PRIVATE_DRIVE];
}

@end
