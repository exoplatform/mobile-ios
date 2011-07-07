//
//  SocialIdentityProxy.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 06/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialIdentityProxy.h"

@implementation SocialIdentityProxy


- (void) initRK {
    RKClient* client = [RKClient clientWithBaseURL:@"http://localhost:8080/rest/portal/social"];  

}

- (void) loadIdentity {
    // Load the object model via RestKit
	[[RKClient sharedClient] get:@"/identity/john/id/show.json" delegate:self];
    
    //RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:@"http://localhost:8080/rest/portal/social/identity/john/id/show.json"];  
    //[manager loadObjectsAtResourcePath:@"identity/john/id/show.json" objectClass:[RKSocialIdentity class] delegate:self];  

    
}



#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	NSLog(@"Loaded statuses: %@", objects);    
	//[_socialIdentity release];
	//_socialIdentity = [objects retain];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
	NSLog(@"Hit error: %@", error);
}


@end
