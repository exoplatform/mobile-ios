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
        [self.imgvAvatar needToBeResizedForSize:CGSizeMake(45,45)];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.lbDate.frame;
    frame.origin.y = self.frame.size.height - kBottomMargin - frame.size.height;
    self.lbDate.frame = frame;
    
    frame = self.imgType.frame;
    frame.origin.y = self.lbDate.frame.origin.y + 4;
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
    CGRect tmpFrame = self.webViewForContent.frame;
    tmpFrame.origin.y = self.lbName.frame.origin.y + self.lbName.frame.size.height + kPadding;
    self.webViewForContent.frame = tmpFrame;
    
    CGRect myFrame = self.frame;
    myFrame.size.height = self.webViewForContent.frame.origin.y + self.webViewForContent.frame.size.height + kPadding + self.lbDate.bounds.size.height + kBottomMargin;
    
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
    [[self.webViewForContent.subviews objectAtIndex:0] setScrollEnabled:NO];
    [self.webViewForContent setBackgroundColor:[UIColor clearColor]];
    UIScrollView *scrollView = (UIScrollView *)[[self.webViewForContent subviews] objectAtIndex:0];
    scrollView.bounces = NO;
    [scrollView flashScrollIndicators];
    scrollView.scrollsToTop = YES;
    [self.webViewForContent setOpaque:NO];
}


- (void)setSocialActivityDetail:(SocialActivity *)socialActivityDetail
{
    self.socialActivity = socialActivityDetail;
    self.lbMessage.text = @"";
    self.lbName.text = self.socialActivity.posterIdentity.fullName;
    self.lbDate.text = socialActivityDetail.postedTimeInWords;
    self.imgvAvatar.imageURL = [NSURL URLWithString:socialActivityDetail.posterIdentity.avatarUrl];
    switch (self.socialActivity.activityType) {
        case ACTIVITY_DEFAULT:
        {
            NSString *htmlStr = [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><body>%@</body></html>",socialActivityDetail.title ? socialActivityDetail.title : @""];
            [self.webViewForContent loadHTMLString:htmlStr ? htmlStr :@""
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            
            [self updateSizeToFitSubViews];
            
        }
            break;
    }
}

#pragma mark - change language management
- (void)updateLabelsWithNewLanguage{
    // The date in words
    self.lbDate.text = self.socialActivity.postedTimeInWords;
    // Calling the setter with the same values will reset all the properties,
    // including the labels localized in the new language
    [self setSocialActivityDetail:self.socialActivity];
}


@end
