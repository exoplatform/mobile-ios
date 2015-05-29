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

#import "SocialPostCommentProxy.h"
#import "SocialRestConfiguration.h"
#import "SocialComment.h"


@implementation SocialPostCommentProxy

@synthesize comment=_comment, userIdentity = _userIdentity;

- (instancetype)init 
{
    if ((self = [super init])) 
    {
        _comment=@"";
    } 
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

#pragma mark - helper methods


#pragma mark - Call methods

-(void)postComment:(NSString *)commentValue forActivity:(NSString *)activityIdentity
{

    if (commentValue != nil) {
        _comment = commentValue;
    }
    
    RKObjectManager* manager = [RKObjectManager sharedManager];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    
    RKRouter* router = [[RKRouter alloc] initWithBaseURL:manager.baseURL];
    manager.router = router;
    
    
    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[SocialComment class] pathPattern:[NSString stringWithFormat:@"%@/activity/%@/comment.json", [super createPath], activityIdentity] method:RKRequestMethodPOST]];
    
    // Let's create an SocialActivityDetails
    SocialComment* commentToPost = [[SocialComment alloc] init];
    commentToPost.text = _comment;
    
    //Register our mappings with the provider FOR SERIALIZATION
    
    RKObjectMapping* commentSimpleMapping = [RKObjectMapping requestMapping];
    
    [commentSimpleMapping  addAttributeMappingsFromDictionary:@{@"text":@"text"}];
    
    // Send a POST to /like to create the remote instance
    
    RKRequestDescriptor * requestDescriptor =  [RKRequestDescriptor requestDescriptorWithMapping:commentSimpleMapping objectClass:[SocialComment class] rootKeyPath:nil method:RKRequestMethodPOST];

    [manager addRequestDescriptor:requestDescriptor];
    
    
    RKObjectMapping* responseMapping = [RKObjectMapping mappingForClass:[SocialComment class]];
    [responseMapping addAttributeMappingsFromDictionary:@{
                                                          @"createdAt":@"createdAt",
                                                          @"text":@"text",
                                                          @"postedTime":@"postedTime",
                                                          @"identityId":@"identityId"
                                                          }];
    
    RKResponseDescriptor * responseDescriptor =  [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]] ;
    

    [manager addResponseDescriptor:responseDescriptor];
    
    [manager  postObject:commentToPost path:[NSString stringWithFormat:@"%@/activity/%@/comment.json", [super createPath], activityIdentity] parameters:nil
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     [super restKitDidLoadObjects:[mappingResult array]];
                 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     [super restKitDidFailWithError:error];
                 }
     ];
}

@end
