//
//  SocialUserProfileCache.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 05/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialUserProfile.h"


@interface SocialUserProfileCache : NSObject {
    
    NSMutableDictionary *_localCacheInMemory;
    
}

+ (SocialUserProfileCache*)sharedInstance;
- (SocialUserProfile *)cachedProfileForIdentity:(NSString *)identityId;
- (void)addInCache:(SocialUserProfile*)profile forIdentity:(NSString *)identityId;
@end
