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




- (void)dealloc {
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ %@",_title,_identityId,_comments];
}

@end
