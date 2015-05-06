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

#import "SocialActivity.h"
#import "NSDate+Formatting.h"
#import "GTMNSString+HTML.h"
#import "ActivityHelper.h"

@implementation SocialActivity

@synthesize identityId = _identityId;
@synthesize activityId = _activityId;
@synthesize totalNumberOfLikes = _totalNumberOfLikes;
@synthesize totalNumberOfComments = _totalNumberOfComments;
@synthesize liked = _liked;
@synthesize postedTime = _postedTime;
@synthesize lastUpdated = _lastUpdated;
@synthesize cellHeight = _cellHeight;
@synthesize type = _type;
@synthesize activityStream = _activityStream;
@synthesize title = _title;
@synthesize body = _body;
@synthesize priority = _priority;
@synthesize createdAt = _createdAt;
@synthesize likedByIdentities = _likedByIdentities;
@synthesize titleId = _titleId;
@synthesize posterIdentity = _posterIdentity;
@synthesize posterPicture = _posterPicture;
@synthesize comments = _comments;
@synthesize postedTimeInWords = _postedTimeInWords;
@synthesize templateParams = _templateParams;
@synthesize activityType = _activityType;

- (void)dealloc {
    [_identityId release];
    [_activityId release];
    [_type release];
    [_activityStream release];
    [_title release];
    [_body release];
    [_createdAt release];
    [_likedByIdentities release];
    [_titleId release];
    [_posterIdentity release];
    [_posterPicture release];
    [_comments release];
    [_postedTimeInWords release];
    [_templateParams release];
    [super dealloc];
}

- (void)getActivityType {
    /* in plf 4, there is just activity for creating action
     * updating actions add comments to the activity.
     */
    if ([_type rangeOfString:@"ks-wiki"].length > 0) {
        _activityType = ACTIVITY_WIKI_ADD_PAGE;
        if ([[_templateParams valueForKey:@"act_key"] isEqualToString:@"update_page"]) {
            _activityType = ACTIVITY_WIKI_MODIFY_PAGE;
        }
    } else if ([_type rangeOfString:@"LINK_ACTIVITY"].length > 0) {
        _activityType = ACTIVITY_LINK;
    } else if ([_type rangeOfString:@"DOC_ACTIVITY"].length > 0) {
        _activityType = ACTIVITY_DOC;
    } else if ([_type rangeOfString:@"contents:spaces"].length > 0
               || [_type rangeOfString:@"files:spaces"].length > 0) { // in plf4, uploading file has activity type: files:spaces
        _activityType = ACTIVITY_CONTENTS_SPACE;
    } else if ([_type rangeOfString:@"ks-forum"].length > 0) {
        _activityType = ACTIVITY_FORUM_CREATE_TOPIC;
        if ([[_templateParams valueForKey:@"ActivityType"] isEqualToString:@"UpdatePost"]) {
            _activityType = ACTIVITY_FORUM_UPDATE_POST;
        } else if ([[_templateParams valueForKey:@"ActivityType"] isEqualToString:@"AddPost"]) {
            _activityType = ACTIVITY_FORUM_CREATE_POST;
        } else if ([[_templateParams valueForKey:@"ActivityType"] isEqualToString:@"UpdateTopic"]) {
            _activityType = ACTIVITY_FORUM_UPDATE_TOPIC;
        }//
    } else if ([_type rangeOfString:@"ks-answer"].length > 0) {//
        _activityType = ACTIVITY_ANSWER_ADD_QUESTION;

        if ([[_templateParams valueForKey:@"ActivityType"] isEqualToString:@"QuestionUpdate"]) {
            _activityType = ACTIVITY_ANSWER_UPDATE_QUESTION;
        } else if ([[_templateParams valueForKey:@"ActivityType"] isEqualToString:@"AnswerAdd"]) {
            _activityType = ACTIVITY_ANSWER_QUESTION;
        }//
    } else if ([_type rangeOfString:@"cs-calendar"].length > 0) {//
        if ([[_templateParams valueForKey:@"EventType"] isEqualToString:@"EventAdded"]) {
            _activityType = ACTIVITY_CALENDAR_ADD_EVENT;
        } else if ([[_templateParams valueForKey:@"EventType"] isEqualToString:@"EventUpdated"]) {
            _activityType = ACTIVITY_CALENDAR_UPDATE_EVENT;
        } else if ([[_templateParams valueForKey:@"EventType"] isEqualToString:@"TaskAdded"]) {
            _activityType = ACTIVITY_CALENDAR_ADD_TASK;
        } else if ([[_templateParams valueForKey:@"EventType"] isEqualToString:@"TaskUpdated"]) {
            _activityType = ACTIVITY_CALENDAR_UPDATE_TASK;
        }
    } else {
        _activityType = ACTIVITY_DEFAULT;
    }
    
}

