//
//  SocialActivityStreamProxy.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 07/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class SocialIdentityProxy;

@interface SocialActivityStreamProxy : NSObject <RKObjectLoaderDelegate>{
    
    SocialIdentityProxy*        _socialIdentityProxy;
}

@property (nonatomic, retain) SocialIdentityProxy* _socialIdentityProxy;

- (id)initWithSocialIdentityProxy:(SocialIdentityProxy*)socialIdentityProxy;
- (void)getActivityStreams;

@end
