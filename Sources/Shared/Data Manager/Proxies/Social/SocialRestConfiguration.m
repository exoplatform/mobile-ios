//
//  SocialRestConfiguration.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 07/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialRestConfiguration.h"
#import "defines.h"
#import <RestKit/RestKit.h>
#import "ApplicationPreferencesManager.h"
#import "UserPreferencesManager.h"

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


- (void)updateDatas {
    self.domainName = [[ApplicationPreferencesManager sharedInstance] selectedDomain];
    self.restContextName = kRestContextName;
    self.restVersion = kRestVersion;
    self.portalContainerName = kPortalContainerName;
    self.username = [[UserPreferencesManager sharedInstance] username];
    self.password = [[UserPreferencesManager sharedInstance] password];
    
    //TODO SLM
    //REmove this line and provide a true Server URL analyzer
    NSString *domainWithoutHttp = [(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_DOMAIN] stringByReplacingOccurrencesOfString:@"http://" 
                                                                                                                                                   withString:@""];
    
    //TODO SLM
    //REmove this line and provide a true Server URL analyzer
    domainWithoutHttp = [domainWithoutHttp stringByReplacingOccurrencesOfString:@"/portal" withString:@""];
}

- (NSString *)createBaseUrl {
    return [NSString stringWithFormat:@"%@/%@/private/", self.domainName, self.restContextName];
}

- (id) init
{
    if ((self = [super init])) 
    {
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
