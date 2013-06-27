//
//  CloudUtils.m
//  eXo Platform
//
//  Created by vietnq on 6/17/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "CloudUtils.h"
#import "defines.h"
@implementation CloudUtils

// check if a given mail is in correct format

+ (BOOL)checkEmailFormat:(NSString *)mail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]{2,}\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:mail];
}


+ (NSString *)usernameByEmail:(NSString *)email
{
    return [email substringToIndex:[email rangeOfString:@"@"].location];
}

+ (NSString *)serverUrlByTenant:(NSString *)tenantName
{
    return  [NSString stringWithFormat:@"http://%@.%@",tenantName, EXO_CLOUD_HOST];
}

@end
