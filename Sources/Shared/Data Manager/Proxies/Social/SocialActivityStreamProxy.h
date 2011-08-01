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
#import "SocialIdentity.h"
#import "SocialUserProfile.h"

@class SocialIdentityProxy;
@class SocialUserProfileProxy;

@interface SocialActivityStreamProxy : SocialProxy <RKObjectLoaderDelegate>{
    
    SocialUserProfile*          _socialUserProfile;
    
    NSArray*                    _arrActivityStreams;
}

@property (nonatomic, retain) SocialUserProfile* socialUserProfile;
@property (nonatomic, retain) NSArray* arrActivityStreams;

- (id)initWithSocialUserProfile:(SocialUserProfile*)aSocialUserProfile;
- (void)getActivityStreams;

@end


