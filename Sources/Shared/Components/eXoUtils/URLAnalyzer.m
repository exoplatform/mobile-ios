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
    if(urlStr == nil || [urlStr length] == 0)
        return nil;
    
    NSRange rangeOfProtocol;
    
    rangeOfProtocol = [urlStr rangeOfString:HTTP_PROTOCOL];
    if(rangeOfProtocol.location == 0)
        urlStr = [urlStr substringFromIndex:rangeOfProtocol.length];
    
    rangeOfProtocol = [urlStr rangeOfString:HTTPS_PROTOCOL];
    if(rangeOfProtocol.location == 0)
        urlStr = [urlStr substringFromIndex:rangeOfProtocol.length];
    
    while([[urlStr substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"/"])
    {
        if([urlStr length] > 1)
            urlStr = [urlStr substringFromIndex:1];
    }
    
    urlStr = [NSString stringWithFormat:@"%@%@", HTTP_PROTOCOL, urlStr];
    
    NSURL *uri = [NSURL URLWithString:urlStr];
    urlStr = [NSString stringWithFormat:@"%@%@", HTTP_PROTOCOL, [uri host]];

    int port = [[uri port] intValue]; 
    if(port > 0)
        urlStr = [urlStr stringByAppendingFormat:@":%d", port];
    
    return urlStr;
}


@end
