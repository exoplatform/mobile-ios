//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import "URLAnalyzer.h"

@implementation URLAnalyzer

/*!
 * Adds necessary parts of the server URL (e.g. http://) and
 * removes the unnecessary parts (e.g. path).
 * @returns a correct server URL e.g.: http://int.exoplatform.org
 * @returns nil if the URL is not well formed
 */
+ (NSString *)parserURL:(NSString *)urlStr
{
    //Put in lowercase to make checks easier
    urlStr = [urlStr lowercaseString];
    
    //Check if the given URL is null
    if(urlStr == nil || [urlStr length] == 0)
        return nil;
    
    // Check the scheme of the given URL. Skip if it's http:// or https://
    if (![urlStr hasPrefix:HTTP_PROTOCOL] && ![urlStr hasPrefix:HTTPS_PROTOCOL]) {
        NSRange scheme = [urlStr rangeOfString:@"://"];
        // If it's not http or https but it contains the characters ://
        if (scheme.length > 0) {
        // Replace from the beginning of the URL to the end of the sequence :// with http://
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_PROTOCOL, [urlStr substringFromIndex:scheme.location+scheme.length]];
        } else {
        // Otherwise, add http:// at the beginning
            urlStr = [NSString stringWithFormat:@"%@%@", HTTP_PROTOCOL, urlStr];
        }
    }
    
    NSURL* tmpUrl = [NSURL URLWithString:urlStr];
    NSMutableString *validUrl = [NSMutableString stringWithString:@""];
    
    // Check if the url does conforms to the relevant RFCs
    if (tmpUrl == nil || tmpUrl.scheme == nil || tmpUrl.host == nil)
        return nil;
    
    // Add the scheme, it's already been checked and is either http or https
    [validUrl appendFormat:@"%@%@", tmpUrl.scheme, @"://"];
    // Check if the host contains wrong characters . & < > " ' ! ; \ | ( ) { } [ ] , * % $ # : ` + ? ~ @ _
    NSCharacterSet *invalidChars = 
            [NSCharacterSet characterSetWithCharactersInString:@"&<>\"'!;\\|(){}[],*%$#:`+?~_"];
    NSRange range = [tmpUrl.host rangeOfCharacterFromSet:invalidChars];
    BOOL containsWrongChars = range.length > 0;
    BOOL containsWrongDots = ([tmpUrl.host rangeOfString:@".."].length > 0 || [tmpUrl.host rangeOfString:@"."].location == [tmpUrl.host length] - 1 || [tmpUrl.host hasPrefix:@"."] );
    
    if (!containsWrongChars && !containsWrongDots)
        [validUrl appendString:tmpUrl.host];
    else
        return nil;
    
    // Add the port
    int port = (tmpUrl.port == nil) ? 0 : [tmpUrl.port intValue];
    if(port > 0)
        [validUrl appendFormat:@":%d",port];
    
    return validUrl;
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
