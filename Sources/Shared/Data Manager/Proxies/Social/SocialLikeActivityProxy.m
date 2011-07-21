//
//  SocialLikeActivityProxy.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 20/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialLikeActivityProxy.h"
#import "SocialRestConfiguration.h"
#import "SocialLike.h"


@implementation SocialLikeActivityProxy


#pragma mark - helper methods

//Helper to create the base URL
- (NSString *)createBaseURL {
    SocialRestConfiguration* socialConfig = [SocialRestConfiguration sharedInstance];
    
    return [NSString stringWithFormat:@"%@/%@/private/api/social/%@/%@/activity/", socialConfig.domainNameWithCredentials, socialConfig.restContextName,socialConfig.restVersion, socialConfig.portalContainerName]; 
}

- (void) configureObjectManagerForActivity:(NSString *)activityIdentity {
    
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL]];
    [RKObjectManager setSharedManager:manager];
    manager.serializationMIMEType = RKMIMETypeJSON;
    
    
    RKObjectRouter* router = [[RKObjectRouter new] autorelease];
    manager.router = router;

    // Send POST requests for instances of SocialLike to '/like.json'
    [router routeClass:[SocialLike class] toResourcePath:[NSString stringWithFormat:@"%@/like.json",activityIdentity] forMethod:RKRequestMethodPOST];
    
    
    // Send DELETE request for instances of SocialLike to "/like.json'
    [router routeClass:[SocialLike class] toResourcePath:[NSString stringWithFormat:@"%@/like.json",activityIdentity] forMethod:RKRequestMethodDELETE];

    
}


-(void)likeActivity:(NSString *)activity {
    
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL]];
    [RKObjectManager setSharedManager:manager];
    manager.serializationMIMEType = RKMIMETypeFormURLEncoded;
    
    
    RKObjectRouter* router = [[RKObjectRouter new] autorelease];
    manager.router = router;
    
    // Send POST requests for instances of SocialLike to '/like.json'
    [router routeClass:[SocialLike class] toResourcePath:[NSString stringWithFormat:@"%@/like.json",activity] forMethod:RKRequestMethodPOST];
    
    
    // Let's create an SocialActivityDetails
    SocialLike* likeToPost = [[SocialLike alloc] init];
    likeToPost.liked = YES;
    
    //Register our mappings with the provider FOR SERIALIZATION
    RKObjectMapping *postSimpleMapping = [RKObjectMapping mappingForClass: 
                                             [SocialLike class]]; 
    
    [postSimpleMapping mapKeyPathsToAttributes:nil];
    //[postSimpleMapping mapKeyPath:@"liked" toAttribute:@"liked"]; 
    
    //Configure a serialization mapping for our SocialLike class 
    RKObjectMapping *postSimpleSerializationMapping = [postSimpleMapping 
                                                          inverseMapping];
    
    // Send a POST to /like to create the remote instance
    [manager postObject:likeToPost mapResponseWith:postSimpleMapping delegate:self]; 
}


#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects 
{
	NSLog(@"Loaded statuses: %@", objects);    
    //_arrActivityStreams = [objects retain];
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error 
{
	UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
	NSLog(@"Hit error: %@", error);
}

@end
