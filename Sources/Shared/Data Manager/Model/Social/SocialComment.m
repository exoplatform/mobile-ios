//
//  SocialComment.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 15/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialComment.h"


@implementation SocialComment

@synthesize text = _text;
@synthesize identityId = _identityId; 
@synthesize createdAt = _createdAt;
@synthesize postedTime = _postedTime;

+ (NSDictionary*)elementToPropertyMappings {
	return [NSDictionary dictionaryWithObjectsAndKeys:
            @"createdAt",@"createdAt",
            @"text",@"text",
            @"postedTime",@"postedTime",
            nil];
}


+ (NSDictionary*)elementToRelationshipMappings {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"identityId", @"identityId",
            nil];
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"-%@, %@, %@, %@-",_text,_identityId,_createdAt,_postedTime];
}


@end
