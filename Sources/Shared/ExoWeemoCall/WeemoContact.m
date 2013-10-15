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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init])) {
        self.uid = [aDecoder decodeObjectForKey:@"UID"];
        self.displayName = [aDecoder decodeObjectForKey:@"DisplayName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.uid forKey:@"UID"];
    [aCoder encodeObject:self.displayName forKey:@"DisplayName"];
}

- (void)dealloc
{
    [super dealloc];
    [_uid release];
    [_displayName release];
}

@end
