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

#import "ActivityHelper.h"
#import "NSString+HTML.h"
#import "LanguageHelper.h"
#import "eXoMobileAppDelegate.h"
#import "defines.h"


#define HEIGHT_FOR_DECORATION_IPHONE 90
#define HEIGHT_FOR_DECORATION_IPAD 90

#define MAX_LENGTH 80

@implementation ActivityHelper


// Specific method to retrieve the height of the cell
// This method override the inherited one.
+ (float)getHeightSizeForText:(NSString*)text andTableViewWidth:(CGFloat)fWidth
{
     
    NSMutableString *textMutable = [[NSMutableString alloc] init];
    if (text) [textMutable setString:text];
    
    int nbBR = [textMutable replaceOccurrencesOfString:@"<br />" withString:@"<br />" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [text length])];
    
    [textMutable release];
    
    
    //Search the width available to display the text
    if (fWidth > 320) 
    {
        fWidth = WIDTH_FOR_CONTENT_IPAD - 15;
    }
    else
    {
        fWidth = WIDTH_FOR_CONTENT_IPHONE - 10;
    }
    
    NSString* textWithoutHtml = [text stringByConvertingHTMLToPlainText];
        
    CGSize theSize = [textWithoutHtml sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    
    int fHeight = theSize.height + nbBR * 10;

            
    return fHeight;
}

+ (float)getHeightSizeForTitle:(NSString*)text andTableViewWidth:(CGFloat)fWidth
{
    
    NSMutableString *textMutable = [[NSMutableString alloc] init];
    if (text) [textMutable setString:text];
    
    int nbBR = [textMutable replaceOccurrencesOfString:@"<br />" withString:@"<br />" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [text length])];
    
    [textMutable release];
    
    
    //Search the width available to display the text
    if (fWidth > 320) 
    {
        fWidth = WIDTH_FOR_CONTENT_IPAD - 15;
    }
    else
    {
        fWidth = WIDTH_FOR_CONTENT_IPHONE - 10;
    }
    
    NSString* textWithoutHtml = [text stringByConvertingHTMLToPlainText];
    
    CGSize theSize = [textWithoutHtml sizeWithFont:kFontForTitle constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    
    int fHeight = theSize.height + nbBR * 10;
    
        
    return fHeight;
}


+ (float)heightForAllDecorationsWithTableViewWidth:(CGFloat)fWidth {

    float heightForDecotation = 0;
    
    //Search the width available to display the text
    if (fWidth > 320) 
    {
        heightForDecotation = HEIGHT_FOR_DECORATION_IPAD;
    }
    else
    {
        heightForDecotation = HEIGHT_FOR_DECORATION_IPHONE;
    }
    
    return heightForDecotation;
    
}

