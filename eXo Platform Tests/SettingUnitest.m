//
//  SettingUnitest.m
//  eXo Platform
//
//  Created by Mai Gia Thanh Xuyen on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingUnitest.h"
#import "URLAnalyzer.h"

@implementation SettingUnitest

- (id) init
{
    if ((self = [super init])) 
    {
        serverManager = [ApplicationPreferencesManager sharedInstance];
        
    }	
	return self;
}


- (NSString*)parseURL:(NSString*)url {
    
      return [URLAnalyzer parserURL:[url stringByTrimmingCharactersInSet:
                                     [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

//Get server list
- (NSArray *)loadSystemConfiguration {
    return [serverManager loadSystemConfiguration];    
}

- (NSArray *)loadDeletedSystemConfiguration {
    return [serverManager loadDeletedSystemConfiguration];    
}

- (NSArray *)loadUserConfiguration {
    return [serverManager loadUserConfiguration];
}

- (NSArray *)getServerList {
    
    return [serverManager serverList];
}

//Add, edit, delete server
- (BOOL)addNewServer:(NSString*)serverName URL:(NSString*)urlStr {
    
    return [serverManager addEditServerWithServerName:serverName andServerUrl:urlStr withUsername:@"" andPassword:@"" atIndex:-1];
}

- (BOOL)editServer:(NSString*)nameNew urlNew:(NSString*)urlNew {
    
    return [serverManager addEditServerWithServerName:nameNew andServerUrl:urlNew withUsername:@"" andPassword:@"" atIndex:0];
}

- (BOOL)deleteServer {

    return [serverManager deleteServerObjAtIndex:0];
}


@end
