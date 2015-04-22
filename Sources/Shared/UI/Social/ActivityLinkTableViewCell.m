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

#import "ActivityLinkTableViewCell.h"
#import "EGOImageView.h"
#import "defines.h"
#import "NSString+HTML.h"
#import "ActivityHelper.h"

@implementation ActivityLinkTableViewCell

@synthesize imgvAttach = _imgvAttach;
@synthesize htmlActivityMessage = _htmlActivityMessage;
@synthesize htmlLinkTitle =  _htmlLinkTitle;
@synthesize htmlLinkMessage = _htmlLinkMessage;
@synthesize htmlLinkDescription = _htmlLinkDescription;

- (void)configureFonts:(BOOL)highlighted {
    
    if (!highlighted) {
        self.htmlLinkDescription.textColor = [UIColor grayColor];
        self.htmlLinkDescription.backgroundColor = [UIColor whiteColor];
        
        self.htmlLinkTitle.textColor = [UIColor grayColor];
        self.htmlLinkTitle.backgroundColor = [UIColor whiteColor];
        
        self.htmlLinkMessage.textColor = [UIColor grayColor];
        self.htmlLinkMessage.backgroundColor = [UIColor whiteColor];
        
        self.htmlActivityMessage.textColor = [UIColor grayColor];
        self.htmlActivityMessage.backgroundColor = [UIColor whiteColor];
    } else {
        self.htmlLinkDescription.textColor = [UIColor darkGrayColor];
        self.htmlLinkDescription.backgroundColor = SELECTED_CELL_BG_COLOR;
        
        self.htmlLinkTitle.textColor = [UIColor darkGrayColor];
        self.htmlLinkTitle.backgroundColor = SELECTED_CELL_BG_COLOR;
        
        self.htmlLinkMessage.textColor = [UIColor darkGrayColor];
        self.htmlLinkMessage.backgroundColor = SELECTED_CELL_BG_COLOR;
        
        self.htmlActivityMessage.textColor = [UIColor darkGrayColor];
        self.htmlActivityMessage.backgroundColor = SELECTED_CELL_BG_COLOR;
    }
    
    [super configureFonts:highlighted];
}



- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth {
    
    CGRect tmpFrame = CGRectZero;
    if (fWidth > 320) {
        tmpFrame = CGRectMake(70, 38, WIDTH_FOR_CONTENT_IPAD, 21);
        width = WIDTH_FOR_CONTENT_IPAD;
    } else {
        tmpFrame = CGRectMake(70, 38, WIDTH_FOR_CONTENT_IPHONE, 21);
        width = WIDTH_FOR_CONTENT_IPHONE;
    }

    self.htmlActivityMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    self.htmlActivityMessage.userInteractionEnabled = NO;
    self.htmlActivityMessage.backgroundColor = [UIColor clearColor];
    self.htmlActivityMessage.font = [UIFont systemFontOfSize:13.0];
    self.htmlActivityMessage.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:self.htmlActivityMessage];
    
    self.htmlLinkTitle = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    self.htmlLinkTitle.userInteractionEnabled = NO;
    self.htmlLinkTitle.backgroundColor = [UIColor clearColor];
    self.htmlLinkTitle.font = [UIFont systemFontOfSize:13.0];
    self.htmlLinkTitle.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:self.htmlLinkTitle];
    
    
    self.htmlLinkDescription = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    self.htmlLinkDescription.userInteractionEnabled = NO;
    self.htmlLinkDescription.backgroundColor = [UIColor clearColor];
    self.htmlLinkDescription.font = [UIFont systemFontOfSize:13.0];
    self.htmlLinkDescription.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:self.htmlLinkDescription];
    
    self.htmlLinkMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    self.htmlLinkMessage.userInteractionEnabled = NO;
    self.htmlLinkMessage.backgroundColor = [UIColor clearColor];
    self.htmlLinkMessage.font = [UIFont systemFontOfSize:13.0];
    self.htmlLinkMessage.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:self.htmlLinkMessage];
        
}


