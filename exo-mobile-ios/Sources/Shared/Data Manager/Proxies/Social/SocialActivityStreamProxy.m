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
#import "SocialActivityStream.h"
#import "SocialUserProfileProxy.h"


@implementation SocialActivityStreamProxy

@synthesize socialUserProfile = _socialUserProfile;
@synthesize arrActivityStreams = _arrActivityStreams;
@synthesize isUpdateRequest = _isUpdateRequest;


- (id)initWithSocialUserProfile:(SocialUserProfile*)aSocialUserProfile
{
    if ((self = [super init])) 
    { 
        _socialUserProfile = [aSocialUserProfile retain];
        _isUpdateRequest = NO;
    } 
    return self;
}

- (void)dealloc 
{
    delegate = nil;
    [[RKRequestQueue sharedQueue] cancelAllRequests];

    [_socialUserProfile release]; _socialUserProfile = nil;
    [_arrActivityStreams release]; _arrActivityStreams = nil;
    [super dealloc];
}


#pragma mark - helper methods

//Helper to create the base URL
- (NSString *)createBaseURL 
{
    SocialRestConfiguration* socialConfig = [SocialRestConfiguration sharedInstance];
    
    
//    NSLog(@"%@",[NSString stringWithFormat:@"%@/%@/private/api/social/%@/%@/activity_stream/",socialConfig.domainName,socialConfig.restContextName,socialConfig.restVersion,socialConfig.portalContainerName]);
    
    return [NSString stringWithFormat:@"%@/%@/private/api/social/%@/%@/activity_stream/",socialConfig.domainName,socialConfig.restContextName,socialConfig.restVersion,socialConfig.portalContainerName];

}



//Helper to create the path to get the ressources
- (NSString *)createPath 
{    
//    NSLog(@"%@", [NSString stringWithFormat:@"feed.json",_socialUserProfile.identity]);
    
    return @"feed.json"; 
}


#pragma mark - Call methods

- (void) getActivityStreams 
{
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL]];
    [RKObjectManager setSharedManager:manager];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[SocialActivityStream class]];
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
    [mapping mapKeyPath:@"posterIdentity" toRelationship:@"posterUserProfile" withObjectMapping:posterProfileMapping];
    
    
    //[manager registerClass:[SocialActivityStream class] forElementNamed:@"activities"];
    [manager loadObjectsAtResourcePath:[self createPath] delegate:self];   
}

- (void)updateActivityStreamSinceActivity:(SocialActivityStream*)activity {

    _isUpdateRequest = YES;
    
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL]];
    [RKObjectManager setSharedManager:manager];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[SocialActivityStream class]];
    [mapping mapKeyPathsToAttributes:
     @"identityId",@"identityId",
     @"liked",@"liked",
     @"postedTime",@"postedTime",            
     @"type",@"type",
     @"posterIdentity",@"posterIdentity",
     @"id",@"activityId",
     @"title",@"title",
     @"body",@"body",
     @"createdAt",@"createdAt",
     @"titleId",@"titleId",
     @"templateParams", @"templateParams",
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
    [mapping mapKeyPath:@"posterIdentity" toRelationship:@"posterUserProfile" withObjectMapping:posterProfileMapping];
    
    //[manager registerClass:[SocialActivityStream class] forElementNamed:@"activities"];
    [manager loadObjectsAtResourcePath:[NSString stringWithFormat:@"feed.json?since_id=%@",activity.activityId] delegate:self]; 
    
}



#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{
    //NSLog(@"Loaded payload Avtivity Stream: %@", [response bodyAsString]);
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects 
{
	//NSLog(@"Loaded statuses: %@", objects);    
    _arrActivityStreams = [objects retain];
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
