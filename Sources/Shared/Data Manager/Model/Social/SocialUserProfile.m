//
//  SocialUserProfile.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 13/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialUserProfile.h"


//{"id":"e4f574dec0a80126368b5c3e4cc727b4","remoteId":"demo","providerId":"organization","profile":{"avatarUrl":null,"fullName":"Jack Miller"}}
@implementation SocialUserProfile

@synthesize identity=_identity;
@synthesize remoteId=_remoteId;
@synthesize providerId=_providerId;
@synthesize avatarUrl=_avatarUrl;
@synthesize fullName=_fullName;


+ (NSDictionary*)elementToPropertyMappings {
	return [NSDictionary dictionaryWithObjectsAndKeys:
            @"identity",@"id",
            @"remoteId",@"remoteId",
            @"providerId",@"providerId",
            @"avatarUrl",@"profile.avatarUrl",
            @"fullName",@"profile.fullName",
			nil];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"Social User Profile : %@, %@, %@, %@, %@",_identity,_remoteId,_providerId,_avatarUrl,_fullName];
}

- (void)dealloc {
    [_identity release];
    [_remoteId release];
    [_providerId release];
    [_avatarUrl release];
    [_fullName release];
    [super dealloc];
}

@end
