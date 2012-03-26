//
//  SocialUserProfileCache.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 05/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialUserProfileCache.h"
#import "SocialUserProfile.h"


@implementation SocialUserProfileCache


#pragma Object Management

+ (SocialUserProfileCache*)sharedInstance
{
	static SocialUserProfileCache *sharedInstance;
	@synchronized(self)
	{
		if(!sharedInstance)
		{
			sharedInstance = [[SocialUserProfileCache alloc] init];
		}
		return sharedInstance;
	}
	return sharedInstance;
}


- (id) init
{
    if ((self = [super init])) 
    {
        _localCacheInMemory = [[NSMutableDictionary alloc] init];
    }	
	return self;
}

- (void)dealloc {
    [_localCacheInMemory release];
    [super dealloc];
}


-(SocialUserProfile *)cachedProfileForIdentity:(NSString *)identityId
{
    return [_localCacheInMemory objectForKey:identityId];
}


- (void)addInCache:(SocialUserProfile*)profile forIdentity:(NSString *)identityId {
    [_localCacheInMemory setObject:profile forKey:identityId];
}

@end
