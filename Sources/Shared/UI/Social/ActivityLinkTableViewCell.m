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
@synthesize imageViewHeightConstraint = _imageViewHeightConstraint;

- (void)setSocialActivityStreamForSpecificContent:(SocialActivity *)socialActivityStream {
    //Set the UserName of the activity
    NSString *type = [socialActivityStream.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityStream.activityStream valueForKey:@"fullName"];
    }
    
    

    NSString *title = [NSString stringWithFormat:@"%@%@", [socialActivityStream.posterIdentity.fullName copy], space ? [NSString stringWithFormat:@" in %@ space", space] : @""];
    
    
    _lbName.text = title;
    
    if (socialActivityStream.attributedMessage){
        _htmlActivityMessage.attributedText =  socialActivityStream.attributedMessage;
    } else {
        _htmlActivityMessage.text =@"";
    }
    
    // Link Title

    _htmlLinkTitle.text =[socialActivityStream.templateParams valueForKey:@"title"];
    
    _htmlLinkDescription.text =[socialActivityStream.templateParams valueForKey:@"description"];
    NSString * linkMessage =[NSString stringWithFormat:@"Source : %@",[socialActivityStream.templateParams valueForKey:@"link"]];
    NSMutableAttributedString * attributedLinkMessage =  [[NSMutableAttributedString alloc] initWithString:linkMessage];
    [attributedLinkMessage setAttributes:kAttributeURL range:[linkMessage rangeOfString:[socialActivityStream.templateParams valueForKey:@"link"]]];
    
    _htmlLinkMessage.attributedText = attributedLinkMessage;

    NSURL *url = [NSURL URLWithString:[socialActivityStream.templateParams valueForKey:@"image"]];
    if (url && url.host && url.scheme){
        self.imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForUnreadableLink.png"];
        self.imgvAttach.imageURL = [NSURL URLWithString:[socialActivityStream.templateParams valueForKey:@"image"]];
        _imageViewHeightConstraint.constant = EXO_IMAGE_CELL_HEIGHT;

    } else {
        _imageViewHeightConstraint.constant = 0;
    }
    
}


- (void)dealloc {

    /* */
    float cellHeight = [ActivityHelper getHeightForActivityCell:socialActivityStream forTableViewWidth:width];
    
    if (hasImage){
        htmlLinkMessageFrame.origin.y =cellHeight - 42 - htmlLinkMessageFrame.size.height; // 42 = size of lbDate + Buttom Padding
        htmlLinkDescriptionFrame.origin.y = htmlLinkMessageFrame.origin.y - htmlLinkDescriptionFrame.size.height - 5;
        imgvAttachFrame = _imgvAttach.frame;
        imgvAttachFrame.origin.x = 15;  // Padding from the left.
        imgvAttachFrame.size.width = width;
        imgvAttachFrame.origin.y = htmlLinkTitleFrame.origin.y + htmlLinkTitleFrame.size.height + 5;
        imgvAttachFrame.size.height = htmlLinkDescriptionFrame.origin.y - imgvAttachFrame.origin.y -5;
        
    } else {
        imgvAttachFrame = CGRectZero;
        htmlLinkDescriptionFrame.origin.y = htmlLinkTitleFrame.origin.y + htmlLinkTitleFrame.size.height + 5;
        htmlLinkMessageFrame.origin.y = htmlLinkDescriptionFrame.origin.y + htmlLinkDescriptionFrame.size.height+5;
        
        // Use flexible padding to fit all subviews in the cell.
        float diff = htmlLinkMessageFrame.origin.y + htmlLinkMessageFrame.size.height- ((cellHeight-40) - htmlLinkMessageFrame.origin.y);
        float padding = MIN(5.0, diff/4.0);
        
        htmlActivityMessageFrame.origin.y -=padding;
        htmlLinkTitleFrame.origin.y -=2*padding;
        htmlLinkDescriptionFrame.origin.y -= 3*padding;
        htmlLinkMessageFrame.origin.y -= 4*padding;
        htmlLinkMessageFrame.size.height = (cellHeight-40) - htmlLinkMessageFrame.origin.y;// cellHeight -40 -> lbDate.frame.origin.y after auto layout. 40 = 28 + paddings
        
    }
    
    dispatch_async(dispatch_get_main_queue(),^(void){
        [self.lbName setFrame:nameFrame];
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
    
    [_imageViewHeightConstraint release];
    [_htmlActivityMessage release];
    [_htmlLinkTitle release];
    [_htmlLinkDescription release];
    [_htmlLinkMessage release];
    [super dealloc];
}


@end
