//
//  SocialVersion.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialVersion.h"

@implementation SocialVersion

@synthesize version = _version;


- (void)dealloc {
    [_version release];
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%@",_version];
}

@end
