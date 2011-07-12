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

@interface SocialActivityStreamProxy : SocialProxy <RKObjectLoaderDelegate>{
    
    SocialIdentityProxy*        _socialIdentityProxy;
}

@property (nonatomic, retain) SocialIdentityProxy* _socialIdentityProxy;

- (id)initWithSocialIdentityProxy:(SocialIdentityProxy*)socialIdentityProxy;
- (void)getActivityStreams;

@end