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

#import "ActivityLinkDetailMessageTableViewCell.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "defines.h"
#import "NSString+HTML.h"
#import "EGOImageView.h"
#import "ActivityHelper.h"
#import "LanguageHelper.h"

#define WIDTH_FOR_CONTENT_IPHONE 237
#define WIDTH_FOR_CONTENT_IPAD 409
#define kFontForLink [UIFont fontWithName:@"Helvetica" size:15]

@implementation ActivityLinkDetailMessageTableViewCell

@synthesize htmlLinkTitle = _htmlLinkTitle;
@synthesize htmlLinkMessage = _htmlLinkMessage;
@synthesize htmlActivityMessage = _htmlActivityMessage;

- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth {
    
    CGRect tmpFrame = CGRectZero;
    
    if (fWidth > 320) {
        tmpFrame = CGRectMake(67, 0, WIDTH_FOR_CONTENT_IPAD, 21);
        width = WIDTH_FOR_CONTENT_IPAD;
    } else {
        tmpFrame = CGRectMake(67, 0, WIDTH_FOR_CONTENT_IPHONE, 21);
        width = WIDTH_FOR_CONTENT_IPHONE;
    }
        
    //_webViewComment.contentMode = UIViewContentModeScaleAspectFit;
    [[self.webViewComment.subviews objectAtIndex:0] setScrollEnabled:NO];
    [self.webViewComment setBackgroundColor:[UIColor clearColor]];
    UIScrollView *scrollView = (UIScrollView *)[[self.webViewComment subviews] objectAtIndex:0];
    scrollView.bounces = NO;
    [scrollView flashScrollIndicators];
    self.webViewComment.dataDetectorTypes = UIDataDetectorTypeLink | UIDataDetectorTypeAddress;

    [self.webViewComment setOpaque:NO];
}

- (void)updateSizeToFitSubViews {
    
    CGRect myFrame = self.frame;
    myFrame.size.height = self.webViewComment.frame.origin.y + self.webViewComment.frame.size.height + self.lbDate.bounds.size.height + kBottomMargin;
    
    self.frame = myFrame;
}

- (void)setSocialActivityDetail:(SocialActivity *)socialActivityDetail{
    [super setSocialActivityDetail:socialActivityDetail];
    
    // Title
    NSString *type = [socialActivityDetail.activityStream valueForKey:@"type"];
    NSString *space = nil;
    NSDictionary *_templateParams = self.socialActivity.templateParams;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityDetail.activityStream valueForKey:@"fullName"];
    }
    NSMutableParagraphStyle *wordWrapStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    wordWrapStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSString *title = [NSString stringWithFormat:@"%@%@", [socialActivityDetail.posterIdentity.fullName copy], space ? [NSString stringWithFormat:@" in %@ space", space] : @""];
    
    CGSize theSize = [title boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{
                                                   NSFontAttributeName: kFontForTitle,
                                                   NSParagraphStyleAttributeName: wordWrapStyle
                                                   }
                                         context:nil].size;
    CGRect rect = self.lbName.frame;
    rect.size.height = theSize.height + kBottomMargin;
    self.lbName.frame = rect;
    self.lbName.text = title;
    
    // Content
    [self.webViewForContent loadHTMLString:
     [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;}</style></head><body>%@</body></html>", [_templateParams valueForKey:@"comment"]?[_templateParams valueForKey:@"comment"]:@""] 
                               baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
     ];
    
    // Comment
    [self.webViewComment loadHTMLString:
     [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;} p{color: #115EAD; text-decoration: none; font-weight: bold;}</style></head><body><a href=\"%@\">%@</a></br>%@Source : %@</body></html>",[_templateParams valueForKey:@"link"],[_templateParams valueForKey:@"title"],(![[[_templateParams valueForKey:@"description"] stringByConvertingHTMLToPlainText] isEqualToString:@""])?[NSString stringWithFormat:@"%@</br>", [[_templateParams valueForKey:@"description"] stringByConvertingHTMLToPlainText]]:@"",  [_templateParams valueForKey:@"link"]] 
                            baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
     ];
    
    NSString *textWithoutHtml = [[_templateParams valueForKey:@"comment"] stringByConvertingHTMLToPlainText];
    
    theSize = [textWithoutHtml boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{
                                                      NSFontAttributeName: kFontForMessage,
                                                      NSParagraphStyleAttributeName: wordWrapStyle
                                                      }
                                            context:nil].size;
    rect = self.webViewForContent.frame;
    rect.origin.y =  self.lbName.frame.size.height + self.lbName.frame.origin.y;
    rect.size.height =  ceil(theSize.height) + kBottomMargin;
    self.webViewForContent.frame = rect;
    
    // Attached Image
    NSURL *url = [NSURL URLWithString:[_templateParams valueForKey:@"image"]];
    if (url && url.host && url.scheme){
        rect = self.imgvAttach.frame;
        self.imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForUnreadableLink.png"];
        self.imgvAttach.imageURL = [NSURL URLWithString:[[_templateParams valueForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        rect.origin.y = self.webViewForContent.frame.size.height + self.webViewForContent.frame.origin.y + kBottomMargin;
        rect.origin.x = (width > 320)? (width/3 + 100) : (width/3 + 50);
        self.imgvAttach.frame = rect;
        
        rect = self.webViewComment.frame;
        rect.origin.y = self.imgvAttach.frame.size.height + self.imgvAttach.frame.origin.y + kBottomMargin;
    } else {
        rect = self.webViewComment.frame;
        rect.origin.y = self.webViewForContent.frame.size.height + self.webViewForContent.frame.origin.y + kBottomMargin;
    }
    
    textWithoutHtml = [[_templateParams valueForKey:@"title"] stringByConvertingHTMLToPlainText];
    theSize = [textWithoutHtml boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{
                                                      NSFontAttributeName: kFontForMessage,
                                                      NSParagraphStyleAttributeName: wordWrapStyle
                                                      }
                                            context:nil].size;
    rect.size.height = ceil(theSize.height);
    //
    textWithoutHtml = [[_templateParams valueForKey:@"description"] stringByConvertingHTMLToPlainText];
    theSize = [textWithoutHtml boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{
                                                      NSFontAttributeName: kFontForMessage,
                                                      NSParagraphStyleAttributeName: wordWrapStyle
                                                      }
                                            context:nil].size;
    rect.size.height += ceil(theSize.height);
    
    textWithoutHtml = [NSString stringWithFormat:@"Source : %@",[[_templateParams valueForKey:@"link"] stringByConvertingHTMLToPlainText]];
    theSize = [textWithoutHtml boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{
                                                      NSFontAttributeName: kFontForMessage,
                                                      NSParagraphStyleAttributeName: wordWrapStyle
                                                      }
                                            context:nil].size;
    rect.size.height += ceil(theSize.height) + kBottomMargin;
    
    self.webViewComment.frame = rect;
    
    [self.webViewForContent sizeToFit];
    [self.webViewComment sizeToFit];
    [self updateSizeToFitSubViews];
}

- (void)dealloc {
    [_htmlLinkMessage release];
    _htmlLinkMessage = nil;
    
    [_htmlLinkTitle release];
    _htmlLinkTitle = nil;
    
    [super dealloc];
}


@end
