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
    _domainName = [(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_DOMAIN] copy];
    _restContextName = [kRestContextName copy];
    _restVersion = [kRestVersion copy];
    _portalContainerName = [kPortalContainerName copy];
    _username = [(NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_USERNAME] copy];
    _password = [(NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_PASSWORD] copy];
    
    //TODO SLM
    //REmove this line and provide a true Server URL analyzer
    NSString *domainWithoutHttp = [(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_DOMAIN] stringByReplacingOccurrencesOfString:@"http://" 
                                                                                                                                                   withString:@""];
    
    //TODO SLM
    //REmove this line and provide a true Server URL analyzer
    domainWithoutHttp = [domainWithoutHttp stringByReplacingOccurrencesOfString:@"/portal" withString:@""];
    [self initRKOjectManagerIfNotExist];
}

- (NSString *)createBaseUrl {
    return [NSString stringWithFormat:@"%@/%@/private/", self.domainName, self.restContextName];
}

- (void)initRKOjectManagerIfNotExist {
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseUrl]];
    manager.client.username = self.username;
    manager.client.password = self.password;
    manager.client.forceBasicAuthentication = YES;
    [RKObjectManager setSharedManager:manager];
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
