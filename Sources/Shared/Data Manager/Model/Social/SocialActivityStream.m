//
//  SocialActivityStream.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialActivityStream.h"
#import "NSDate+Formatting.h"

@implementation SocialActivityStream

@synthesize identityId = _identityId;
@synthesize totalNumberOfComments = _totalNumberOfComments;
@synthesize totalNumberOfLikes = _totalNumberOfLikes;
@synthesize liked = _liked;
@synthesize postedTime = _postedTime;
@synthesize type = _type;
@synthesize posterIdentity = _posterIdentity;
@synthesize activityId = _activityId;
@synthesize title = _title;
@synthesize createdAt = _createdAt;
@synthesize likedByIdentities = _likedByIdentities;
@synthesize titleId = _titleId;
@synthesize comments = _comments;
@synthesize postedTimeInWords = _postedTimeInWords;
@synthesize posterUserProfile = _posterUserProfile;
@synthesize posterPicture = _posterPicture;
 
- (void)dealloc {
    [_identityId release];
    [_type release];
    [_posterIdentity release];
    [_activityId release];
    [_title release];
    [_createdAt release];
    [_likedByIdentities release];
    [_titleId release];
    [_comments release];
    [_postedTimeInWords release];
    [_posterUserProfile release];
    [_posterPicture release];
    [super dealloc];
}

- (void)convertToPostedTimeInWords
{    
    self.postedTimeInWords = [[NSDate date] distanceOfTimeInWordsWithTimeInterval:self.postedTime];
}


@end
