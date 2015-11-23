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

#import "SocialComment.h"
#import "NSDate+Formatting.h"
#import "GTMNSString+HTML.h"
#import "NSString+HTML.h"
#import "ApplicationPreferencesManager.h"

@implementation SocialComment

@synthesize text = _text;
@synthesize identityId = _identityId; 
@synthesize createdAt = _createdAt;
@synthesize postedTime = _postedTime;
@synthesize userProfile = _userProfile;

@synthesize postedTimeInWords = _postedTimeInWords;

- (NSString *)description
{
    return [NSString stringWithFormat:@"-%@, %@, %@, %@",_text?_text:@"",_identityId?_identityId:@"",_createdAt?_createdAt:@"", [_userProfile description]];
}

- (void)convertToPostedTimeInWords
{
    self.postedTimeInWords = [[NSDate dateWithTimeIntervalSince1970:self.postedTime/1000] distanceOfTimeInWords];
}


- (NSString*)fixupTextForStyledTextLabel:(NSString*)text { 
    text = [text stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]; 
    return text; 
} 

-(void)convertHTMLEncoding 
{
    self.text = [self.text gtm_stringByUnescapingFromHTML];
} 

-(void) parseTextHTML {
    NSRange range;
    self.message = [self.text stringByConvertingHTMLToPlainText];
    
    // Detect links
    NSString * htmlString = self.text;
    range = [htmlString rangeOfString:@"<a[^>]+href=\"" options:NSRegularExpressionSearch];
    while (range.location!= NSNotFound){
        htmlString = [htmlString substringFromIndex:(range.location+range.length)];
        NSString * ahefTag = [htmlString substringToIndex:[htmlString rangeOfString:@"\""].location];
        
        if (ahefTag && ahefTag.length>0){
            if (!self.linkURLs){
                self.linkURLs = [[NSMutableArray alloc] init];
            }
            NSString * absoluteURL = [self absoluteURLFromStringURL:ahefTag];
            if (absoluteURL) {
                self.text = [self.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"href=\"%@",ahefTag] withString:[NSString stringWithFormat:@"src=\"%@",absoluteURL]];
                [self.linkURLs addObject:[self absoluteURLFromStringURL:absoluteURL]];
            }

        }
        range = [htmlString rangeOfString:@"<a[^>]+href=\"" options:NSRegularExpressionSearch];
    }

    // Detect images
    htmlString = self.text;
    range = [htmlString rangeOfString:@"<img[^>]+src=\"" options:NSRegularExpressionSearch];
    while (range.location!= NSNotFound){
        htmlString = [htmlString substringFromIndex:(range.location+range.length)];
        NSString * imgTag = [htmlString substringToIndex:[htmlString rangeOfString:@"\""].location];
        if (imgTag && imgTag.length>0){
            if (!self.imageURLs){
                self.imageURLs = [[NSMutableArray alloc] init];
            }
            NSString * absoluteURL = [self absoluteURLFromStringURL:imgTag];
            if (absoluteURL) {
                self.text = [self.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"src=\"%@",imgTag] withString:[NSString stringWithFormat:@"src=\"%@",absoluteURL]];
                [self.imageURLs addObject:absoluteURL];
            }
        }
        range = [htmlString rangeOfString:@"<img[^>]+src=\"" options:NSRegularExpressionSearch];
    }
    
    self.cellHeight = 0;
}

/*!
 * Finds and returns an absolute URL from the given string, provided that
 * it contains an absolute URL, or an URL without protocol, or a relative URL.
 *
 * If multiple URLs are present in the given string, only the 1st one is returned.
 */
- (NSString*) absoluteURLFromStringURL:(NSString*) stringURL {
    NSURL * urlTest = nil;
    NSError * error = NULL;
    // Try to detect links in the string
    // This will match URLs whether or not they start with a protocol
    NSDataDetector * detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    NSArray *matches = [detector matchesInString:stringURL
                                         options:0
                                           range:NSMakeRange(0, [stringURL length])];
    if (matches != nil && matches.count > 0) {
        NSTextCheckingResult * match = matches[0];
        // if the detected URL didn't have a protocol, http:// was added
        return match.URL.absoluteString;
    }
    // If no URLs was detected, it's probably a relative URL
    if (urlTest == nil)
        urlTest = [NSURL URLWithString:stringURL];
    
    if (urlTest != nil && urlTest.path != nil) {
        return [ApplicationPreferencesManager.sharedInstance.selectedDomain
                stringByAppendingString:urlTest.path];
    } else {
        // no URL was detected
        return stringURL;
    }
}

-(NSString *) toHTML {

    NSString *htmlStr = [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:30pt;word-wrap: break-word;} img { width:100%%; height:auto;} div{margin-top : 60px; width:100%%; height:auto; align:center;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><body><div>%@</div></body></html>",self.text ? self.text : @""];
    return htmlStr;
}
@end
