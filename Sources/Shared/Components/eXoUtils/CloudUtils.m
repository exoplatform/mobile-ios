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

//returns a correct server url for ex: http://int.exoplatform.org
//return nil if the url is not well formed
+ (NSString *)correctServerUrl:(NSString *)inputtedUrl
{
    if([inputtedUrl length] == 0) {
        return nil;
    }
    //url can't contain some special characters
    //url can't end with a '.' for ex: abc.
    //url can't contain a sequence of more than 1 '.' for ex: abc...
    if(([self nameContainSpecialCharacter:inputtedUrl inSet:@"&<>\"'!;\\|(){}[],*%"])
       || ([inputtedUrl rangeOfString:@"."].location == [inputtedUrl length] - 1)
       || ([inputtedUrl rangeOfString:@".."].location != NSNotFound)) {
        return nil;
    }
    
    NSString *correctUrl = inputtedUrl;
    
    //add the prefix
    if (![[inputtedUrl lowercaseString] hasPrefix:@"http://"] &&
        ![[inputtedUrl lowercaseString] hasPrefix:@"https://"]) {
        correctUrl = [NSString stringWithFormat:@"http://%@", correctUrl];
    }
    
    NSURL* tmpUrl = [NSURL URLWithString:correctUrl];
    
    if(tmpUrl && tmpUrl.scheme && tmpUrl.host) {
        return correctUrl;
    }
    return nil;
}

+ (BOOL)nameContainSpecialCharacter:(NSString*)str inSet:(NSString *)chars {
    
    NSCharacterSet *invalidCharSet = [NSCharacterSet characterSetWithCharactersInString:chars];
    NSRange range = [str rangeOfCharacterFromSet:invalidCharSet];
    return (range.length > 0);
    
}

//gets the tenant name from server url, returns nil if not exist
//the cloud tenant is in form: http://abc.exoplatform.net
//so if the url contains cloud host (exoplatform.net), returns 'abc' as tenant name
+ (NSString *)tenantFromServerUrl:(NSString *)serverUrl
{
    NSRange range1 = [serverUrl rangeOfString:EXO_CLOUD_HOST];
    NSRange range2 = [serverUrl rangeOfString:@"http://"];
    
    if(range1.location == NSNotFound || range2.location == NSNotFound) {
        return nil;
    }
    
    NSRange range = NSMakeRange([@"http://" length], range1.location - [@"http://" length] - 1);
    return [serverUrl substringWithRange:range];
}
@end
