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
+(NSString *)serverUrlByEmail:(NSString *)email;
+(NSString *)usernameByEmail:(NSString *)email;
+(NSString *)tenantByEmail:(NSString *)email;
@end
