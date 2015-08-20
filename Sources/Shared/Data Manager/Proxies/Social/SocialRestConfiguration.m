//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
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
    NSString *domainWithoutHttp = [(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_DOMAIN] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    domainWithoutHttp = [domainWithoutHttp stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    //TODO SLM
    //REmove this line and provide a true Server URL analyzer
    domainWithoutHttp = [domainWithoutHttp stringByReplacingOccurrencesOfString:@"/portal" withString:@""];
}

- (NSString *)createBaseUrl {
    return [NSString stringWithFormat:@"%@/%@/private/", self.domainName, self.restContextName];
}

- (instancetype) init
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
