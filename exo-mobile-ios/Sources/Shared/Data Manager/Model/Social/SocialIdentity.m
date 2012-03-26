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


- (void)dealloc {
    [_identity release];
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%@",_identity];
}

@end