+ (CGFloat)getHeightForActivityDetailCell:(SocialActivity *)activtyStreamDetail forTableViewWidth:(CGFloat)fWidth{
    //return 0.0;
    NSString* text = @"";
    float fHeight = 0.0;
    NSString *type = [activtyStreamDetail.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [activtyStreamDetail.activityStream valueForKey:@"fullName"];
    }
    text = [NSString stringWithFormat:@"%@ %@", [activtyStreamDetail.posterIdentity.fullName copy], space ? [NSString stringWithFormat:@"in %@ space", space] : @""];
    fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
    
    switch (activtyStreamDetail.activityType) {
        case ACTIVITY_DOC:{
            text = [activtyStreamDetail.templateParams valueForKey:@"MESSAGE"];
            fHeight += [ActivityHelper getHeightSizeForTitle:text andTableViewWidth:fWidth] + 80;
            fHeight += [ActivityHelper getHeightSizeForText:[activtyStreamDetail.templateParams valueForKey:@"DOCNAME"]
                                          andTableViewWidth:fWidth];
        }
            break;
        case ACTIVITY_CONTENTS_SPACE:
        {
            text = [NSString stringWithFormat:@"<a>%@</a> was created by <a>%@</a> state : %@", [activtyStreamDetail.templateParams valueForKey:@"contentName"], [activtyStreamDetail.templateParams valueForKey:@"author"], [activtyStreamDetail.templateParams valueForKey:@"state"]];
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth] + 80;
        }
            break;  
        case ACTIVITY_LINK:{
            text = [activtyStreamDetail.templateParams valueForKey:@"comment"];
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            text = [activtyStreamDetail.templateParams valueForKey:@"title"];
            fHeight += [ActivityHelper getHeightSizeForTitle:text andTableViewWidth:fWidth];
            text = [activtyStreamDetail.templateParams valueForKey:@"description"];
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            text = [NSString stringWithFormat:@"Source : %@", [activtyStreamDetail.templateParams valueForKey:@"link"]];
            fHeight += [ActivityHelper getHeightSizeForTitle:text andTableViewWidth:fWidth];
            
            NSURL *url = [NSURL URLWithString:[activtyStreamDetail.templateParams valueForKey:@"image"]];
            if (url && url.host && url.scheme) {
                fHeight += 75;
            }
        }
            break;
        case ACTIVITY_WIKI_ADD_PAGE:
        case ACTIVITY_WIKI_MODIFY_PAGE:
        {
            if([[activtyStreamDetail.templateParams valueForKey:@"act_key"] rangeOfString:@"add_page"].length > 0){//
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"EditWiki")];
                
            } else if([[activtyStreamDetail.templateParams valueForKey:@"act_key"] rangeOfString:@"update_page"].length > 0) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"CreateWiki")];
            }
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            fHeight += [ActivityHelper getHeightSizeForTitle:[activtyStreamDetail.templateParams valueForKey:@"page_name"] andTableViewWidth:fWidth];
            if([[activtyStreamDetail.templateParams valueForKey:@"page_exceprt"] isEqualToString:@""]){
                fHeight -= 25;
            } else {
                text = [[activtyStreamDetail.templateParams valueForKey:@"page_exceprt"] stringByConvertingHTMLToPlainText];
                fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth] - 25;
            }
        }
            break;
        case ACTIVITY_FORUM_CREATE_POST: 
        case ACTIVITY_FORUM_CREATE_TOPIC:
        case ACTIVITY_FORUM_UPDATE_POST:
        case ACTIVITY_FORUM_UPDATE_TOPIC:{
            if(activtyStreamDetail.activityType == ACTIVITY_FORUM_CREATE_POST){
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"NewPost")];
                fHeight += [ActivityHelper getHeightSizeForTitle:[activtyStreamDetail.templateParams valueForKey:@"PostName"] andTableViewWidth:fWidth];
            } else if(activtyStreamDetail.activityType == ACTIVITY_FORUM_CREATE_TOPIC) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName,  Localize(@"NewTopic")];
                fHeight += [ActivityHelper getHeightSizeForTitle:[activtyStreamDetail.templateParams valueForKey:@"TopicName"] andTableViewWidth:fWidth];
            }else if(activtyStreamDetail.activityType == ACTIVITY_FORUM_UPDATE_POST) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName,  Localize(@"UpdatePost")];
                fHeight += [ActivityHelper getHeightSizeForTitle:[activtyStreamDetail.templateParams valueForKey:@"PostName"] andTableViewWidth:fWidth];
            }else if(activtyStreamDetail.activityType == ACTIVITY_FORUM_UPDATE_TOPIC) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName,  Localize(@"UpdateTopic")];
                fHeight += [ActivityHelper getHeightSizeForTitle:[activtyStreamDetail.templateParams valueForKey:@"TopicName"] andTableViewWidth:fWidth];
            }
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            //Set the size of the cell
            text = activtyStreamDetail.body;
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth] - 30;
            
        }
            break;
        case ACTIVITY_ANSWER_ADD_QUESTION:
        case ACTIVITY_ANSWER_QUESTION:
        case ACTIVITY_ANSWER_UPDATE_QUESTION:
        {
            if(activtyStreamDetail.activityType == ACTIVITY_ANSWER_ADD_QUESTION){//
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"Asked")];
                
            } else if(activtyStreamDetail.activityType == ACTIVITY_ANSWER_QUESTION) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"Answered")];
            } else if(activtyStreamDetail.activityType == ACTIVITY_ANSWER_UPDATE_QUESTION) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"UpdateQuestion")];
            }
            fHeight += [ActivityHelper getHeightSizeForTitle:text andTableViewWidth:fWidth];

            text = [activtyStreamDetail.templateParams valueForKey:@"Name"];
            fHeight += [ActivityHelper getHeightSizeForTitle:text andTableViewWidth:fWidth];
            text = activtyStreamDetail.body;
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth] - 30;
        }
            break;
        case ACTIVITY_CALENDAR_UPDATE_TASK:
        case ACTIVITY_CALENDAR_ADD_TASK:
        case ACTIVITY_CALENDAR_ADD_EVENT:
        case ACTIVITY_CALENDAR_UPDATE_EVENT:
        {
            if(activtyStreamDetail.activityType == ACTIVITY_CALENDAR_ADD_EVENT){//
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"EventAdded")];
                
            } else if(activtyStreamDetail.activityType == ACTIVITY_CALENDAR_UPDATE_EVENT) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"EventUpdated")];
            } else if(activtyStreamDetail.activityType == ACTIVITY_CALENDAR_ADD_TASK) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"TaskAdded")];
            }else if(activtyStreamDetail.activityType == ACTIVITY_CALENDAR_UPDATE_TASK) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStreamDetail.posterIdentity.fullName, Localize(@"TaskUpdated")];
            }
            fHeight += [ActivityHelper getHeightSizeForTitle:text andTableViewWidth:fWidth];
            text = [activtyStreamDetail.templateParams valueForKey:@"EventSummary"];
            fHeight += [ActivityHelper getHeightSizeForTitle:text andTableViewWidth:fWidth];
            text = [NSString stringWithFormat:@"Description : %@", [activtyStreamDetail.templateParams valueForKey:@"EventDescription"]];
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            text = [NSString stringWithFormat:@"Location : %@", [activtyStreamDetail.templateParams valueForKey:@"EventLocale"]];
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            
        }
            break;
        default:{
            text = activtyStreamDetail.title;
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            //NSLog(@"%@", text);
        }
            break;
    }
    
    fHeight += [ActivityHelper heightForAllDecorationsWithTableViewWidth:fWidth];
    return fHeight;
}


