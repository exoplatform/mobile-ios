//
//  SocialIdentityProxy.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 06/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "SocialIdentity.h"
#import "SocialProxy.h"


@interface SocialIdentityProxy : SocialProxy <RKObjectLoaderDelegate> {
 
    SocialIdentity* _socialIdentity;
    
}

@property (nonatomic, retain) SocialIdentity* _socialIdentity;

- (void)getIdentityFromUser;

@end
