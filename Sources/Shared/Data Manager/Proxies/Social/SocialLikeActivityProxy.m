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

#import "RKRouter.h"
#import "RKObjectManager.h"
@implementation SocialLikeActivityProxy


#pragma mark - helper methods

- (void) configureObjectManagerForActivity:(NSString *)activityIdentity {
    
    RKObjectManager* manager = [RKObjectManager sharedManager];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    
    RKRouter* router = [[RKRouter alloc] initWithBaseURL:manager.baseURL];
    manager.router = router;

    // Send POST requests for instances of SocialLike to '/like.json'
    
    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[SocialLike class] pathPattern:[NSString stringWithFormat:@"%@/like.json",activityIdentity] method:RKRequestMethodPOST]];
    

    
    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[SocialLike class] pathPattern:[NSString stringWithFormat:@"%@/like.json",activityIdentity]  method:RKRequestMethodDELETE]];
    
    
}

- (NSString *)createPathWithActivityId:(NSString *)activityId {
    return [NSString stringWithFormat:@"%@/activity/%@/like.json", [super createPath], activityId]; 
}


-(void)likeActivity:(NSString *)activity {
    
    RKObjectManager* manager = [RKObjectManager sharedManager];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    
    RKRouter* router = [[RKRouter alloc] initWithBaseURL:manager.baseURL];
    manager.router = router;
    

    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[SocialLike class] pathPattern:[self createPathWithActivityId:activity] method:RKRequestMethodPOST]];
    
    SocialLike* likeToPost = [[SocialLike alloc] init];
    likeToPost.like = YES;
    
    RKObjectMapping* postSimpleMapping = [RKObjectMapping requestMapping];
    
    [postSimpleMapping  addAttributeMappingsFromDictionary:@{@"like":@"like"}];
    
    RKRequestDescriptor * requestDescriptor =  [RKRequestDescriptor requestDescriptorWithMapping:postSimpleMapping objectClass:[SocialLike class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKObjectMapping* responseMapping = [RKObjectMapping mappingForClass:[SocialLike class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"like":@"like"}];
    
    RKResponseDescriptor * responseDescriptor =  [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]] ;
    
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    
    [manager  postObject:likeToPost path:[self createPathWithActivityId:activity] parameters:nil
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     [super restKitDidLoadObjects:[mappingResult array]];
                 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     [super restKitDidFailWithError:error];
                 }
     ];
    
}


-(void)dislikeActivity:(NSString *)activity {
    
//RestKit 0.24
    
    RKObjectManager* manager = [RKObjectManager sharedManager];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    RKRouter* router = [[RKRouter alloc] initWithBaseURL:manager.baseURL];
    manager.router = router;
    
    // Send POST requests for instances of SocialLike to '/like.json'
    
    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[SocialLike class] pathPattern:[self createPathWithActivityId:activity] method:RKRequestMethodDELETE]];
    
    // Let's create an SocialActivityDetails
    SocialLike* likeToPost = [[SocialLike alloc] init];
    likeToPost.like = NO;
    
    //Register our mappings with the provider FOR SERIALIZATION
    RKObjectMapping *deleteSimpleMapping = [RKObjectMapping requestMapping];

    [deleteSimpleMapping addAttributeMappingsFromDictionary:@{@"like":@"like"}];
    
    
    // Send a DELETE to /like to create the remote instance
    
    
    RKRequestDescriptor * requestDescriptor =  [RKRequestDescriptor requestDescriptorWithMapping:deleteSimpleMapping objectClass:[SocialLike class] rootKeyPath:nil method:RKRequestMethodDELETE];
    
    [manager addRequestDescriptor:requestDescriptor];
    
    
    // Add the response mapping
    RKObjectMapping* responseMapping = [RKObjectMapping mappingForClass:[SocialLike class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"like":@"like"}];
    
    RKResponseDescriptor * responseDescriptor =  [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]] ;
    [manager addResponseDescriptor:responseDescriptor];
    
    [manager  deleteObject:likeToPost path:[self createPathWithActivityId:activity]  parameters:nil
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     [super restKitDidLoadObjects:[mappingResult array]];
                 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     [super restKitDidFailWithError:error];
                 }
     ];
    
    
}

@end
