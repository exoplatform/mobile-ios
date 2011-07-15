//
//  SocialActivityStreamProxy.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 07/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "SocialProxy.h"

@class SocialIdentityProxy;
@class SocialUserProfileProxy;

@interface SocialActivityStreamProxy : SocialProxy <RKObjectLoaderDelegate>{
    
    SocialIdentityProxy*        _socialIdentityProxy;
    SocialUserProfileProxy*     _socialUserProfileProxy;
}

@property (nonatomic, retain) SocialIdentityProxy* _socialIdentityProxy;
@property (nonatomic, retain) SocialUserProfileProxy* _socialUserProfileProxy;

- (id)initWithSocialIdentityProxy:(SocialIdentityProxy*)socialIdentityProxy;
- (id)initWithSocialUserProfileProxy:(SocialUserProfileProxy*)socialUserProfileProxy;
- (void)getActivityStreams;

@end


