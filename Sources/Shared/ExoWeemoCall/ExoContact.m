//
//  ExoContact.m
//  eXo Platform
//
//  Created by vietnq on 10/8/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "ExoContact.h"

@implementation ExoContact
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

- (NSString *)avatarURL
{
    
    NSString *path = [NSString stringWithFormat:@"rest/jcr/repository/social/production/soc:providers/soc:organization/soc:%@/soc:profile/soc:avatar", self.uid];
    
    return [NSString stringWithFormat:@"%@/%@", SELECTED_DOMAIN, path];
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
