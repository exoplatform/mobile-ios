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
        serverManager = [ServerPreferencesManager sharedInstance];
        
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
    
    return [serverManager getServerList];
}

//Add, edit, delete server
- (BOOL)addNewServer:(NSString*)serverName URL:(NSString*)urlStr {
    
    //Create the new server
    ServerObj* serverObj = [[ServerObj alloc] init];
    serverObj._strServerName = serverName;
    serverObj._strServerUrl = [self parseURL:urlStr];    
    serverObj._bSystemServer = NO;
    
    //Add the server in configuration
    NSMutableArray* arrAddedServer = (NSMutableArray*)[self loadUserConfiguration];
    [arrAddedServer addObject:serverObj];
    return [serverManager writeUserConfiguration:arrAddedServer];

}

- (BOOL)editServer:(NSString*)nameNew urlNew:(NSString*)urlNew {
    
    ServerObj* serverObj = [[ServerObj alloc] init];
    serverObj._strServerName = urlNew;
    serverObj._strServerUrl = [self parseURL:urlNew];

    NSMutableArray* _arrServerList = (NSMutableArray*)[self loadSystemConfiguration];
    [_arrServerList replaceObjectAtIndex:0 withObject:serverObj];
    
    [serverManager writeSystemConfiguration:_arrServerList];
    
    return YES;
}

- (BOOL)deleteServer {

    NSMutableArray* _arrServerList = (NSMutableArray*)[self loadSystemConfiguration];
    [_arrServerList removeObjectAtIndex:0];
    
    [serverManager writeSystemConfiguration:_arrServerList];
    
    return YES;
}


@end
