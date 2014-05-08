//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
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

@end
