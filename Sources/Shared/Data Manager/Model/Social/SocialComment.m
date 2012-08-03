//
//  SocialComment.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 15/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialComment.h"
#import "NSDate+Formatting.h"
#import "GTMNSString+HTML.h"

@implementation SocialComment

@synthesize text = _text;
@synthesize identityId = _identityId; 
@synthesize createdAt = _createdAt;
@synthesize postedTime = _postedTime;
@synthesize userProfile = _userProfile;

@synthesize postedTimeInWords = _postedTimeInWords;

- (NSString *)description
{
    return [NSString stringWithFormat:@"-%@, %@, %@, %@",_text?_text:@"",_identityId?_identityId:@"",_createdAt?_createdAt:@"", [_userProfile description]];
}

- (void)convertToPostedTimeInWords
{
    self.postedTimeInWords = [[NSDate dateWithTimeIntervalSince1970:self.postedTime/1000] distanceOfTimeInWords];
}


- (NSString*)fixupTextForStyledTextLabel:(NSString*)text { 
    text = [text stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]; 
    return text; 
} 

-(void)convertHTMLEncoding 
{
    self.text = [self.text gtm_stringByUnescapingFromHTML];
} 

@end
