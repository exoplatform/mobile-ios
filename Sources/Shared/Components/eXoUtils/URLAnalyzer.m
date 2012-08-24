//
//  URLAnalyzer.m
//  eXo Platform
//
//  Created by Mai Gia on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "URLAnalyzer.h"

@implementation URLAnalyzer


+ (NSString *)parserURL:(NSString *)urlStr
{
    //Put in lowercase to make checks easier
    urlStr = [urlStr lowercaseString];
    
    //Check if the given url is null
    if(urlStr == nil || [urlStr length] == 0)
        return nil;
    
    //Remove protocol prefix: "http://", "https://" 
    NSRange rangeOfProtocol;
    
    BOOL isHTTPSURL = NO;
    
    rangeOfProtocol = [urlStr rangeOfString:HTTP_PROTOCOL];
    if(rangeOfProtocol.location == 0)
        urlStr = [urlStr substringFromIndex:rangeOfProtocol.length];
    
    rangeOfProtocol = [urlStr rangeOfString:HTTPS_PROTOCOL];
    if(rangeOfProtocol.location == 0) {
        urlStr = [urlStr substringFromIndex:rangeOfProtocol.length];
        isHTTPSURL = YES;
    }
    //Remove all redundant "/" at prefix
    while([[urlStr substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"/"])
    {
        if([urlStr length] > 1)
            urlStr = [urlStr substringFromIndex:1];
    }
    
    
    //Add protocol
    NSURL *uri;
    
    if (!(isHTTPSURL)) {
        urlStr = [NSString stringWithFormat:@"%@%@", HTTP_PROTOCOL, urlStr];
        uri = [NSURL URLWithString:urlStr];
        if(uri == nil)
            urlStr = nil;
        else
            urlStr = [NSString stringWithFormat:@"%@%@", HTTP_PROTOCOL, [uri host]];
    } else {
        urlStr = [NSString stringWithFormat:@"%@%@", HTTPS_PROTOCOL, urlStr];
        uri = [NSURL URLWithString:urlStr];
        if(uri == nil)
            urlStr = nil;
        else
            urlStr = [NSString stringWithFormat:@"%@%@", HTTPS_PROTOCOL, [uri host]];
    }

    //Add port
    int port = [[uri port] intValue]; 
    if(port > 0)
        urlStr = [urlStr stringByAppendingFormat:@":%d", port];
    
    return urlStr;
}

+ (NSString *)enCodeURL:(NSString *)url {
    
    NSMutableString *escaped = [NSMutableString stringWithString:url];  
    
    [escaped replaceOccurrencesOfString:@"$" withString:@"%24" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"," withString:@"%2C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//    [escaped replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//    [escaped replaceOccurrencesOfString:@":" withString:@"%3A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@";" withString:@"%3B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"\t" withString:@"%09" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"#" withString:@"%23" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"<" withString:@"%3C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@">" withString:@"%3E" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"\"" withString:@"%22" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"\n" withString:@"%0A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];  
    
    return escaped;
}

+ (NSString *)decodeURL:(NSString *)url {
    
    NSMutableString *escaped = [NSMutableString stringWithString:url];  
    
    [escaped replaceOccurrencesOfString:@"%24" withString:@"$" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"%26" withString:@"&" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"%2B" withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"%2C" withString:@"," options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"%3B" withString:@";" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"%3D" withString:@"=" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"%3F" withString:@"?" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"%40" withString:@"@" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"%20" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"%09" withString:@"\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"%23" withString:@"#" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"%3C" withString:@"<" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"%3E" withString:@">" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"%22" withString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"%0A" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];  
    
    return escaped;

    
}

@end
