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
@synthesize userFullName = _userFullName;
@synthesize userImageAvatar = _userImageAvatar;
@synthesize postedTimeInWords = _postedTimeInWords;

 
- (void)dealloc {
    [_identityId release];
    [_type release];
    [_posterIdentity release];
    [_activityStream release];
    [_identify release];
    [_title release];
    [_priority release];
    [_createdAt release];
    [_likedByIdentities release];
    [_titleId release];
    [_comments release];
    [_userFullName release];
    [_postedTimeInWords release];
    [super dealloc];
}

- (void)convertToPostedTimeInWords
{
    self.postedTimeInWords = [[NSDate date] distanceOfTimeInWordsWithTimeInterval:self.postedTime];
}

- (void)setFullName:(NSString*)strFullName
{
    self.userFullName = [strFullName copy];
}

@end
