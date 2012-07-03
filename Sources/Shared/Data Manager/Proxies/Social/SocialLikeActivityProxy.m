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

- (void) configureObjectManagerForActivity:(NSString *)activityIdentity {
    
    RKObjectManager* manager = [RKObjectManager sharedManager];
    manager.serializationMIMEType = RKMIMETypeJSON;
    
    
    RKObjectRouter* router = [[RKObjectRouter new] autorelease];
    manager.router = router;

    // Send POST requests for instances of SocialLike to '/like.json'
    [router routeClass:[SocialLike class] toResourcePath:[NSString stringWithFormat:@"%@/like.json",activityIdentity] forMethod:RKRequestMethodPOST];
    
    
    // Send DELETE request for instances of SocialLike to "/like.json'
    [router routeClass:[SocialLike class] toResourcePath:[NSString stringWithFormat:@"%@/like.json",activityIdentity] forMethod:RKRequestMethodDELETE];

    
}

- (NSString *)createPathWithActivityId:(NSString *)activityId {
    return [NSString stringWithFormat:@"%@/activity/%@/like.json", [super createPath], activityId]; 
}


-(void)likeActivity:(NSString *)activity {
    
    RKObjectManager* manager = [RKObjectManager sharedManager];
    manager.serializationMIMEType = RKMIMETypeJSON;
    
    
    RKObjectRouter* router = [[RKObjectRouter new] autorelease];
    manager.router = router;
    
    // Send POST requests for instances of SocialLike to '/like.json'
    [router routeClass:[SocialLike class] toResourcePath:[self createPathWithActivityId:activity] forMethod:RKRequestMethodPOST];
    
    
    // Let's create an SocialActivityDetails
    SocialLike* likeToPost = [[[SocialLike alloc] init] autorelease];
    likeToPost.like = YES;
    
    //Register our mappings with the provider FOR SERIALIZATION
    RKObjectMapping *postSimpleMapping = [RKObjectMapping mappingForClass: 
                                             [SocialLike class]]; 
    
    [postSimpleMapping mapKeyPathsToAttributes:nil];
    [postSimpleMapping mapKeyPath:@"like" toAttribute:@"like"]; 
    
    //Configure a serialization mapping for our SocialLike class 
    RKObjectMapping *postSimpleSerializationMapping = [postSimpleMapping inverseMapping];
    [postSimpleSerializationMapping removeAllMappings];
    
    [manager.mappingProvider setSerializationMapping:postSimpleSerializationMapping 
                                            forClass:[SocialLike class]];
        
    // Send a POST to /like to create the remote instance
    [manager postObject:likeToPost mapResponseWith:postSimpleMapping delegate:self]; 
}


-(void)dislikeActivity:(NSString *)activity {
    
    RKObjectManager* manager = [RKObjectManager sharedManager];
    manager.serializationMIMEType = RKMIMETypeJSON;
    
    
    RKObjectRouter* router = [[RKObjectRouter new] autorelease];
    manager.router = router;
    
    // Send POST requests for instances of SocialLike to '/like.json'
    [router routeClass:[SocialLike class] toResourcePath:[self createPathWithActivityId:activity] forMethod:RKRequestMethodDELETE];
    
    
    // Let's create an SocialActivityDetails
    SocialLike* likeToPost = [[[SocialLike alloc] init] autorelease];
    likeToPost.like = NO;
    
    //Register our mappings with the provider FOR SERIALIZATION
    RKObjectMapping *deleteSimpleMapping = [RKObjectMapping mappingForClass: 
                                          [SocialLike class]]; 
    
    [deleteSimpleMapping mapKeyPathsToAttributes:nil];
    [deleteSimpleMapping mapKeyPath:@"like" toAttribute:@"like"]; 
    
    //Configure a serialization mapping for our SocialLike class 
    RKObjectMapping *deleteSimpleSerializationMapping = [deleteSimpleMapping inverseMapping];
    [deleteSimpleSerializationMapping removeAllMappings];
    
    [manager.mappingProvider setSerializationMapping:deleteSimpleSerializationMapping 
                                            forClass:[SocialLike class]];
    
    //[manager.client post:[NSString stringWithFormat:@"%@/like.json",activity] params:[NSDictionary dictionaryWithObjectsAndKeys:nil] delegate:self];
    
    // Send a DELETE to /like to create the remote instance
    [manager deleteObject:likeToPost mapResponseWith:deleteSimpleMapping delegate:self]; 
}


#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{
    LogDebug(@"Loaded payload: %@", [response bodyAsString]);
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects 
{
    if (delegate && [delegate respondsToSelector:@selector(proxyDidFinishLoading:)]) {
        [delegate proxyDidFinishLoading:self];
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error 
{
    if (delegate && [delegate respondsToSelector:@selector(proxy: didFailWithError:)]) {
        [delegate proxy:self didFailWithError:error];
    }
}

@end
