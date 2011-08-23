//
//  PlatformVersionProxy.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 26/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "PlatformServerVersion.h"
#import "SocialRestConfiguration.h"

@protocol PlatformVersionProxyDelegate;


@interface PlatformVersionProxy : NSObject<RKObjectLoaderDelegate> {
    
    BOOL _isPlatformCompatibleWithSocialFeatures;
    
    id<PlatformVersionProxyDelegate> _delegate;

    
}

@property (nonatomic) BOOL isPlatformCompatibleWithSocialFeatures;
@property (nonatomic, retain) id<PlatformVersionProxyDelegate> delegate;

-(id)initWithDelegate:(id<PlatformVersionProxyDelegate>)delegate;
- (void)retrievePlatformInformations;

@end


@protocol PlatformVersionProxyDelegate<NSObject>
- (void)platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial;	
@end