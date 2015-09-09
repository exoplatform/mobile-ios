//
// Copyright (C) 2003-2015 eXo Platform SAS.
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


#import "PostItem.h"

@implementation PostItem

-(id) init {
    self = [super init];
    if (self){
        self.uploadStatus = eXoItemStatusReadyToUpload;
        self.isImageItem = NO;
    }
    return self;
}


/*
 Make the file upload name on server side
 fileAttacheName = mobile + [datetime string] + [converted filename]
 converted rules:
 - No upper case
 - No special characters
 - No space or -,_
 */
#define REGEXP_SEPARATOR @"[_: ]"
#define REGEXP_2TIME_SPEPARATOR @"-{2,}"
#define REGEXP_REMOVE_CHAR @"[{}()!@#$%^&|;\"~`'<>?\\/,+=*.ˆ\\[\\]]"

-(NSString *) generateUploadFileName {
    NSData * tmp = [self.fileExtension dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString * name = [[NSString alloc] initWithData:tmp encoding:NSASCIIStringEncoding];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-hh-mm-ss"];
    NSString * fileAttachName = [dateFormatter stringFromDate:[NSDate date]];
    NSString * extension;
    NSRange range;
    range = [name rangeOfString:@"." options:NSBackwardsSearch];
    if (range.location!=NSNotFound){
        extension = [name substringFromIndex:range.location];
        name = [name substringToIndex:range.location];
    }
    while ((range = [name rangeOfString:REGEXP_REMOVE_CHAR options:NSRegularExpressionSearch]).location != NSNotFound) {
        name = [name stringByReplacingCharactersInRange:range withString:@""];
    }
    while ((range = [name rangeOfString:REGEXP_SEPARATOR options:NSRegularExpressionSearch]).location != NSNotFound) {
        name = [name stringByReplacingCharactersInRange:range withString:@"-"];
    }
    while ((range = [name rangeOfString:REGEXP_2TIME_SPEPARATOR options:NSRegularExpressionSearch]).location != NSNotFound) {
        name = [name stringByReplacingCharactersInRange:range withString:@"-"];
    }
    
    name = [name lowercaseString];
    name = [name stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    if (extension){
        fileAttachName = [NSString stringWithFormat:@"mobile-%@-%@%@",fileAttachName,name,extension];
    } else {
        fileAttachName = [NSString stringWithFormat:@"mobile-%@.%@",fileAttachName,name];
    }
    return fileAttachName;
}


#pragma mark - link activity

-(void) searchForImageInURL {
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:self.url
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                NSString * pagesource = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSRange range;
                
                range = [pagesource rangeOfString:@"<title>"];
                NSRange endTagRange  = [pagesource rangeOfString:@"</title>"];
                if (range.location!= NSNotFound && endTagRange.location != NSNotFound && endTagRange.location > range.location + range.length){
                        NSString * title = [pagesource substringWithRange:NSMakeRange(range.location+range.length, endTagRange.location-range.location)];
                    if (title.length >0) {
                        self.pageWebTitle = title;
                    }
                }

                range = [pagesource rangeOfString:@"=\"container\""];
                if (range.location== NSNotFound){
                    range = [pagesource rangeOfString:@"=\"content\""];
                }
                if (range.location== NSNotFound){
                    range = [pagesource rangeOfString:@"=\"article-page\""];
                }
                if (range.location== NSNotFound){
                    range = [pagesource rangeOfString:@"=\"article\""];
                }
                if (range.location== NSNotFound){
                    range = [pagesource rangeOfString:@"<article>"];
                }
                //entry-summary exo platform
                if (range.location== NSNotFound){
                    range = [pagesource rangeOfString:@"=\"entry-summary\""];
                }
                
                if (range.location== NSNotFound){
                    range = [pagesource rangeOfString:@"container"];
                }
                
                //
                if (range.location != NSNotFound){
                    NSString * contentPage = [pagesource substringFromIndex:range.location];
                    range = [contentPage rangeOfString:@"<img[^>]+src=\"http" options:NSRegularExpressionSearch];
                    if (range.location!= NSNotFound){
                        NSString * imgTag = [contentPage substringFromIndex:(range.location+range.length-4)];
                        self.imageURLFromLink = [imgTag substringToIndex:[imgTag rangeOfString:@"\""].location];
                    }
                }
                
            }] resume];
    
}

@end
