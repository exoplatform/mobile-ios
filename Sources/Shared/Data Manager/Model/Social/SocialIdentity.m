//
//  SocialIdentity.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 06/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialIdentity.h"


@implementation SocialIdentity

@synthesize identity = _identity;

#pragma mark RKObjectMappable methods

+ (NSDictionary*)elementToPropertyMappings {
	return [NSDictionary dictionaryWithObjectsAndKeys:
            @"identity",@"id",
			nil];
}

- (void)dealloc {
    [_identity release];
    [super dealloc];
}

@end
