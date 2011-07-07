//
//  RKSocialIdentity.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 06/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RKSocialIdentity.h"


@implementation RKSocialIdentity

@synthesize identity = _identity;

#pragma mark RKObjectMappable methods

+ (NSDictionary*)elementToPropertyMappings {
	return [NSDictionary dictionaryWithKeysAndObjects:
			@"id", @"identity",
			nil];
}

- (void)dealloc {
    [_identity release];
    [super dealloc];
}

@end
