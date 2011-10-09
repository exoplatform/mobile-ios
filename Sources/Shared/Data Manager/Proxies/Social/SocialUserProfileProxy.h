//
//  SocialUserProfileProxy.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 13/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "SocialProxy.h"
#import "SocialUserProfile.h"

@interface SocialUserProfileProxy : SocialProxy <RKObjectLoaderDelegate> {
    
    SocialUserProfile* _userProfile;
}

@property (nonatomic, retain) SocialUserProfile* userProfile;

- (void) getUserProfileFromUsername:(NSString *)username;


@end
