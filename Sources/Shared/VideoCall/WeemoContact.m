//
//  WeemoContact.m
//  eXo Platform
//
//  Created by vietnq on 10/8/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "WeemoContact.h"

@implementation WeemoContact
@synthesize uid = _uid;
@synthesize displayName = _displayName;

- (id)initWithUid:(NSString *)uid andDisplayName:(NSString *)displayName
{
    if((self = [super init])) {
        self.uid = uid;
        self.displayName = displayName;
    }
    return self;
}

- (void)dealloc
{
    [_uid release];
    [_displayName release];
}

@end
