//
//  CallHistory.m
//  eXo Platform
//
//  Created by vietnq on 10/9/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "CallHistory.h"

@implementation CallHistory
@synthesize date = _date;
@synthesize caller = _caller;
@synthesize direction = _direction;


-(void)dealloc
{
    [super dealloc];
    [_date release];
    [_caller release];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init])) {
        self.caller = [aDecoder decodeObjectForKey:@"Caller"];
        self.direction = [aDecoder decodeObjectForKey:@"CallDirection"];
        self.date = [aDecoder decodeObjectForKey:@"Date"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.caller forKey:@"Caller"];
    [aCoder encodeObject:self.direction forKey:@"CallDirection"];
    [aCoder encodeObject:self.date forKey:@"Date"];
}

@end
