//
//  SocialIdentityProxy.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 06/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialIdentityProxy.h"
#import "SocialRestConfiguration.h"

@implementation SocialIdentityProxy

@synthesize _socialIdentity;


#pragma mark - Object Management

- (id)init {
    if ((self = [super init])) {
        
    } 
    return self;
}

- (void)dealloc {
    [_socialIdentity release]; _socialIdentity = nil;
    [super dealloc];
}


#pragma mark - helper methods

//Helper to create the base URL
- (NSString *)createBaseURL {
    SocialRestConfiguration* socialConfig = [SocialRestConfiguration sharedInstance];
    return [NSString stringWithFormat:@"%@/%@/%@/social/identity/",socialConfig.domainName,socialConfig.restContextName,socialConfig.portalContainerName]; 
    //return [NSString stringWithFormat:@"http://localhost:8080/rest-socialdemo/socialdemo/social/identity/"]; 
}


//Helper to create the path to get the ressources
- (NSString *)createPath {
    SocialRestConfiguration* socialConfig = [SocialRestConfiguration sharedInstance];
    return [NSString stringWithFormat:@"%@/id/show.json",socialConfig.username]; 
}




#pragma mark - Call methods

- (void) getIdentityFromUser {
    // Load the object model via RestKit
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL]];  
    [RKObjectManager setSharedManager:manager];
    [manager loadObjectsAtResourcePath:[self createPath] objectClass:[SocialIdentity class] delegate:self];      
}



#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	NSLog(@"Loaded statuses: %@", objects);    
	//[_socialIdentity release];
	//_socialIdentity = [objects retain];
    _socialIdentity = [[objects objectAtIndex:0] retain];
    
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
