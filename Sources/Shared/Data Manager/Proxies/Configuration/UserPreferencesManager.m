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

#import "UserPreferencesManager.h"
#import "ApplicationPreferencesManager.h"
#import "defines.h"


/*
 * Key of User Preference to save selected stream tab order. it contains domain name and username to distinguish amongs users.
 */

#define EXO_SELECTED_STREAM                 [NSString stringWithFormat:@"%@_%@_selected_stream", SELECTED_DOMAIN, self.username]
#define EXO_REMEMBER_MY_STREAM              [NSString stringWithFormat:@"%@_%@_remember_my_stream", SELECTED_DOMAIN, self.username]
/*
 * Keys for login settings
 */
#define EXO_REMEMBER_ME                     [NSString stringWithFormat:@"%@_%@_remember_me",SELECTED_DOMAIN,self.username]
#define EXO_AUTO_LOGIN                      [NSString stringWithFormat:@"%@_%@_auto_login",SELECTED_DOMAIN,self.username]

/* key for showing prive drive */
#define EXO_PREFERENCE_SHOW_PRIVATE_DRIVE   [NSString stringWithFormat:@"%@_%@_show_private_drive", SELECTED_DOMAIN, self.username]

#pragma mark - Constants

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

- (instancetype) init
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
    [userDefaults setObject:self.username forKey:EXO_LAST_LOGGED_USER];
}

- (void)reloadUsernamePassword {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* tmpUsername = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
    self.username = tmpUsername != nil ? tmpUsername : @"";
    NSString* tmpPassword = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
    self.password = tmpPassword != nil ? tmpPassword : @"";
    [tmpUsername release];
    [tmpPassword release];
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
