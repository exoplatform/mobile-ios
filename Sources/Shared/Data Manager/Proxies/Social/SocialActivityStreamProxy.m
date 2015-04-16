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

#import "SocialActivityStreamProxy.h"
#import "SocialIdentity.h"
#import "SocialRestConfiguration.h"
#import "SocialUserProfileProxy.h"


@implementation SocialActivityStreamProxy

@synthesize arrActivityStreams = _arrActivityStreams;
@synthesize isUpdateRequest = _isUpdateRequest;
@synthesize userProfile = _userProfile;

- (id)init
{
    if ((self = [super init])) 
    { 
        _isUpdateRequest = NO;
    } 
    return self;
}

- (void)dealloc 
{
    delegate = nil;
    [_arrActivityStreams release];
    [_userProfile release];
    [super dealloc];
}


#pragma mark - helper methods

//Helper to create the path to get the resources
- (NSString *)createPath 
{    
    return [NSString stringWithFormat:@"%@/activity_stream/%@", [super createPath], @"feed.json"]; 
}

- (NSString *)createPathForType:(ActivityStreamProxyActivityType)activityType {
    NSString *lastPath = nil;
    switch (activityType) {
        case ActivityStreamProxyActivityTypeAllUpdates:
            lastPath = @"feed.json";
            break;
        case ActivityStreamProxyActivityTypeMyConnections:
            lastPath = @"connections.json";
            break;
        case ActivityStreamProxyActivityTypeMySpaces:
            lastPath = @"spaces.json";            
            break;
        case ActivityStreamProxyActivityTypeMyStatus:
            lastPath = [NSString stringWithFormat:@"%@.json", self.userProfile.identity];
            break;
        default:
            break;
    }
    NSLog(@"%@",[NSString stringWithFormat:@"%@/activity_stream/%@", [super createPath], lastPath]);
    return [NSString stringWithFormat:@"%@/activity_stream/%@", [super createPath], lastPath];
}

#pragma mark - Call methods

/*
 * Load the 100 most recent activities of the given type:
 * ActivityStreamProxyActivityTypeAllUpdates    : All updates 
 * ActivityStreamProxyActivityTypeMyConnections : My connections only
 * ActivityStreamProxyActivityTypeMySpaces      : My spaces only
 * ActivityStreamProxyActivityTypeMyStatus      : My statuses only
 * Maps the JSON properties with the SocialActivity attributes, cf
 * https://github.com/RestKit/RestKit/blob/master/Docs/Object%20Mapping.md
 */
- (void) getActivityStreams:(ActivityStreamProxyActivityType)activitytype
{
    RKObjectManager* manager = [RKObjectManager sharedManager];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[SocialActivity class]];
    [mapping mapKeyPathsToAttributes:
     @"identityId",@"identityId",
     @"liked",@"liked",
     @"postedTime",@"postedTime",
     @"type",@"type",
     @"id",@"activityId",
     @"title",@"title",
     @"body",@"body",
     @"createdAt",@"createdAt",
     @"titleId",@"titleId",
     @"totalNumberOfComments",@"totalNumberOfComments",
     @"totalNumberOfLikes",@"totalNumberOfLikes",
     @"templateParams", @"templateParams",
     @"activityStream", @"activityStream",
     @"lastUpdated",@"lastUpdated",
    nil];
    
    [manager.mappingProvider setObjectMapping:mapping forKeyPath:@"activities"];
    
    //Retrieve the UserProfile directly on the activityStream service
    RKObjectMapping* posterProfileMapping = [RKObjectMapping mappingForClass:[SocialUserProfile class]];
    [posterProfileMapping mapKeyPathsToAttributes:
     @"id",@"identity",
     @"remoteId",@"remoteId",
     @"providerId",@"providerId",
     @"profile.avatarUrl",@"avatarUrl",
     @"profile.fullName",@"fullName",
     nil];
    [mapping mapKeyPath:@"posterIdentity" toRelationship:@"posterIdentity" withObjectMapping:posterProfileMapping];
    
    // No need to keep and retain the RKObjectLoader here because we don't need RK if the
    // request fails, we just display an error dialog
    [manager loadObjectsAtResourcePath:[self createPathForType:activitytype] delegate:self];
}

/*
 * Loads the 100 activities of the given type that were published before the given activity
 * Cf method above for explanation of the types and the RK mapping
 */
- (void)getActivitiesOfType:(ActivityStreamProxyActivityType)activitytype BeforeActivity:(SocialActivity*)activity {
    
    RKObjectManager* manager = [RKObjectManager sharedManager];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[SocialActivity class]];
    [mapping mapKeyPathsToAttributes:
     @"identityId",@"identityId",
     @"liked",@"liked",
     @"postedTime",@"postedTime",            
     @"type",@"type",
     @"id",@"activityId",
     @"title",@"title",
     @"body",@"body",
     @"createdAt",@"createdAt",
     @"titleId",@"titleId",
     @"templateParams", @"templateParams",
     @"activityStream", @"activityStream",
     @"lastUpdated", @"lastUpdated",
     nil];
    
    [manager.mappingProvider setObjectMapping:mapping forKeyPath:@"activities"];
    
    
    //Retrieve the UserProfile directly on the activityStream service
    RKObjectMapping* posterProfileMapping = [RKObjectMapping mappingForClass:[SocialUserProfile class]];
    [posterProfileMapping mapKeyPathsToAttributes:
     @"id",@"identity",
     @"remoteId",@"remoteId",
     @"providerId",@"providerId",
     @"profile.avatarUrl",@"avatarUrl",
     @"profile.fullName",@"fullName",
     nil];
    [mapping mapKeyPath:@"posterIdentity" toRelationship:@"posterIdentity" withObjectMapping:posterProfileMapping];
    
    // Keep and retain the instance of RKObjectLoader, so RK can use it if there is an error
    // and it needs to make another request to reload all activities
    // We will release it when the LoadMore request is successful, 
    // or when the UpdateAfterError request ends (successful or not)
    // Cf ActivityStreamBrowseViewController:didFinishLoading and :didFailWithError
    rkLoader = [[manager loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?max_id=%@",[self createPathForType:activitytype], activity.activityId] delegate:self] retain];
}

#pragma mark - RKObjectLoaderDelegate methods
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects 
{
    self.arrActivityStreams = objects;
    [super objectLoader:objectLoader didLoadObjects:objects];
}

@end
