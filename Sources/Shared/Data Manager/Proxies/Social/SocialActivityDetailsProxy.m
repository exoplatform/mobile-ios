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

-(instancetype)init {
    if ((self=[super init])) {
        //Default behavior
        _numberOfComments = 0;
        _numberOfLikes = 0;
        _posterIdentity = YES;
        _activityStream = YES;
    }
    return self;
}


-(instancetype)initWithNumberOfComments:(int)nbComments andNumberOfLikes:(int)nbLikes {
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

- (NSString *)createCommentsResourcePath:(NSString *)activityId {
    return [NSString stringWithFormat:@"%@/activity/%@/comments.json", [super createPath], activityId];
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

- (void)getAllOfComments:(NSString *)activityId {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SocialActivity class]];
    [mapping mapKeyPath:@"totalNumberOfComments" toAttribute:@"totalNumberOfComments"];
    // SocialComment mapping
    RKObjectMapping* socialCommentMapping = [RKObjectMapping mappingForClass:[SocialComment class]];
    [socialCommentMapping mapKeyPathsToAttributes:@"createdAt",@"createdAt",
            @"text",@"text",
            @"postedTime",@"postedTime",
            @"id",@"identityId",
     nil];
    RKObjectMapping* commentPosterProfileMapping = [RKObjectMapping mappingForClass:[SocialUserProfile class]];
    [commentPosterProfileMapping mapKeyPathsToAttributes:
        @"id",@"identity",
        @"remoteId",@"remoteId",
        @"providerId",@"providerId",
        @"profile.avatarUrl",@"avatarUrl",
        @"profile.fullName",@"fullName",
     nil];
    [socialCommentMapping mapKeyPath:@"posterIdentity" toRelationship:@"userProfile" withObjectMapping:commentPosterProfileMapping];
    
    [mapping mapKeyPath:@"comments" toRelationship:@"comments" withObjectMapping:socialCommentMapping];
    [manager loadObjectsAtResourcePath:[self createCommentsResourcePath:activityId] objectMapping:mapping delegate:self];
}

#pragma mark - RKObjectLoaderDelegate methods
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects 
{
    self.socialActivityDetails = objects[0];
    [super objectLoader:objectLoader didLoadObjects:objects];
}

@end
