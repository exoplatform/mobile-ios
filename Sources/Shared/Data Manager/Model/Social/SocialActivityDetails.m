//
//  SocialActivityDetails.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 15/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialActivityDetails.h"
#import "NSDate+Formatting.h"

@implementation SocialActivityDetails

@synthesize identityId = _identityId;
@synthesize totalNumberOfComments =_totalNumberOfComments;
@synthesize totalNumberOfLikes =_totalNumberOfLikes;

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

@synthesize postedTimeInWords = _postedTimeInWords;

@synthesize templateParams = templateParams;


- (void)dealloc {
    [super dealloc];
}

- (void)convertToPostedTimeInWords
{
    self.postedTimeInWords = [[NSDate date] distanceOfTimeInWordsWithTimeInterval:self.postedTime];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ %@",_title,_identityId,_comments];
}

- (void)setKeyForTemplateParams:(NSString*)key value:(NSString*)value {
        
    [self.templateParams setValue:value forKey:key];
}

@end
