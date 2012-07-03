//
//  SocialActivityDetailsProxy.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 15/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialActivityDetailsProxy.h"
#import "SocialRestConfiguration.h"
#import "SocialIdentity.h"
#import "SocialComment.h"
#import "SocialActivity.h"



@implementation SocialActivityDetailsProxy

@synthesize activityIdentity = _activityIdentity;
@synthesize numberOfComments = _numberOfComments;
@synthesize numberOfLikes = _numberOfLikes;
@synthesize posterIdentity = _posterIdentity;
@synthesize activityStream = _activityStream;
@synthesize socialActivityDetails = _socialActivityDetails;


#pragma - Object Management

-(id)init {
    if ((self=[super init])) {
        //Default behavior
        _numberOfComments = 0;
        _numberOfLikes = 0;
        _posterIdentity = YES;
        _activityStream = YES;
    }
    return self;
}


-(id)initWithNumberOfComments:(int)nbComments andNumberOfLikes:(int)nbLikes {
    if ((self = [self init])) {
        
        //The set the wanted number of comments
        _numberOfComments = nbComments;
        _numberOfLikes = nbLikes;
        _posterIdentity = YES;
        _activityStream = YES;
    }
    return self;
}



- (void) dealloc {
    [_activityIdentity release];
    [_socialActivityDetails release];
    [super dealloc];
}


#pragma mark - helper methods

//Helper to create the path to get the ressources
- (NSString *)createPath:(NSString *)activityId {
    return [NSString stringWithFormat:@"%@/activity/%@.json", [super createPath], activityId]; 
}

- (NSString *)createLikeResourcePath:(NSString *)activityId {
    return [NSString stringWithFormat:@"%@/activity/%@/likes.json", [super createPath], activityId];
}


//Helper to add Parameters to the request
//Conform to the RestKit Documentation
- (NSDictionary*)createParamDictionary {
    NSMutableDictionary *dicForParams = [[[NSMutableDictionary alloc] init] autorelease];
    
    BOOL hasParams = NO;
    
    //Check for poster Identity
    if (_posterIdentity) {
        [dicForParams setValue:@"t" forKey:@"poster_identity"];
        hasParams = YES;
    }
    
    //Check for ActivityStream
    if (_activityStream) {
        [dicForParams setValue:@"t" forKey:@"activity_stream"];
        hasParams = YES;
    }
    
    //Check for number of Comments
    if (_numberOfComments>0) {
        [dicForParams setValue:[NSString stringWithFormat:@"%d",_numberOfComments] forKey:@"number_of_comments"];
        hasParams = YES;
    }
    
    //Check for number of Likes
    if (_numberOfLikes>0) {
        [dicForParams setValue:[NSString stringWithFormat:@"%d",_numberOfLikes] forKey:@"number_of_likes"];
        hasParams = YES;
    }
        
    if (!hasParams) return nil;
    
    return (NSDictionary *)dicForParams;
}



#pragma - Request Methods

- (void)getActivityDetail:(NSString *)activityId{
    
    RKObjectManager* manager = [RKObjectManager sharedManager];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[SocialActivity class]];
    [mapping mapKeyPathsToAttributes:
     @"identityId",@"identityId",
     @"totalNumberOfComments",@"totalNumberOfComments",
     @"totalNumberOfLikes",@"totalNumberOfLikes",
     @"postedTime",@"postedTime",
     @"type",@"type",
     @"activityStream",@"activityStream",
     @"title",@"title",
     @"body",@"body",
     @"priority",@"priority",
     @"id",@"activityId",
     @"createdAt",@"createdAt",
     @"titleId",@"titleId",
     @"liked",@"liked",
     nil];
    
    
    //Retrieve the UserProfile directly on the activityDetails service
    RKObjectMapping* posterProfileMapping = [RKObjectMapping mappingForClass:[SocialUserProfile class]];
    [posterProfileMapping mapKeyPathsToAttributes:
     @"id",@"identity",
     @"remoteId",@"remoteId",
     @"providerId",@"providerId",
     @"profile.avatarUrl",@"avatarUrl",
     @"profile.fullName",@"fullName",
     nil];

    [mapping mapKeyPath:@"posterIdentity" toRelationship:@"posterIdentity" withObjectMapping:posterProfileMapping];

    
    
    // Create our new SocialCommentIdentity mapping
    RKObjectMapping* socialCommentMapping = [RKObjectMapping mappingForClass:[SocialComment class]];
    [socialCommentMapping mapKeyPathsToAttributes:
     @"createdAt",@"createdAt",
     @"text",@"text",
     @"postedTime",@"postedTime",
     @"id",@"identityId",
     nil];
     [mapping mapKeyPath:@"comments" toRelationship:@"comments" withObjectMapping:socialCommentMapping];
    
    //Retrieve the UserProfile directly for comments 
    RKObjectMapping* commentPosterProfileMapping = [RKObjectMapping mappingForClass:[SocialUserProfile class]];
    [commentPosterProfileMapping mapKeyPathsToAttributes:
     @"id",@"identity",
     @"remoteId",@"remoteId",
     @"providerId",@"providerId",
     @"profile.avatarUrl",@"avatarUrl",
     @"profile.fullName",@"fullName",
     nil];
    
    [socialCommentMapping mapKeyPath:@"posterIdentity" toRelationship:@"userProfile" withObjectMapping:commentPosterProfileMapping];
    
    
    //Retrieve likesByIdentities
    RKObjectMapping* likedByIdentitiesMapping = [RKObjectMapping mappingForClass:[SocialUserProfile class]];
    [likedByIdentitiesMapping mapKeyPathsToAttributes:
     @"id",@"identity",
     @"remoteId",@"remoteId",
     @"providerId",@"providerId",   
     @"profile.avatarUrl",@"avatarUrl",
     @"profile.fullName",@"fullName",
     nil];
    [mapping mapKeyPath:@"likedByIdentities" toRelationship:@"likedByIdentities" withObjectMapping:likedByIdentitiesMapping];
    
     
    [manager loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@",[self createPath:activityId],[self URLEncodedString:[self createParamDictionary]]] 
                         objectMapping:mapping delegate:self];
    
}

- (void)getLikers:(NSString *)activityId {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SocialActivity class]];
    [mapping mapKeyPathsToAttributes:@"totalNumberOfLikes", @"totalNumberOfLikes", nil];
    RKObjectMapping *likesByIdentitiesMapping = [RKObjectMapping mappingForClass:[SocialUserProfile class]];
    [likesByIdentitiesMapping mapKeyPathsToAttributes:
     @"id", @"identity",
     @"remoteId", @"remoteId",
     @"providerId", @"providerId",   
     @"profile.avatarUrl", @"avatarUrl",
     @"profile.fullName", @"fullName",
     nil];
    [mapping mapKeyPath:@"likesByIdentities" toRelationship:@"likedByIdentities" withObjectMapping:likesByIdentitiesMapping];
    [manager loadObjectsAtResourcePath:[self createLikeResourcePath:activityId] objectMapping:mapping delegate:self];
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{
    LogTrace(@"Loaded payload ActivityDetail: %@", [response bodyAsString]);
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects 
{
	//NSLog(@"Loaded statuses ActivityDetail: %@ \n %@", objects, [objects objectAtIndex:0]);    
    
    self.socialActivityDetails = [objects objectAtIndex:0];
    
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
