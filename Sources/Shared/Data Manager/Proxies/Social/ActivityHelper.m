//
//  ActivityHelper.m
//  eXo Platform
//
//  Created by Stévan on 06/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityHelper.h"
#import "NSString+HTML.h"
#import "LanguageHelper.h"

#define WIDTH_FOR_CONTENT_IPHONE 237
#define WIDTH_FOR_CONTENT_IPAD 409
#define kFontForMessage [UIFont fontWithName:@"Helvetica" size:13]


#define HEIGHT_FOR_DECORATION_IPHONE 90
#define HEIGHT_FOR_DECORATION_IPAD 90


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

    
    NSLog(@"text :%@   height:%d",text,fHeight);
        
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




+ (CGFloat)getHeightForActivityCell:(SocialActivityStream *)activtyStream forTableViewWidth:(CGFloat)fWidth{

    NSString* text = @"";
    float fHeight = 0.0;
    switch (activtyStream.activityType) {
        case ACTIVITY_DOC:
            text = [activtyStream.templateParams valueForKey:@"MESSAGE"];
            fHeight = [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            fHeight += [ActivityHelper getHeightSizeForText:[activtyStream.templateParams valueForKey:@"DOCNAME"]
 andTableViewWidth:fWidth];

            fHeight += 80;
            break;
        case ACTIVITY_LINK:{
            text = [activtyStream.templateParams valueForKey:@"comment"];
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            text = activtyStream.title;
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            if (![[activtyStream.templateParams valueForKey:@"image"] isEqualToString:@""]) fHeight += 30;
        }
            break;
        case ACTIVITY_WIKI_ADD_PAGE:
        case ACTIVITY_WIKI_MODIFY_PAGE:{
            NSString* textStr;//
            if([[activtyStream.templateParams valueForKey:@"act_key"] rangeOfString:@"add_page"].length > 0){//
                textStr = [NSString stringWithFormat:@"%@ %@ %@", activtyStream.posterUserProfile.fullName, Localize(@"EditWiki"),[activtyStream.templateParams valueForKey:@"page_name"]];
            } else if([[activtyStream.templateParams valueForKey:@"act_key"] rangeOfString:@"update_page"].length > 0) {
                textStr = [NSString stringWithFormat:@"%@ %@ %@", activtyStream.posterUserProfile.fullName, Localize(@"CreateWiki"),[activtyStream.templateParams valueForKey:@"page_name"]];
            }
            fHeight += [ActivityHelper getHeightSizeForText:textStr andTableViewWidth:fWidth];
            if([[activtyStream.templateParams valueForKey:@"page_exceprt"] isEqualToString:@""]){
                fHeight -= 25;
            } else {
                NSString* text = [activtyStream.templateParams valueForKey:@"page_exceprt"];
                fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            }
        }
            break;
        case ACTIVITY_FORUM_UPDATE_TOPIC:
        case ACTIVITY_FORUM_UPDATE_POST:
        case ACTIVITY_FORUM_CREATE_POST: 
        case ACTIVITY_FORUM_CREATE_TOPIC:{
            NSString* textStr;
            if(activtyStream.activityType == ACTIVITY_FORUM_CREATE_POST){
                textStr = [NSString stringWithFormat:@"%@ %@ %@", activtyStream.posterUserProfile.fullName, Localize(@"NewPost"), [activtyStream.templateParams valueForKey:@"PostName"]];
            } else if(activtyStream.activityType == ACTIVITY_FORUM_CREATE_TOPIC) {
                textStr = [NSString stringWithFormat:@"%@ %@ %@", activtyStream.posterUserProfile.fullName,  Localize(@"NewTopic"), [activtyStream.templateParams valueForKey:@"TopicName"]];
            }else if(activtyStream.activityType == ACTIVITY_FORUM_UPDATE_POST) {
                textStr = [NSString stringWithFormat:@"%@ %@ %@", activtyStream.posterUserProfile.fullName,  Localize(@"UpdatePost"), [activtyStream.templateParams valueForKey:@"PostName"]];
            }else if(activtyStream.activityType == ACTIVITY_FORUM_UPDATE_TOPIC) {
                textStr = [NSString stringWithFormat:@"%@ %@ %@", activtyStream.posterUserProfile.fullName,  Localize(@"UpdateTopic"), [activtyStream.templateParams valueForKey:@"TopicName"]];
            }
            fHeight += [ActivityHelper getHeightSizeForText:textStr andTableViewWidth:fWidth];
            text = activtyStream.title;
            fHeight += [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
            fHeight -= 15;
        }
            break;
        case ACTIVITY_ANSWER_ADD_QUESTION:
        case ACTIVITY_ANSWER_UPDATE_QUESTION:{
            text = [activtyStream.templateParams valueForKey:@"Name"];
            fHeight = [ActivityHelper getHeightSizeForText:text andTableViewWidth:fWidth];
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



@end
