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


#pragma mark - Object Management

- (id)init {
    if ((self = [super init])) {
    } 
    return self;
}

- (void)dealloc {
    [_userProfile release];
    [super dealloc];
}

#pragma mark - helper methods

//Helper to create the path to get the ressources
- (NSString *)createPath:(NSString *)userIdentity {
    return [NSString stringWithFormat:@"%@/identity/%@.json", [super createPath], userIdentity]; 
}


//Helper to create the path to get the ressources
- (NSString *)createPathForUsername:(NSString *)username {
    
    return [NSString stringWithFormat:@"%@/identity/organization/%@.json", [super createPath], username]; 
}


#pragma mark - Call methods


- (void) getUserProfileFromUsername:(NSString *)username {
    
    // Load the object model via RestKit
    RKObjectManager* manager = [RKObjectManager sharedManager];    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[SocialUserProfile class]];
    [mapping mapKeyPathsToAttributes:
     @"id",@"identity",
     @"remoteId",@"remoteId",
     @"providerId",@"providerId",
     @"profile.avatarUrl",@"avatarUrl",
     @"profile.fullName",@"fullName",
    nil];
    
    [manager loadObjectsAtResourcePath:[self createPathForUsername:username] objectMapping:mapping delegate:self];   
}


#pragma mark - RKObjectLoaderDelegate methods
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    //We receive the response from the server
    //We need to prevent the caller.
    _userProfile = [[objects objectAtIndex:0] retain];
    [[SocialUserProfileCache sharedInstance] addInCache:_userProfile forIdentity:_userProfile.identity];
    [super objectLoader:objectLoader didLoadObjects:objects];
}

@end