+ (CGFloat)getHeightForActivityCell:(SocialActivity *)activtyStream forTableViewWidth:(CGFloat)fWidth{

    NSString* text = @"";
    float fHeight = 0.0;
    NSString *type = [activtyStream.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [activtyStream.activityStream valueForKey:@"fullName"];
    }
    text = [NSString stringWithFormat:@"%@ %@", [activtyStream.posterIdentity.fullName copy], space ? [NSString stringWithFormat:@"in %@ space", space] : @""];
    fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
    
    float h = 0.0;
    switch (activtyStream.activityType) {
        case ACTIVITY_DOC:{
            text = [activtyStream.templateParams valueForKey:@"MESSAGE"];
            h =  [ActivityHelper getHeightSizeForTitle:text andTableViewWidth:fWidth];
            if(h > EXO_MAX_HEIGHT){
                h = EXO_MAX_HEIGHT;
            }
            fHeight += h;
            h = [ActivityHelper getHeightSizeForText:[activtyStream.templateParams valueForKey:@"DOCNAME"]
 andTableViewWidth:fWidth];
            if(h > 32){
                h = 32;
            }
            fHeight += h + 80;
        }
            break;
        case ACTIVITY_CONTENTS_SPACE:{
            text = [NSString stringWithFormat:@"<a>%@</a> was created by <a>%@</a> state : %@", [activtyStream.templateParams valueForKey:@"contentName"], [activtyStream.templateParams valueForKey:@"author"], [activtyStream.templateParams valueForKey:@"state"]];
            h =  [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            if(h > EXO_MAX_HEIGHT){
                h = EXO_MAX_HEIGHT;
            }
            fHeight += h + 80;
        }
            break;
        case ACTIVITY_LINK:{
            text = [[activtyStream.templateParams valueForKey:@"comment"] stringByConvertingHTMLToPlainText];
            h =  [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            if(h > EXO_MAX_HEIGHT){
                h = EXO_MAX_HEIGHT;
            }
            fHeight += h;
            text = [[activtyStream.templateParams valueForKey:@"title"] stringByConvertingHTMLToPlainText];
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            text = [[activtyStream.templateParams valueForKey:@"description"] stringByConvertingHTMLToPlainText];
            h = [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            if(h > EXO_MAX_HEIGHT){
                h = EXO_MAX_HEIGHT;
            }
            fHeight += h;
            
            text = [NSString stringWithFormat:@"Source : %@", [activtyStream.templateParams valueForKey:@"link"]];
            h = [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            if(h > EXO_MAX_HEIGHT){
                h = EXO_MAX_HEIGHT;
            }
            fHeight += h;
            
            NSURL *url = [NSURL URLWithString:[activtyStream.templateParams valueForKey:@"image"]];
            if (url && url.host && url.scheme){
                fHeight += 65;
            } else {
                fHeight -= 10;
            }

        }
            break;
        case ACTIVITY_WIKI_ADD_PAGE:
        case ACTIVITY_WIKI_MODIFY_PAGE:{
            if([[activtyStream.templateParams valueForKey:@"act_key"] rangeOfString:@"add_page"].length > 0){//
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterIdentity.fullName, Localize(@"EditWiki")];
            } else if([[activtyStream.templateParams valueForKey:@"act_key"] rangeOfString:@"update_page"].length > 0) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterIdentity.fullName, Localize(@"CreateWiki")];
            }
            fHeight += [ActivityHelper getHeightSizeForTitle:text andTableViewWidth:fWidth];
            
            h = [ActivityHelper getHeightSizeForTitle:[activtyStream.templateParams valueForKey:@"page_name"] andTableViewWidth:fWidth];
            if(h > EXO_MAX_HEIGHT){
                h = EXO_MAX_HEIGHT;
            }
            fHeight += h;
            
            if([[activtyStream.templateParams valueForKey:@"page_exceprt"] isEqualToString:@""]){
                fHeight -= 20;
            } else {
                text = [[activtyStream.templateParams valueForKey:@"page_exceprt"] stringByConvertingHTMLToPlainText];
                
                float h = [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
                if(h > EXO_MAX_HEIGHT){
                    h = EXO_MAX_HEIGHT;
                }
                fHeight += h - 25;
            }
        }
            break;
        case ACTIVITY_FORUM_UPDATE_TOPIC:
        case ACTIVITY_FORUM_UPDATE_POST:
        case ACTIVITY_FORUM_CREATE_POST: 
        case ACTIVITY_FORUM_CREATE_TOPIC:{
            if(activtyStream.activityType == ACTIVITY_FORUM_CREATE_POST){
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterIdentity.fullName, Localize(@"NewPost")];
                h = [ActivityHelper getHeightSizeForTitle:[activtyStream.templateParams valueForKey:@"PostName"] andTableViewWidth:fWidth];
            } else if(activtyStream.activityType == ACTIVITY_FORUM_CREATE_TOPIC) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterIdentity.fullName,  Localize(@"NewTopic")];
                h = [ActivityHelper getHeightSizeForTitle:[activtyStream.templateParams valueForKey:@"TopicName"] andTableViewWidth:fWidth];
            }else if(activtyStream.activityType == ACTIVITY_FORUM_UPDATE_POST) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterIdentity.fullName,  Localize(@"UpdatePost")];
                h = [ActivityHelper getHeightSizeForTitle:[activtyStream.templateParams valueForKey:@"PostName"] andTableViewWidth:fWidth];
            }else if(activtyStream.activityType == ACTIVITY_FORUM_UPDATE_TOPIC) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterIdentity.fullName,  Localize(@"UpdateTopic")];
                h = [ActivityHelper getHeightSizeForTitle:[activtyStream.templateParams valueForKey:@"TopicName"] andTableViewWidth:fWidth];
            }
            fHeight += [ActivityHelper getHeightSizeForTitle:text andTableViewWidth:fWidth] + h;
            text = activtyStream.body;
            //fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            h = [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            if(h > EXO_MAX_HEIGHT){
                h = EXO_MAX_HEIGHT;
            }
            fHeight += h;
        }
            break;
        case ACTIVITY_ANSWER_ADD_QUESTION:
        case ACTIVITY_ANSWER_QUESTION:
        case ACTIVITY_ANSWER_UPDATE_QUESTION:{
            if(activtyStream.activityType == ACTIVITY_ANSWER_ADD_QUESTION){
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterIdentity.fullName, Localize(@"Asked")];
            } else if(activtyStream.activityType == ACTIVITY_ANSWER_QUESTION) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterIdentity.fullName, Localize(@"Answered")];
            }else if(activtyStream.activityType == ACTIVITY_ANSWER_UPDATE_QUESTION) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterIdentity.fullName, Localize(@"UpdateQuestion")];
            }
            fHeight += [ActivityHelper getHeightSizeForTitle:text andTableViewWidth:fWidth];
            
            text = [activtyStream.templateParams valueForKey:@"Name"];
            h =  [ActivityHelper getHeightSizeForTitle:text andTableViewWidth:fWidth];
            if(h > EXO_MAX_HEIGHT){
                h = EXO_MAX_HEIGHT;
            }
            fHeight += h;
            
            text = activtyStream.body;
            h =  [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            if(h > EXO_MAX_HEIGHT){
                h = EXO_MAX_HEIGHT;
            }
            fHeight += h - 15;
        }
            break;
        case ACTIVITY_CALENDAR_UPDATE_TASK:
        case ACTIVITY_CALENDAR_ADD_TASK:
        case ACTIVITY_CALENDAR_ADD_EVENT:
        case ACTIVITY_CALENDAR_UPDATE_EVENT:{
            if(activtyStream.activityType == ACTIVITY_CALENDAR_ADD_EVENT){//
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterIdentity.fullName, Localize(@"EventAdded")];
            } else if(activtyStream.activityType == ACTIVITY_CALENDAR_UPDATE_EVENT) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterIdentity.fullName, Localize(@"EventUpdated")];
            } else if(activtyStream.activityType == ACTIVITY_CALENDAR_ADD_TASK) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterIdentity.fullName, Localize(@"TaskAdded")];
            }else if(activtyStream.activityType == ACTIVITY_CALENDAR_UPDATE_TASK) {
                text = [NSString stringWithFormat:@"%@ %@", activtyStream.posterIdentity.fullName, Localize(@"TaskUpdated")];
            }
            fHeight += [ActivityHelper getHeightSizeForTitle:text andTableViewWidth:fWidth];
            
            text = [[activtyStream.templateParams valueForKey:@"EventSummary"] stringByConvertingHTMLToPlainText];
            h = [ActivityHelper getHeightSizeForTitle:text andTableViewWidth:fWidth];
            if(h > EXO_MAX_HEIGHT){
                h = EXO_MAX_HEIGHT;
            }
            fHeight += h;
            
            text = [NSString stringWithFormat:@"Description : %@", [[activtyStream.templateParams valueForKey:@"EventDescription"] stringByConvertingHTMLToPlainText]];
            h = [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            
            text = [NSString stringWithFormat:@"Location : %@", [[activtyStream.templateParams valueForKey:@"EventLocale"] stringByConvertingHTMLToPlainText]];
            h += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            if(h > EXO_MAX_HEIGHT){
                h = EXO_MAX_HEIGHT;
            }
            if(h < 32){
                h = 32;
            }
            fHeight += h;
        }
            break;
        default:{
            text = activtyStream.title;
            fHeight = [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            
        }
            break;
    }
    
    //Need to calculate the number of <br> + for each br Add 10 pixel
    /*
    NSMutableString *textMutable = [[NSMutableString alloc] init];
    [textMutable setString:text];
    
    int nbBR = [textMutable replaceOccurrencesOfString:@"<br>" withString:@"<br>" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [text length])];
    
    fHeight += nbBR * 10;
    */
    
    fHeight += [ActivityHelper heightForAllDecorationsWithTableViewWidth:fWidth];
    
    return  fHeight;

    
    
}


// Specific method to retrieve the height of the cell
// This method override the inherited one.
+ (float)calculateCellHeighForTableView:(UITableView *)tableView andText:(NSString*)text
{
    CGRect rectTableView = tableView.frame;
    float fWidth = 0;
    float fHeight = 0;
    
    fWidth = rectTableView.size.width - 100;
    
    NSArray *textLines = [text componentsSeparatedByString:@"<br />"];
    NSMutableString *pseudoDisplayedText = [NSMutableString string];
    for (NSString *line in textLines) {
        [pseudoDisplayedText appendString:[line stringByConvertingHTMLToPlainText]];
        [pseudoDisplayedText appendString:@"\n"];
    }
    
    
    CGSize theSize = [pseudoDisplayedText sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    
    if (theSize.height < 30) 
    {
        fHeight = 100;
    }
    else
    {
        fHeight = 75 + theSize.height;
    }
    
    return fHeight;
}

@end
