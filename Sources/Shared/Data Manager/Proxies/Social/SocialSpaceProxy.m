//
// Copyright (C) 2003-2015 eXo Platform SAS.
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


#import "SocialSpaceProxy.h"


#define MY_SPACE_PATH @"private/portal/social/spaces/mySpaces/show.json"

@implementation SocialSpaceProxy

@synthesize mySpaces = _mySpaces;

-(void) getMySocialSpaces {
    // Load the object model via RestKit
    RKObjectManager* manager = [RKObjectManager sharedManager];
    

    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[SocialSpace class]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"avatarUrl":@"avatarUrl",
     @"groupId":@"groupId",
     @"spaceUrl":@"spaceUrl",
     @"url":@"url",
     @"name":@"name",
     @"displayName":@"displayName"
     }];
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:MY_SPACE_PATH keyPath:@"spaces" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    [manager addResponseDescriptor:responseDescriptor];
    [manager getObjectsAtPath:MY_SPACE_PATH parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [self restKitDidLoadObjects:[mappingResult array]];
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          [super restKitDidFailWithError:error];
                      }
     ];

    
}

-(void) getIdentifyOfSpace:(SocialSpace *)space {
    RKObjectManager* manager = [RKObjectManager sharedManager];
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[SocialSpace class]];
    [mapping addAttributeMappingsFromDictionary:@{@"id":@"spaceId" }];
    
    NSString * path = [NSString stringWithFormat:@"private/api/social/v1-alpha3/portal/identity/space/%@.json", space.name];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:path keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [manager addResponseDescriptor:responseDescriptor];
    [manager getObjectsAtPath:path parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [self restKitDidLoadObjects:[mappingResult array]];
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          [super restKitDidFailWithError:error];
                      }
     ];
}


#pragma mark - RKObjectLoaderDelegate methods
- (void)restKitDidLoadObjects:(NSArray*)objects
{
    self.mySpaces = objects;
    [super restKitDidLoadObjects:objects];

}

@end
