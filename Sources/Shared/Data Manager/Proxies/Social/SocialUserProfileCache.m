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
