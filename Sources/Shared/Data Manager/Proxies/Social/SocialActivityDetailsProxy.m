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

- (void)getLikers:(NSString *)activityId {

    //RestKit 0.24
    RKObjectManager *manager = [RKObjectManager sharedManager];
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SocialActivity class]];
    
    [mapping addAttributeMappingsFromDictionary:@{@"totalNumberOfLikes": @"totalNumberOfLikes"}];
    RKObjectMapping *likesByIdentitiesMapping = [RKObjectMapping mappingForClass:[SocialUserProfile class]];
    [likesByIdentitiesMapping addAttributeMappingsFromDictionary:@{
     @"id": @"identity",
     @"remoteId": @"remoteId",
     @"providerId": @"providerId",
     @"profile.avatarUrl": @"avatarUrl",
     @"profile.fullName": @"fullName"}];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"likesByIdentities" toKeyPath:@"likedByIdentities" withMapping:likesByIdentitiesMapping]];
    
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                 method:RKRequestMethodGET
                                            pathPattern:[self createLikeResourcePath:activityId]
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [manager addResponseDescriptor:responseDescriptor];
    
    [manager getObjectsAtPath:[self createLikeResourcePath:activityId] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.socialActivityDetails = [[mappingResult array] objectAtIndex:0];
        [super restKitDidLoadObjects:[mappingResult array]];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [super restKitDidFailWithError:error];
    }];
    
//    [manager loadObjectsAtResourcePath:[self createLikeResourcePath:activityId] objectMapping:mapping delegate:self];

}

- (void)getAllOfComments:(NSString *)activityId {

    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SocialActivity class]];
    
    [mapping addAttributeMappingsFromDictionary:@{@"totalNumberOfComments": @"totalNumberOfComments"}];
    // SocialComment mapping
    RKObjectMapping* socialCommentMapping = [RKObjectMapping mappingForClass:[SocialComment class]];
    [socialCommentMapping addAttributeMappingsFromDictionary:
     @{@"createdAt":@"createdAt",
       @"text":@"text",
       @"postedTime":@"postedTime",
       @"id":@"identityId"}
     ];

    RKObjectMapping* commentPosterProfileMapping = [RKObjectMapping mappingForClass:[SocialUserProfile class]];
    [commentPosterProfileMapping addAttributeMappingsFromDictionary:@{
     @"id":@"identity",
     @"remoteId":@"remoteId",
     @"providerId":@"providerId",
     @"profile.avatarUrl":@"avatarUrl",
     @"profile.fullName":@"fullName"}];


    [socialCommentMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"posterIdentity" toKeyPath:@"userProfile" withMapping:commentPosterProfileMapping]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"comments" toKeyPath:@"comments" withMapping:socialCommentMapping]];
    
   
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                 method:RKRequestMethodGET
                                            pathPattern:[self createCommentsResourcePath:activityId]
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [manager addResponseDescriptor:responseDescriptor];
    
    [manager getObjectsAtPath:[self createCommentsResourcePath:activityId] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.socialActivityDetails = [[mappingResult array] objectAtIndex:0];
        [super restKitDidLoadObjects:[mappingResult array]];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [super restKitDidFailWithError:error];
    }];

}


@end
