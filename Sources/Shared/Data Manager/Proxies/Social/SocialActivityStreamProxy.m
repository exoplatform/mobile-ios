//
//  SocialActivityStreamProxy.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 07/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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

//Helper to create the path to get the ressources
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
    return [NSString stringWithFormat:@"%@/activity_stream/%@", [super createPath], lastPath];
}

#pragma mark - Call methods

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
    
    
    //[manager registerClass:[SocialActivity class] forElementNamed:@"activities"];
    [manager loadObjectsAtResourcePath:[self createPathForType:activitytype] delegate:self];   
}

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
    
    [manager loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?max_id=%@",[self createPathForType:activitytype], activity.activityId] delegate:self]; 
    
}

#pragma mark - RKObjectLoaderDelegate methods
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects 
{
    self.arrActivityStreams = objects;
    [super objectLoader:objectLoader didLoadObjects:objects];
}

@end
