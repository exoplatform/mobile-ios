//
//  eXoAccount.m
//  eXoApp
//
//  Created by Tran Hoai Son on 5/9/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import "eXoAccount.h"
#import "eXoUserClient.h"
#import "defines.h"
#import "eXoAppViewController.h"

static eXoAccount *_instance;

@implementation eXoAccount

+ (id)instance
{
    if (!_instance) 
	{
        return [eXoAccount newInstance];
    }
    return _instance;
}

+ (id)newInstance
{
    if(_instance)
	{
        [_instance release];
        _instance = nil;
    }
    
    _instance = [[eXoAccount alloc] init];
    return _instance;
}

- (void) dealloc
{
    [super dealloc];
}

- (void)setUsername:(NSString*)username
{
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:EXO_PREFERENCE_USERID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPassword:(NSString*)password
{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:EXO_PREFERENCE_PASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setUserId:(NSString*)user_id
{
    [[NSUserDefaults standardUserDefaults] setObject:user_id forKey:EXO_PREFERENCE_EXO_USERID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)userName
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:EXO_PREFERENCE_USERID];
}

- (NSString*)password
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:EXO_PREFERENCE_PASSWORD];
}

- (NSString*)userId
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:EXO_PREFERENCE_EXO_USERID];
}

- (BOOL)valid
{
	NSString *pwd = self.password;
	NSString *usn = self.userName;
	return usn != nil && usn.length > 0 &&
	pwd != nil && pwd.length > 0;
}

- (void)getUserId
{
	eXoUserClient* exoUserClient = [[eXoUserClient alloc] initWithDelegate:self];
	[exoUserClient getUserInfoForScreenName:[self userName]];
}

- (void)getUserId:(NSString*)userName
{
	eXoUserClient* exoUserClient = [[eXoUserClient alloc] initWithDelegate:self];
	[exoUserClient getUserInfoForScreenName:userName];
}

- (void)eXoUserClientSucceeded:(eXoUserClient*)sender
{
	[self setUserId:sender._user._userId];
}

- (void)eXoUserClientFailed:(eXoUserClient*)sender
{
}
@end
