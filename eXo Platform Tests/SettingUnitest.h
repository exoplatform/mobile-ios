//
//  SettingUnitest.h
//  eXo Platform
//
//  Created by Mai Gia Thanh Xuyen on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ApplicationPreferencesManager.h"

@interface SettingUnitest : NSObject {
    ApplicationPreferencesManager *serverManager;
}

- (NSString*)parseURL:(NSString*)url;

- (NSArray *)loadSystemConfiguration;
- (NSArray *)loadDeletedSystemConfiguration;
- (NSArray *)loadUserConfiguration;
- (NSArray *)getServerList;

- (BOOL)addNewServer:(NSString*)serverName URL:(NSString*)urlStr;
//- (BOOL)editServer:(NSString*)nameOld urlOld:(NSString*)urlOld nameNew:(NSString*)nameNew urlNew:(NSString*)urlNew;
- (BOOL)editServer:(NSString*)nameNew urlNew:(NSString*)urlNew;
- (BOOL)deleteServer;

@end
