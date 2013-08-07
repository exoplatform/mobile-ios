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

//add http(s):// and remove www in server url
//the correct form of an exo intranet url is: http(s)://int.exoplatform.org for example
+ (NSString *)correctServerUrl:(NSString *)inputtedUrl
{
    NSString *correctUrl = inputtedUrl;
    
    int httpInd = [inputtedUrl rangeOfString:@"http"].location;
    
    if(httpInd == NSNotFound || httpInd > 0) {
        correctUrl = [NSString stringWithFormat:@"http://%@", inputtedUrl];
    }
    
    int httpwwwInd = [correctUrl rangeOfString:@"http://www."].location;
    int httpswwwInd = [correctUrl rangeOfString:@"https://www."].location;
    
    if(httpwwwInd == 0) {
        correctUrl = [NSString stringWithFormat:@"http://%@", [correctUrl substringFromIndex:[@"http://www." length]]];
    }
    
    if(httpswwwInd == 0) {
        correctUrl = [NSString stringWithFormat:@"https://%@", [correctUrl substringFromIndex:[@"https://www." length]]];

    }
    
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    if ([urlTest evaluateWithObject:correctUrl]) {
        return correctUrl;
    }
    return nil;
}
@end
