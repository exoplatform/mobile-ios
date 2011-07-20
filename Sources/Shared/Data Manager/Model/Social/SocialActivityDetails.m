//
//  SocialActivityDetails.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 15/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialActivityDetails.h"


@implementation SocialActivityDetails

@synthesize identityId = _identityId;
@synthesize totalNumberOfComments =_totalNumberOfComments;
@synthesize liked = _liked;
@synthesize postedTime = _postedTime;
@synthesize type = _type;
@synthesize activityStream = _activityStream;
@synthesize title = _title;
@synthesize priority = _priority;
@synthesize identifyId = _identifyId;
@synthesize createdAt = _createdAt;
@synthesize likedByIdentities = _likedByIdentities;
@synthesize titleId = _titleId;
@synthesize posterIdentity = _posterIdentity;
@synthesize comments = _comments;


+ (NSDictionary*)elementToPropertyMappings {
    //for test
	return [NSDictionary dictionaryWithObjectsAndKeys:
            @"identifyId",@"identifyId",
            @"totalNumberOfComments",@"totalNumberOfComments",
            @"postedTime",@"postedTime",
            @"type",@"type",
            @"activityStream",@"activityStream",
            @"title",@"title",
            @"priority",@"priority",
            @"identifyId",@"identifyId",
            @"createdAt",@"createdAt",
            @"titleId",@"titleId",
            @"posterIdentity",@"posterIdentity",
            nil];
}


+ (NSDictionary*)elementToRelationshipMappings {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"comments", @"comments",
            nil];
}

- (void)dealloc {
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%@",_comments];
}

@end