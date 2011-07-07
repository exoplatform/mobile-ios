//
//  SocialRestConfiguration.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 07/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialRestConfiguration.h"
#import "defines.h"




@implementation SocialRestConfiguration

@synthesize domainName = _domainName;
@synthesize restVersion =  _restVersion;
@synthesize restContextName = _restContextName;
@synthesize portalContainerName = _portalContainerName;
@synthesize username = _username;
@synthesize password = _password;



#pragma Object Management

+ (SocialRestConfiguration*)sharedInstance
{
	static SocialRestConfiguration *sharedInstance;
	@synchronized(self)
	{
		if(!sharedInstance)
		{
			sharedInstance = [[SocialRestConfiguration alloc] init];
		}
		return sharedInstance;
	}
	return sharedInstance;
}


- (id) init
{
	self = [super init];
    if (self) 
    {
        _domainName = [[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_DOMAIN];
        _restContextName = kRestContextName;
        _restVersion = kRestVersion;
        _portalContainerName = kPortalContainerName;
        _username = [[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_USERNAME];
        _password = [[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_PASSWORD];

    }	
	return self;
}

- (void) dealloc
{
	[_domainName release];
    [_portalContainerName release];
    [_restContextName release];
    [_restVersion release];
    [_username release];
    [_password release];
	[super dealloc];
}




@end
