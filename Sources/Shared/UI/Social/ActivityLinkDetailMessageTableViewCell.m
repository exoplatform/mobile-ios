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
    [[_webViewComment.subviews objectAtIndex:0] setScrollEnabled:NO];
    [_webViewComment setBackgroundColor:[UIColor clearColor]];
    UIScrollView *scrollView = (UIScrollView *)[[_webViewComment subviews] objectAtIndex:0];
    scrollView.bounces = NO;
    [scrollView flashScrollIndicators];
    _webViewComment.dataDetectorTypes = UIDataDetectorTypeLink | UIDataDetectorTypeAddress;

    [_webViewComment setOpaque:NO];
}

- (void)updateSizeToFitSubViews {
    
    CGRect myFrame = self.frame;
    myFrame.size.height = _webViewComment.frame.origin.y + _webViewComment.frame.size.height + _lbDate.bounds.size.height + kBottomMargin;
    
    self.frame = myFrame;
}

#define kFontForLink [UIFont fontWithName:@"Helvetica" size:15]
- (void)setSocialActivityDetail:(SocialActivity *)socialActivityDetail{
    [super setSocialActivityDetail:socialActivityDetail];
    NSString *type = [socialActivityDetail.activityStream valueForKey:@"type"];
    NSString *space = nil;
    NSDictionary *_templateParams = self.socialActivity.templateParams;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityDetail.activityStream valueForKey:@"fullName"];
    }
    NSString *title = [NSString stringWithFormat:@"%@%@", [socialActivityDetail.posterIdentity.fullName copy], space ? [NSString stringWithFormat:@" in %@ space", space] : @""];
    CGSize theSize = [title sizeWithFont:kFontForTitle constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                           lineBreakMode:UILineBreakModeWordWrap];
    CGRect rect = _lbName.frame;
    rect.size.height = theSize.height + 5;
    _lbName.frame = rect;
    
    //Set the UserName of the activity
    _lbName.text = title;
    
    // comment
    [_webViewForContent loadHTMLString:
     [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;}</style></head><body>%@</body></html>", [_templateParams valueForKey:@"comment"]?[_templateParams valueForKey:@"comment"]:@""] 
                               baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
     ];
    
    // Content
    [_webViewComment loadHTMLString:
     [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;} p{color: #115EAD; text-decoration: none; font-weight: bold;}</style></head><body><a href=\"%@\">%@</a></br>%@Source : %@</body></html>",[_templateParams valueForKey:@"link"],[_templateParams valueForKey:@"title"],(![[[_templateParams valueForKey:@"description"] stringByConvertingHTMLToPlainText] isEqualToString:@""])?[NSString stringWithFormat:@"%@</br>", [[_templateParams valueForKey:@"description"] stringByConvertingHTMLToPlainText]]:@"",  [_templateParams valueForKey:@"link"]] 
                            baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
     ];
    
    NSString *textWithoutHtml = [[_templateParams valueForKey:@"comment"] stringByConvertingHTMLToPlainText];
    theSize = [textWithoutHtml sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    
    
    rect = _webViewForContent.frame;
    rect.origin.y =  _lbName.frame.size.height + _lbName.frame.origin.y;
    rect.size.height =  theSize.height + 5;
    
    _webViewForContent.frame = rect;
    NSURL *url = [NSURL URLWithString:[_templateParams valueForKey:@"image"]];
    if (url && url.host && url.scheme){
        rect = self.imgvAttach.frame;
        self.imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForUnreadableLink.png"];
        self.imgvAttach.imageURL = [NSURL URLWithString:[[_templateParams valueForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        rect.origin.y = _webViewForContent.frame.size.height + _webViewForContent.frame.origin.y + 5;
        rect.origin.x = (width > 320)? (width/3 + 100) : (width/3 + 50);
        self.imgvAttach.frame = rect;
        
        rect = _webViewComment.frame;
        rect.origin.y = self.imgvAttach.frame.size.height + self.imgvAttach.frame.origin.y + 5;
    } else {
        rect = _webViewComment.frame;
        rect.origin.y = _webViewForContent.frame.size.height + _webViewForContent.frame.origin.y;
    }
    
    textWithoutHtml = [[_templateParams valueForKey:@"title"] stringByConvertingHTMLToPlainText];
    theSize = [textWithoutHtml sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    rect.size.height = theSize.height;
    //
    textWithoutHtml = [[_templateParams valueForKey:@"description"] stringByConvertingHTMLToPlainText];
    theSize = [textWithoutHtml sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                              lineBreakMode:UILineBreakModeWordWrap];
    rect.size.height += theSize.height;
    
    textWithoutHtml = [NSString stringWithFormat:@"Source : %@",[[_templateParams valueForKey:@"link"] stringByConvertingHTMLToPlainText]];
    theSize = [textWithoutHtml sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                              lineBreakMode:UILineBreakModeWordWrap];
    rect.size.height += theSize.height + 5;
    
    _webViewComment.frame = rect;
    
    [_webViewForContent sizeToFit];
    [_webViewComment sizeToFit];
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
