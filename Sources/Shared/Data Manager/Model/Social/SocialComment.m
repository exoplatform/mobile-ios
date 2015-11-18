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
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


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
    NSString * htmlString = self.text;
/*    NSError *error = nil;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    
    [detector enumerateMatchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (!self.linkURLs){
            self.linkURLs = [[NSMutableArray alloc] init];
        }        
        [self.linkURLs addObject:result.URL.absoluteString];

    }];
*/
   NSRange range;
////    NSString * htmlString = self.text;
//    
//    range = [htmlString rangeOfString:@"<a[^>]+href=\"" options:NSRegularExpressionSearch];
//    while (range.location!= NSNotFound){
//        htmlString = [htmlString substringFromIndex:(range.location+range.length)];
//        NSString * ahefTag = [htmlString substringToIndex:[htmlString rangeOfString:@"\""].location];
//        
//        if (ahefTag && ahefTag.length>0){
//            if (!self.linkURLs){
//                self.linkURLs = [[NSMutableArray alloc] init];
//            }
//            NSString * absoluteHref = [self absolutePathFromStringURL:ahefTag];
//            self.text = [self.text stringByReplacingOccurrencesOfString:ahefTag withString:absoluteHref];
//            NSURL * urlTest = [NSURL URLWithString:absoluteHref];
//            if (urlTest){
//                [self.linkURLs addObject:absoluteHref];
//            }
//        }
//        range = [htmlString rangeOfString:@"<a[^>]+href=\"" options:NSRegularExpressionSearch];
//    }
    htmlString = self.text;
    range = [htmlString rangeOfString:@"<img[^>]+src=\"" options:NSRegularExpressionSearch];
    if (range.location!= NSNotFound){
        htmlString = [htmlString substringFromIndex:(range.location+range.length)];
        NSString * imgTag = [htmlString substringToIndex:[htmlString rangeOfString:@"\""].location];
        if (imgTag && imgTag.length>0){
            if (!self.imageURLs){
                self.imageURLs = [[NSMutableArray alloc] init];
            }
            NSString * absoluteImgSrc = [self absolutePathFromStringURL:imgTag];
            self.text = [self.text stringByReplacingOccurrencesOfString:imgTag withString:absoluteImgSrc];
            NSURL * urlTest = [NSURL URLWithString:absoluteImgSrc];
            if (urlTest){
                [self.imageURLs addObject:absoluteImgSrc];
            }
        }
        range = [htmlString rangeOfString:@"<img[^>]+src=\"" options:NSRegularExpressionSearch];
    }
    
    
    self.message = [self plainTextFormHTML:self.text];
    self.cellHeight = 0;
}

-(NSAttributedString *) plainTextFormHTML:(NSString *) htmlString {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.3")){
        
        NSString * string = htmlString;
        NSData *HTMLData = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithData:HTMLData options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:NULL error:NULL];

        [attrString beginEditing];
        [attrString enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attrString.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
            if (value) {
                UIFont *oldFont = (UIFont *)value;
                /*----- Remove old font attribute -----*/
                [attrString removeAttribute:NSFontAttributeName range:range];
                //replace your font with new.
                /*----- Add new font attribute -----*/
                if ([oldFont.fontName isEqualToString:@"TimesNewRomanPSMT"])
                    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
                else if([oldFont.fontName isEqualToString:@"TimesNewRomanPS-BoldMT"])
                    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15 weight:1.5] range:range];
                else if([oldFont.fontName isEqualToString:@"TimesNewRomanPS-ItalicMT"])
                    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14 weight:0.5] range:range];
                else if([oldFont.fontName isEqualToString:@"TimesNewRomanPS-BoldItalicMT"])
                    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
                else
                    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
            }
        }];
        [attrString enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, attrString.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
            if (value) {
                if (!self.linkURLs){
                    self.linkURLs = [[NSMutableArray alloc] init];
                }
                NSURL * url = (NSURL*) value;
                if ([url.absoluteString rangeOfString:@"applewebdata"].location == 0){
                    url = [NSURL URLWithString:[ApplicationPreferencesManager.sharedInstance.selectedDomain stringByAppendingString:url.relativePath]];
                }
                [self.linkURLs addObject:[self absolutePathFromStringURL:url.absoluteString]];
                [attrString addAttribute:NSLinkAttributeName value:url range:range];
            }

        }];
        [attrString endEditing];
        
        return attrString;
    }
    NSString * string = [htmlString stringByConvertingHTMLToPlainText];
    return [[NSAttributedString alloc] initWithString:string];
    
}

-(NSString *) toHTML {
    
    NSString *htmlStr = [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:30pt;word-wrap: break-word;} img { width:100%%; height:auto;} div{margin-top : 60px; width:100%%; height:auto; align:center;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><body><div>%@</div></body></html>",self.text ? self.text : @""];
    return htmlStr;
}

-(NSString *) absolutePathFromStringURL:(NSString *) stringURL {
    NSString * s = stringURL;
    NSRange rangeProtocol = [stringURL rangeOfString:@"http"];
    if (rangeProtocol.location == NSNotFound || rangeProtocol.location != 0) {
        s = [@"http://" stringByAppendingString:stringURL];
    }
    NSURL * urlTest = [NSURL URLWithString:s];
    if (!urlTest || !urlTest.host || urlTest.host.length ==0) {
        return [ApplicationPreferencesManager.sharedInstance.selectedDomain stringByAppendingString:stringURL];
    }
    return s;
}

@end
