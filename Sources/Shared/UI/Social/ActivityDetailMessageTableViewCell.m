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
@synthesize imgType = _imgType;
@synthesize imgvAttach = _imgvAttach;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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

- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth{
    
}

- (void)updateSizeToFitSubViews {

}

#pragma mark - Activity Cell methods 

- (void)customizeAvatarDecorations {
}


- (void)configureFonts {
    
}


- (void)configureCell {
    [self customizeAvatarDecorations];
    
}


- (void)setSocialActivityDetail:(SocialActivity *)socialActivityDetail
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        self.lbName.preferredMaxLayoutWidth = WIDTH_FOR_LABEL_IPAD;
        self.lbMessage.preferredMaxLayoutWidth = WIDTH_FOR_LABEL_IPAD;
    }
    
    self.socialActivity = socialActivityDetail;
    
    NSString *type = [socialActivityDetail.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityDetail.activityStream valueForKey:@"fullName"];
    }
    
    NSString *title = [NSString stringWithFormat:@"%@%@", [socialActivityDetail.posterIdentity.fullName copy], space ?[NSString stringWithFormat:@" %@ %@ %@",Localize(@"in"), space, Localize(@"space")] : @""];
    
    
    NSMutableAttributedString * attributedTitle = [[NSMutableAttributedString alloc] initWithString:title];
    if (space) {
        [attributedTitle addAttributes:kAttributeText range:[title rangeOfString:[NSString stringWithFormat:@" %@ %@ %@",Localize(@"in"), space, Localize(@"space")]]];
        [attributedTitle addAttributes:kAttributeNameSpace range:[title rangeOfString:space]];
    }
    
    _lbName.attributedText = attributedTitle;
    self.lbDate.text = socialActivityDetail.postedTimeInWords;
    self.imgvAvatar.imageURL = [NSURL URLWithString:socialActivityDetail.posterIdentity.avatarUrl];
    self.lbMessage.text=@"";

    switch (self.socialActivity.activityType) {
        case ACTIVITY_DEFAULT:
        {
            if (socialActivityDetail.attributedMessage) {
                self.lbMessage.attributedText = socialActivityDetail.attributedMessage;
            } else {
                self.lbMessage.text =socialActivityDetail.title ?socialActivityDetail.title:@"";
            }
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
