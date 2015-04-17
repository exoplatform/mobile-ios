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
@interface SocialSpaceProxy (){
}
@end

@implementation SocialSpaceProxy

-(void) getMySocialSpaces {
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    // Load the object model via RestKit
    RKObjectManager* manager = [RKObjectManager sharedManager];
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[SocialSpace class]];
    [mapping mapKeyPathsToAttributes:
     @"avatarUrl",@"avatarUrl",
     @"groupId",@"groupId",
     @"spaceUrl",@"spaceUrl",
     @"url",@"url",
     @"name",@"name",
     @"displayName",@"displayName",
     nil];
    [mapping setRootKeyPath:@"spaces"];
    [manager.mappingProvider setObjectMapping:mapping forKeyPath:@"spaces"];

    
    [manager loadObjectsAtResourcePath:MY_SPACE_PATH objectMapping:mapping delegate:self];
    
}

-(void) getIdentifyOfSpace:(SocialSpace *)space {
    
    RKObjectManager* manager = [RKObjectManager sharedManager];
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[SocialSpace class]];
    [mapping mapKeyPathsToAttributes:
     @"id",@"spaceId",
     nil];
    
    NSString * path = [NSString stringWithFormat:@"private/api/social/v1-alpha3/portal/identity/space/%@.json", space.name];
    
    [manager loadObjectsAtResourcePath:path objectMapping:mapping delegate:self];
}


#pragma mark - RKObjectLoaderDelegate methods
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    self.mySpaces = objects;
    [super objectLoader:objectLoader didLoadObjects:objects];
}

@end
