//
//  SocialUserProfileProxy.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 13/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialUserProfileProxy.h"
#import "SocialRestConfiguration.h"


@implementation SocialUserProfileProxy

@synthesize userProfile=_userProfile;


#pragma mark - Object Management

- (id)init {
    if ((self = [super init])) {
        
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
    
    return [NSString stringWithFormat:@"%@/%@/private/api/social/%@/%@/identity/",
            socialConfig.domainNameWithCredentials,
            socialConfig.restContextName,
            socialConfig.restVersion,
            socialConfig.portalContainerName]; 

}


//Helper to create the path to get the ressources
- (NSString *)createPath:(NSString *)userIdentity {
    return [NSString stringWithFormat:@"%@.json",userIdentity]; 
}

#pragma mark - Call methods

- (void) getUserProfileFromIdentity:(NSString *)identity {
    // Load the object model via RestKit
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL]];
    [RKObjectManager setSharedManager:manager];
    [manager loadObjectsAtResourcePath:[self createPath:identity] objectClass:[SocialUserProfile class] delegate:self];      
}



#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	NSLog(@"Loaded statuses: %@", objects); 
    _userProfile = [[objects objectAtIndex:0] retain];
    
    //We receive the response from the server
    //We need to prevent the caller.
    if (delegate && [delegate respondsToSelector:@selector(proxyDidFinishLoading:)]) {
        [delegate proxyDidFinishLoading:self];
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
	NSLog(@"Hit error: %@", error);
}



@end
