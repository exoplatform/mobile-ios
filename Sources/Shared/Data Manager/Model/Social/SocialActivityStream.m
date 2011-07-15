//
//  SocialActivityStream.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialActivityStream.h"


@implementation SocialActivityStream

@synthesize identityId = _identityId;
@synthesize totalNumberOfComments = _totalNumberOfComments;
@synthesize liked = _liked;
@synthesize postedTime = _postedTime;
@synthesize type = _type;
@synthesize posterIdentity = _posterIdentity;
@synthesize activityStream = _activityStream;
@synthesize identify = _identify;
@synthesize title = _title;
@synthesize priority = _priority;
@synthesize createdAt = _createdAt;
@synthesize likedByIdentities = _likedByIdentities;
@synthesize titleId = _titleId;
@synthesize comments = _comments;


+ (NSDictionary*)relationshipToPrimaryKeyPropertyMappings {
    //for test
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"identityId",@"identityId",
//            @"totalNumberOfComments",@"activities.totalNumberOfComments",
//            @"liked",@"activities.liked",
//            @"postedTime",@"activities.postedTime",            
//            @"type",@"activities.type",
//            @"posterIdentity",@"activities.posterIdentity",
//            @"activityStream",@"activities.activityStream",
//            @"identify",@"activities.id",
//            @"title",@"activities.title",
//            @"priority",@"activities.priority",
//            @"createdAt",@"activities.createdAt",
//            @"likedByIdentities",@"activities.likedByIdentities",
//            @"titleId",@"activities.titleId",
//            @"comments",@"activities.comments",
			nil];
}

//+ (NSArray*)relationshipsToSerialize
//{
//    return [NSArray array];
//}

- (void)dealloc {
    [_identityId release];
    [_totalNumberOfComments release];
    [_liked release];
    [_postedTime release];
    [_title release];
    [_createdAt release];
    [super dealloc];
}

@end
