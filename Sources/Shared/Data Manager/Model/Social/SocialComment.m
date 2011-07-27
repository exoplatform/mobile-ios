//
//  SocialComment.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 15/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialComment.h"
#import "NSDate+Formatting.h"

@implementation SocialComment

@synthesize text = _text;
@synthesize identityId = _identityId; 
@synthesize createdAt = _createdAt;
@synthesize postedTime = _postedTime;

@synthesize postedTimeInWords = _postedTimeInWords;

- (NSString *)description
{
    return [NSString stringWithFormat:@"-%@, %@, %@, %@-",_text,_identityId,_createdAt,_postedTime];
}

- (void)convertToPostedTimeInWords
{
    self.postedTimeInWords = [[NSDate date] distanceOfTimeInWordsWithTimeInterval:self.postedTime];
}

@end
