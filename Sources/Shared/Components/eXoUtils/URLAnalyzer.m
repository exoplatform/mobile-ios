//
//  URLAnalyzer.m
//  eXo Platform
//
//  Created by Mai Gia on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "URLAnalyzer.h"
#import "defines.h"

@implementation URLAnalyzer


+ (NSString *)parserURL:(NSString *)urlStr
{
    //Check if the given url is null
    if(urlStr == nil || [urlStr length] == 0)
        return nil;
    
    //Remove protocol prefix: "http://", "https://" 
    NSRange rangeOfProtocol;
    
    rangeOfProtocol = [urlStr rangeOfString:HTTP_PROTOCOL];
    if(rangeOfProtocol.location == 0)
        urlStr = [urlStr substringFromIndex:rangeOfProtocol.length];
    
    rangeOfProtocol = [urlStr rangeOfString:HTTPS_PROTOCOL];
    if(rangeOfProtocol.location == 0)
        urlStr = [urlStr substringFromIndex:rangeOfProtocol.length];
    
    //Remove all redundant "/" at prefix
    while([[urlStr substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"/"])
    {
        if([urlStr length] > 1)
            urlStr = [urlStr substringFromIndex:1];
    }
    
    //Add protocol
    urlStr = [NSString stringWithFormat:@"%@%@", HTTP_PROTOCOL, urlStr];
    
    NSURL *uri = [NSURL URLWithString:urlStr];
    urlStr = [NSString stringWithFormat:@"%@%@", HTTP_PROTOCOL, [uri host]];

    //Add port
    int port = [[uri port] intValue]; 
    if(port > 0)
        urlStr = [urlStr stringByAppendingFormat:@":%d", port];
    
    return urlStr;
}


@end
