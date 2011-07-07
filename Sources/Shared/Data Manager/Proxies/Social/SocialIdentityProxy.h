//
//  SocialIdentityProxy.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 06/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "RKSocialIdentity.h"


@interface SocialIdentityProxy : NSObject<RKObjectLoaderDelegate> {
 
    //RKSocialIdentity* _socialIdentity;
    
}

- (void)initRK;
- (void)loadIdentity;



@end
