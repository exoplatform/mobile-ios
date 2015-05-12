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
@synthesize htmlDescriptionMessage = _htmlDescriptionMessage;

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
    _lbName.text = title;
    
    // comment

    if (socialActivityDetail.attributedMessage){
        _lbMessage.attributedText =  socialActivityDetail.attributedMessage;
    } else {
        _lbMessage.text =@"";
    }

    
    
    NSURL *url = [NSURL URLWithString:[_templateParams valueForKey:@"image"]];
    if (url && url.host && url.scheme){
        self.imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForUnreadableLink.png"];
        self.imgvAttach.imageURL = [NSURL URLWithString:[[_templateParams valueForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        _imageViewHeightConstaint.constant = 150;
    } else {
        _imageViewHeightConstaint.constant = 0;
   
    }
    
    _htmlLinkTitle.text =[socialActivityDetail.templateParams valueForKey:@"title"];

    _htmlDescriptionMessage.text =[socialActivityDetail.templateParams valueForKey:@"description"];
    
    
    NSString * linkMessage =[NSString stringWithFormat:@"Source : %@",[socialActivityDetail.templateParams valueForKey:@"link"]];
    NSMutableAttributedString * attributedLinkMessage =  [[NSMutableAttributedString alloc] initWithString:linkMessage];
    [attributedLinkMessage setAttributes:kAttributeURL range:[linkMessage rangeOfString:[socialActivityDetail.templateParams valueForKey:@"link"]]];    
    _htmlLinkMessage.attributedText = attributedLinkMessage;
    
}

- (void)dealloc {
    [_htmlLinkMessage release];
    _htmlLinkMessage = nil;
    
    [_htmlLinkTitle release];
    _htmlLinkTitle = nil;
    
    [_htmlDescriptionMessage release];
    [_imageViewHeightConstaint release];
    [super dealloc];
}


@end