- (void)setSocialActivityStreamForSpecificContent:(SocialActivity *)socialActivityStream {
    // Activity Title
    NSString *type = [socialActivityStream.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityStream.activityStream valueForKey:@"fullName"];
    }
    
    NSMutableParagraphStyle *wordWrapStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    wordWrapStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSString *title = [NSString stringWithFormat:@"%@%@",
                       [socialActivityStream.posterIdentity.fullName copy],
                            space ? [NSString stringWithFormat:@" in %@ space", space]
                                  : @""];
    
    CGSize theSize = [title boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{
                                                   NSFontAttributeName: kFontForTitle,
                                                   NSParagraphStyleAttributeName: wordWrapStyle
                                                   }
                                         context:nil].size;
    self.lbName.text = title;

    CGRect nameFrame = self.lbName.frame;
    nameFrame.size.height = ceil(theSize.height+2);
    dispatch_async(dispatch_get_main_queue(),^(void){
        [self.lbName setFrame:nameFrame];
    });

    // Activity Message
    NSString* activityMessage = [socialActivityStream.templateParams valueForKey:@"comment"];
    NSString* htmlTagOfImage = nil;
    // Check if an image is embedded in the activity message
    // If YES, the tag and its base64 content are saved to be decoded later, and removed from the activity message
    BOOL activityMessageContainsImage = [activityMessage containsString:@"<img src="];
    if (activityMessageContainsImage) {
        NSRange imgTagBegin = [activityMessage rangeOfString:@"<img src="];
        // Backwards search saves time if the base64 data is very long
        NSRange imgTagEnd = [activityMessage rangeOfString:@"/>" options:NSBackwardsSearch];
        NSRange imgTagRange = NSMakeRange(imgTagBegin.location, imgTagEnd.location + imgTagEnd.length - imgTagBegin.location);
        htmlTagOfImage = [activityMessage substringWithRange:imgTagRange];
        activityMessage = [activityMessage stringByReplacingCharactersInRange:imgTagRange withString:@""];
    }
    self.htmlActivityMessage.html =
      [[activityMessage stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
    
    //When htmlActivityMessage is empty, htmlActivityMessage's frame is set to width:0 in sizeToFit
    //When the the view is recycled, the reuse will keep the width to 0
    // so htmlActivityMessage will not be correctly displayed
    if (![(NSString*)[socialActivityStream.templateParams valueForKey:@"comment"] isEqualToString:@""]) {
        [self.htmlActivityMessage sizeToFit];
    } else {
        CGRect htmlActivityMessageFrame = self.htmlActivityMessage.frame;
        htmlActivityMessageFrame.size.height = 0;
        self.htmlActivityMessage.frame = htmlActivityMessageFrame;
    }
    CGRect htmlActivityMessageFrame = self.htmlActivityMessage.frame;
    htmlActivityMessageFrame.origin.y = self.lbName.frame.size.height + self.lbName.frame.origin.y+5;
    
    double heigthForTTLabel = [[[self htmlActivityMessage] text] height];
    if (heigthForTTLabel > EXO_MAX_HEIGHT) heigthForTTLabel = EXO_MAX_HEIGHT;
    htmlActivityMessageFrame.size.height = heigthForTTLabel;
    
    // Link Title
    self.htmlLinkTitle.html = [NSString stringWithFormat:@"<a>%@</a>", [[[socialActivityStream.templateParams valueForKey:@"title"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML]];
    
    // Link Message
    self.htmlLinkDescription.html = [[[socialActivityStream.templateParams valueForKey:@"description"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
    
    if (![(NSString*)[socialActivityStream.templateParams valueForKey:@"description"] isEqualToString:@""]) {
        [self.htmlLinkDescription sizeToFit];
    } else {
        CGRect rect = _htmlLinkDescription.frame;
        rect.size.height = 0;
        self.htmlLinkDescription.frame = rect;
    }
    
    
    self.htmlLinkMessage.html = [NSString stringWithFormat:@"Source : %@",[socialActivityStream.templateParams valueForKey:@"link"]];
    
    [self.htmlLinkMessage sizeToFit];
    
    // Getting image from the link
    BOOL hasImage = NO;
    
    NSURL *url = [NSURL URLWithString:[socialActivityStream.templateParams valueForKey:@"image"]];
    if (url && url.host && url.scheme){
        
        self.imgvAttach.hidden = NO;
        self.imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForUnreadableLink.png"];
        self.imgvAttach.imageURL = [NSURL URLWithString:[socialActivityStream.templateParams valueForKey:@"image"]];
        hasImage = YES;
        
    } else if (activityMessageContainsImage) {
        
        self.imgvAttach.image = nil;
        
        void (^decodeImageBlock)(void) = ^(void) {
            
            NSError* err = nil;
            NSString* base64StringOfImage = nil;
            NSRegularExpression* regex =
            [NSRegularExpression regularExpressionWithPattern:@"<img src=\"(.*)\"(.*) />"
                                                      options:NSRegularExpressionCaseInsensitive
                                                        error:&err];
            if (!err) {
                NSTextCheckingResult *match =
                [regex firstMatchInString:htmlTagOfImage
                                  options:0
                                    range:NSMakeRange(0, [htmlTagOfImage length])];
                if (match) {
                    NSRange rangeOfImage = [match rangeAtIndex:1];
                    if (!NSEqualRanges(rangeOfImage, NSMakeRange(NSNotFound, 0))) {
                        // Keep the data url in base64 format that contains the image
                        base64StringOfImage = [htmlTagOfImage substringWithRange:rangeOfImage];
                        // Remove part of the string that is not actual data
                        base64StringOfImage = [base64StringOfImage stringByReplacingOccurrencesOfString:@"data:<;base64," withString:@""];
                        // Add missing = at the end so the total length is a multiple of 4
                        if (base64StringOfImage.length % 4 > 0) {
                            int remainder = base64StringOfImage.length % 4;
                            for (int i = 4; i > remainder; i--) {
                                base64StringOfImage = [base64StringOfImage stringByAppendingString:@"="];
                            }
                        }
                        NSData* imageData = [[NSData alloc] initWithBase64EncodedString:base64StringOfImage
                                                                                options:NSDataBase64DecodingIgnoreUnknownCharacters];
                        UIImage* imageAttached = [UIImage imageWithData:imageData];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // called on the UI thread to display the image immediately
                            self.imgvAttach.image = imageAttached;
                        });
                    }
                }
            }
        };
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), decodeImageBlock);
        hasImage = YES;
    }
    
    _imgvAttach.hidden = !hasImage;
    
    
    CGRect imgvAttachFrame;
    CGRect htmlLinkTitleFrame;
    
    htmlLinkTitleFrame = self.htmlLinkTitle.frame;
    htmlLinkTitleFrame.origin.y  = htmlActivityMessageFrame.origin.y + htmlActivityMessageFrame.size.height +5;
    [self.htmlLinkTitle sizeToFit];
    htmlLinkTitleFrame.size.height = [[self.htmlLinkTitle text] height] + 2;
    
    /* Estime link message height */
    
    CGRect htmlLinkMessageFrame = self.htmlLinkMessage.frame;
    
    NSString *link = [NSString stringWithFormat:@"Source : %@",[socialActivityStream.templateParams valueForKey:@"link"]];
    
    
    theSize = [link boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                        options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:@{
                                  NSFontAttributeName: kFontForMessage,
                                  NSParagraphStyleAttributeName: wordWrapStyle
                                  }
                        context:nil].size;

    htmlLinkMessageFrame.size.height = MIN (EXO_MAX_HEIGHT, ceil(theSize.height+2));
    htmlLinkMessageFrame.size.width = self.htmlLinkDescription.frame.size.width;
    
    CGRect htmlLinkDescriptionFrame = self.htmlLinkDescription.frame;
    htmlLinkDescriptionFrame.size.height = MIN( EXO_MAX_HEIGHT, self.htmlLinkDescription.frame.size.height);

    /* */
    float cellHeight = [ActivityHelper getHeightForActivityCell:socialActivityStream forTableViewWidth:width];
    
    if (hasImage){
        htmlLinkMessageFrame.origin.y =cellHeight - 42 - htmlLinkMessageFrame.size.height;
        htmlLinkDescriptionFrame.origin.y = htmlLinkMessageFrame.origin.y - htmlLinkDescriptionFrame.size.height - 5;
        imgvAttachFrame = _imgvAttach.frame;
        imgvAttachFrame.origin.x = 15;
        imgvAttachFrame.size.width = width;
        imgvAttachFrame.origin.y = htmlLinkTitleFrame.origin.y + htmlLinkTitleFrame.size.height + 5;
        imgvAttachFrame.size.height = htmlLinkDescriptionFrame.origin.y - imgvAttachFrame.origin.y -5;
        
    } else {
        imgvAttachFrame = CGRectZero;
        htmlLinkDescriptionFrame.origin.y = htmlLinkTitleFrame.origin.y + htmlLinkTitleFrame.size.height + 2;
        htmlLinkMessageFrame.origin.y = htmlLinkDescriptionFrame.origin.y + htmlLinkDescriptionFrame.size.height+2;
        htmlLinkMessageFrame.size.height = cellHeight - 40 - htmlLinkMessageFrame.origin.y;
    }
    
    dispatch_async(dispatch_get_main_queue(),^(void){
        [self.htmlActivityMessage setFrame: htmlActivityMessageFrame];
        [self.htmlLinkTitle setFrame:htmlLinkTitleFrame];
        [self.imgvAttach setFrame:imgvAttachFrame];
        [self.htmlLinkDescription setFrame:htmlLinkDescriptionFrame];
        [self.htmlLinkMessage setFrame:htmlLinkMessageFrame];
    });
    
    
}

- (void)dealloc {    
    self.imgvAttach = nil;
    self.htmlActivityMessage = nil;
    self.htmlLinkTitle = nil;
    self.htmlLinkDescription = nil;
    self.htmlLinkMessage = nil;
    
    [super dealloc];
}


@end
