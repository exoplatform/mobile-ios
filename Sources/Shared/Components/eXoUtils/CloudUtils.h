//
//  CloudUtils.h
//  eXo Platform
//
//  Created by vietnq on 6/17/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudUtils : NSObject
+(BOOL) checkEmailFormat:(NSString *)mail;
+(NSString *)usernameByEmail:(NSString *)email;
+ (NSString *)serverUrlByTenant:(NSString *)tenantName;
+ (NSString *)correctServerUrl:(NSString *)inputtedUrl;
+ (BOOL)nameContainSpecialCharacter:(NSString*)str inSet:(NSString *)chars;
+ (NSString *)tenantFromServerUrl:(NSString *)serverUrl;
@end
