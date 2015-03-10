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
    width = fWidth;
    if (fWidth > 320) {
        tmpFrame = CGRectMake(70, 38, WIDTH_FOR_CONTENT_IPAD, 21);
    } else {
        tmpFrame = CGRectMake(70, 38, WIDTH_FOR_CONTENT_IPHONE, 21);
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
    
    CGSize theSize = [title boundingRectWithSize:CGSizeMake((width > 320)?WIDTH_FOR_CONTENT_IPAD:WIDTH_FOR_CONTENT_IPHONE, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{
                                                   NSFontAttributeName: kFontForTitle,
                                                   NSParagraphStyleAttributeName: wordWrapStyle
                                                   }
                                         context:nil].size;
    CGRect frame = self.lbName.frame;
    frame.size.height = ceil(theSize.height);
    self.lbName.frame = frame;
    self.lbName.text = title;

    // Activity Message
    self.htmlActivityMessage.html = [[[socialActivityStream.templateParams valueForKey:@"comment"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
    
    //When htmlActivityMessage is empty, htmlActivityMessage's frame is set to width:0 in sizeToFit
    //When the the view is recycled, the reuse will keep the width to 0
    // so htmlActivityMessage will not be correctly displayed
    if (![(NSString*)[socialActivityStream.templateParams valueForKey:@"comment"] isEqualToString:@""]) {
        [self.htmlActivityMessage sizeToFit];
    } else {
        CGRect rect = self.htmlActivityMessage.frame;
        rect.size.height = 0;
        self.htmlActivityMessage.frame = rect;
    }
    
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
    
    CGRect rect = self.htmlActivityMessage.frame;
    rect.origin.y = self.lbName.frame.size.height + self.lbName.frame.origin.y+5;
    double heigthForTTLabel = [[[self htmlActivityMessage] text] height];
    if (heigthForTTLabel > EXO_MAX_HEIGHT) heigthForTTLabel = EXO_MAX_HEIGHT;  
    rect.size.height = heigthForTTLabel;
    self.htmlActivityMessage.frame = rect;

    NSURL *url = [NSURL URLWithString:[socialActivityStream.templateParams valueForKey:@"image"]];
    if (url && url.host && url.scheme){
        self.imgvAttach.hidden = NO;
        rect = self.imgvAttach.frame;
        self.imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForUnreadableLink.png"];
        self.imgvAttach.imageURL = [NSURL URLWithString:[socialActivityStream.templateParams valueForKey:@"image"]];
        rect.origin.y = self.htmlActivityMessage.frame.size.height + self.htmlActivityMessage.frame.origin.y + 5;
        rect.origin.x = (width > 320)? (width/3 + 60) : (width/3 + 40);
        self.imgvAttach.frame = rect;
        
        rect = self.htmlLinkTitle.frame;
        rect.origin.y = self.imgvAttach.frame.size.height + self.imgvAttach.frame.origin.y + 5;
        self.htmlLinkTitle.frame = rect;
    } else {
        rect = self.htmlLinkTitle.frame;
        rect.origin.y = self.htmlActivityMessage.frame.size.height + self.htmlActivityMessage.frame.origin.y;
        self.htmlLinkTitle.frame = rect;
        self.imgvAttach.hidden = YES;
    }
    [self.htmlLinkTitle sizeToFit];
    rect = self.htmlLinkDescription.frame;
    rect.origin.y = self.htmlLinkTitle.frame.size.height + self.htmlLinkTitle.frame.origin.y;
    heigthForTTLabel = self.htmlLinkDescription.frame.size.height;
    if (heigthForTTLabel > EXO_MAX_HEIGHT) heigthForTTLabel = EXO_MAX_HEIGHT;  
    rect.size.height = heigthForTTLabel;
    self.htmlLinkDescription.frame = rect;
    
    rect = self.htmlLinkMessage.frame;
    rect.origin.y = self.htmlLinkDescription.frame.size.height + self.htmlLinkDescription.frame.origin.y;
    
    
    NSString *link = [NSString stringWithFormat:@"Source : %@",[socialActivityStream.templateParams valueForKey:@"link"]];
    
    
    theSize = [link boundingRectWithSize:CGSizeMake((width > 320)?WIDTH_FOR_CONTENT_IPAD:WIDTH_FOR_CONTENT_IPHONE, CGFLOAT_MAX)
                        options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:@{
                                  NSFontAttributeName: kFontForMessage,
                                  NSParagraphStyleAttributeName: wordWrapStyle
                                  }
                        context:nil].size;

    rect.size.height = ceil(theSize.height);
    rect.size.width = self.htmlLinkDescription.frame.size.width;
    
    
    heigthForTTLabel = rect.size.height;
    if (heigthForTTLabel > EXO_MAX_HEIGHT) heigthForTTLabel = EXO_MAX_HEIGHT;  
    rect.size.height = heigthForTTLabel;
    self.htmlLinkMessage.frame = rect;
    
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
