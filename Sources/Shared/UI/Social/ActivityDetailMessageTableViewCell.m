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

#import "ActivityDetailMessageTableViewCell.h"
#import "AvatarView.h"
#import "MockSocial_Activity.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialActivity.h"
#import "defines.h"
#import "ActivityHelper.h"
#import "LanguageHelper.h"

@implementation ActivityDetailMessageTableViewCell

@synthesize socialActivity = _socialActivity;
@synthesize lbMessage=_lbMessage, lbDate=_lbDate, lbName=_lbName, imgvAvatar=_imgvAvatar;
@synthesize webViewForContent = _webViewForContent;
@synthesize webViewComment =  _webViewComment;

@synthesize imgType = _imgType;
@synthesize imgvAttach = _imgvAttach;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [_imgvAvatar needToBeResizedForSize:CGSizeMake(45,45)];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.lbDate.frame;
    frame.origin.y = self.frame.size.height - kBottomMargin - frame.size.height;
    self.lbDate.frame = frame;
    
    frame = self.imgType.frame;
    frame.origin.y = self.lbDate.frame.origin.y;
    self.imgType.frame = frame;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];    
}

- (void)dealloc
{
    
    self.lbMessage = nil;
    self.lbDate = nil;
    self.lbName = nil;
    self.webViewForContent.delegate = nil;
    self.webViewForContent = nil;
    self.webViewComment.delegate = nil;
    self.webViewComment = nil;
    self.imgvAvatar = nil;
    [super dealloc];
}

- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth{
    
}

- (void)updateSizeToFitSubViews {
    //Set the position of lbMessage
    CGRect tmpFrame = _webViewForContent.frame;
    tmpFrame.origin.y = _lbName.frame.origin.y + _lbName.frame.size.height + 5;
    _webViewForContent.frame = tmpFrame;
    
    CGRect myFrame = self.frame;
    myFrame.size.height = _webViewForContent.frame.origin.y + _webViewForContent.frame.size.height + kPadding + _lbDate.bounds.size.height + kBottomMargin;
    
    self.frame = myFrame;
}

#pragma mark - Activity Cell methods 

- (void)customizeAvatarDecorations {
}


- (void)configureFonts {
    
}


- (void)configureCell {
    [self customizeAvatarDecorations];
    
    
    //_webViewForContent.contentMode = UIViewContentModeScaleAspectFit;
    [[_webViewForContent.subviews objectAtIndex:0] setScrollEnabled:NO];
    [_webViewForContent setBackgroundColor:[UIColor clearColor]];
    UIScrollView *scrollView = (UIScrollView *)[[_webViewForContent subviews] objectAtIndex:0];
    scrollView.bounces = NO;
    [scrollView flashScrollIndicators];
    scrollView.scrollsToTop = YES;
    [_webViewForContent setOpaque:NO];
}


- (void)setSocialActivityDetail:(SocialActivity *)socialActivityDetail
{
    self.socialActivity = socialActivityDetail;
    _lbName.text = self.socialActivity.posterIdentity.fullName;
    _lbDate.text = socialActivityDetail.postedTimeInWords;
    _imgvAvatar.imageURL = [NSURL URLWithString:socialActivityDetail.posterIdentity.avatarUrl];
    self.lbMessage.text=@"";

    switch (self.socialActivity.activityType) {
        case ACTIVITY_DEFAULT:
        {
            self.lbMessage.attributedText = socialActivityDetail.attributedMessage ? socialActivityDetail.attributedMessage : @"";
            
        }
            break;
    }
    
}

#pragma mark - change language management
- (void)updateLabelsWithNewLanguage{
    // The date in words
    _lbDate.text = self.socialActivity.postedTimeInWords;
    // Calling the setter with the same values will reset all the properties,
    // including the labels localized in the new language
    [self setSocialActivityDetail:self.socialActivity];
}


@end
