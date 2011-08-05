//
//  SocialUserProfileProxy.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 13/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialUserProfileProxy.h"
#import "SocialRestConfiguration.h"
#import "SocialUserProfileCache.h"


@implementation SocialUserProfileProxy

@synthesize userProfile=_userProfile;
@synthesize isLoadingMultipleActivities = _isLoadingMultipleActivities;


#pragma mark - Object Management

- (id)init {
    if ((self = [super init])) {
        _isLoadingMultipleActivities = NO;
    } 
    return self;
}

- (void)dealloc {
    [_userProfile release]; _userProfile = nil;
    [super dealloc];
}

#pragma mark - helper methods

//Helper to create the base URL
- (NSString *)createBaseURL {
    SocialRestConfiguration* socialConfig = [SocialRestConfiguration sharedInstance];
    
    return [NSString stringWithFormat:@"%@/%@/private/api/social/%@/%@/identity/", socialConfig.domainNameWithCredentials, socialConfig.restContextName,socialConfig.restVersion, socialConfig.portalContainerName]; 
}


//Helper to create the path to get the ressources
- (NSString *)createPath:(NSString *)userIdentity {
    return [NSString stringWithFormat:@"%@.json",userIdentity]; 
}

#pragma mark - Call methods

- (void) getUserProfileFromIdentity:(NSString *)identity {
    
    //Start by checking if the profile doesn't exist in the cache
    SocialUserProfile *userProfileCached = [[SocialUserProfileCache sharedInstance]cachedProfileForIdentity:identity];
    
    if (userProfileCached == nil) {
    
        // Load the object model via RestKit
        RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL]];
        [RKObjectManager setSharedManager:manager];
    
        RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[SocialUserProfile class]];
        [mapping mapKeyPathsToAttributes:
         @"id",@"identity",
         @"remoteId",@"remoteId",
         @"providerId",@"providerId",
         @"profile.avatarUrl",@"avatarUrl",
         @"profile.fullName",@"fullName",
         nil];
    
        [manager loadObjectsAtResourcePath:[self createPath:identity] objectMapping:mapping delegate:self];   
    } else {
        [self objectLoader:nil didLoadObjects:[NSArray arrayWithObjects:userProfileCached,nil]];
    }
}


- (void) popSetOfIdentities {
    if ([_identitiesSet count]!=0) {
        NSString *identityId = [_identitiesSet anyObject];
        [_identitiesSet removeObject:identityId];
        [self getUserProfileFromIdentity:identityId];
    } else {
        if (delegate && [delegate respondsToSelector:@selector(proxyDidFinishLoading:)]) {
            [delegate proxyDidFinishLoading:self];
        }
    }
}

//Method to load a list of Identities
//Return nil if OK
//Return the list of unretrieved Profiles if KO
- (void)retrieveIdentitiesSet:(NSMutableSet*)identitiesSet {
    
    _isLoadingMultipleActivities = YES;
    _identitiesSet = identitiesSet;
    
    //Retrieve the first Identity
    [self popSetOfIdentities];

}


#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    
    _userProfile = [[objects objectAtIndex:0] retain];

    [[SocialUserProfileCache sharedInstance]addInCache:_userProfile forIdentity:_userProfile.identity];
    
    if (_isLoadingMultipleActivities) {
        [self popSetOfIdentities];
    } else {
        //	NSLog(@"Loaded statuses: %@", objects); 
    
        //We receive the response from the server
        //We need to prevent the caller.
        if (delegate && [delegate respondsToSelector:@selector(proxyDidFinishLoading:)]) {
            [delegate proxyDidFinishLoading:self];
        }
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
	NSLog(@"Hit error: %@", error);
}



@end