- (void)convertToPostedTimeInWords {
   self.postedTimeInWords = [[NSDate dateWithTimeIntervalSince1970:self.postedTime/1000] distanceOfTimeInWords:[NSDate date]]; 
}

- (void)convertToUpdatedTimeInWords {
    self.updatedTimeInWords = [[NSDate dateWithTimeIntervalSince1970:self.lastUpdated/1000] distanceOfTimeInWords:[NSDate date]];

}
-(void) convertToAttributedMessage {
    if ([self.templateParams objectForKey:@"comment"]){
        self.attributedMessage = [self getHTMLAttributedStringFromHTML:[self.templateParams objectForKey:@"comment"]];
    } else {
        self.attributedMessage =[self getHTMLAttributedStringFromHTML:self.title];
    }
}
- (void)convertHTMLEncoding {
    self.title = [self.title gtm_stringByUnescapingFromHTML];
    self.posterPicture.message = [self.posterPicture.message gtm_stringByUnescapingFromHTML];
}

- (void)cellHeightCalculationForWidth:(CGFloat)fWidth {
    _cellHeight = [ActivityHelper getHeightForActivityCell:self forTableViewWidth:fWidth];
}

- (void)setKeyForTemplateParams:(NSString *)key value:(NSString *)value {
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self.templateParams];
    [tempDic setValue:value forKey:key];
    self.templateParams = [NSDictionary dictionaryWithDictionary:tempDic];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[title : %@], [body : %@], [identityId : %@], [comment : %@]", self.title, self.body, self.identityId, self.comments];
}


-(NSAttributedString * ) getHTMLAttributedStringFromHTML:(NSString *) html {

    NSString * string = html;
   // Analyse the <a href ..> HTML Tag to get the links
    
   NSMutableArray * links = [[NSMutableArray alloc] init];
    while ([string rangeOfString:@"<a href"].location!= NSNotFound) {
        int beginTagLocation =[string rangeOfString:@"<a href"].location;
        int contentTagLocation = [[string substringFromIndex:beginTagLocation] rangeOfString:@">"].location+1+beginTagLocation;
        
        int endTagLocation =[[string substringFromIndex:beginTagLocation] rangeOfString:@"</a>"].location+1+beginTagLocation;
        
        NSString * link = [string substringWithRange:NSMakeRange(contentTagLocation, endTagLocation-contentTagLocation-1)];
        [links addObject:link];
        
        string = [string stringByReplacingCharactersInRange:NSMakeRange(beginTagLocation, contentTagLocation-beginTagLocation) withString:@""];
    }
    string = [string stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
    
    //remove all others HTML TAG
    NSRange range;
    while ((range = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
        string = [string stringByReplacingCharactersInRange:range withString:@""];
        
    }

    string = [self stringByDecodingHTML:string];
    NSMutableAttributedString * htmlAttributedString  = [[NSMutableAttributedString alloc] initWithString:string];
    for (NSString * link in links){
        [htmlAttributedString addAttributes:kAttributeURL range:[string rangeOfString:link]];
    }
    
    return htmlAttributedString;
 
    /*
   
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *options = @{                              NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                              };
    NSMutableAttributedString *decodedString;
    NSDictionary * htmlAttributes;
    decodedString = [[NSMutableAttributedString alloc] initWithData:stringData options:options documentAttributes:&htmlAttributes error:NULL];
    [decodedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, decodedString.length)];
    
    return decodedString;
      */
}

- (NSString *)stringByDecodingHTML:(NSString *) html {
    NSUInteger myLength = [html length];
    NSUInteger ampIndex = [html rangeOfString:@"&" options:NSLiteralSearch].location;
    
    // Short-circuit if there are no ampersands.
    if (ampIndex == NSNotFound) {
        return html;
    }
    // Make result string with some extra capacity.
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
    
    // First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
    NSScanner *scanner = [NSScanner scannerWithString:html];
    
    [scanner setCharactersToBeSkipped:nil];
    
    NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
    
    do {
        // Scan up to the next entity or the end of the string.
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            goto finish;
        }
        // Scan either a HTML or numeric character entity reference.
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber;
            unsigned charCode;
            NSString *xForHex = @"";
            
            // Is it hex or decimal?
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];
            }
            else {
                gotNumber = [scanner scanInt:(int*)&charCode];
            }
            
            if (gotNumber) {
                [result appendFormat:@"%C", (unichar)charCode];
                
                [scanner scanString:@";" intoString:NULL];
            }
            else {
                NSString *unknownEntity = @"";
                
                [scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];
                
                
                [result appendFormat:@"&#%@%@", xForHex, unknownEntity];
                
                NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
                
            }
            
        }
        else {
            NSString *amp;
            
            [scanner scanString:@"&" intoString:&amp];  //an isolated & symbol
            [result appendString:amp];
            
        }
        
    }
    while (![scanner isAtEnd]);
    
finish:
    return result;
}

@end
