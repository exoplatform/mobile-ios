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
    
    NSMutableSet* _identitiesSet;
    BOOL _allActivitiesLoaded;
    BOOL _isLoadingMultipleActivities;
}

@property (nonatomic, retain) SocialUserProfile* userProfile;
@property (nonatomic) BOOL isLoadingMultipleActivities;

- (void) getUserProfileFromIdentity:(NSString *)identity;

//Method to load a list of Identities
- (void) retrieveIdentitiesSet:(NSMutableSet*)identitiesSet;

@end
