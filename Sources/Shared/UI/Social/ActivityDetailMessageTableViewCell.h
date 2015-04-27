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

#import <UIKit/UIKit.h>
#import "defines.h"

#define kBottomMargin 5.0
#define kPadding 5.0

@class Activity;
@class EGOImageView;
@class SocialActivity;
@class ActivityDetail;
@class AvatarView;



@interface ActivityDetailMessageTableViewCell : UITableViewCell {

    UILabel*               _lbMessage;
    UILabel*               _lbDate;
    UILabel*               _lbName;
    
    UIImageView*           _imgType;
    EGOImageView*          _imgvAttach;
    
}

@property (nonatomic, retain) SocialActivity *socialActivity;

@property (retain, nonatomic) IBOutlet UILabel* lbMessage;
@property (retain, nonatomic) IBOutlet UILabel* lbDate;
@property (retain, nonatomic) IBOutlet UILabel* lbName;
@property (retain, nonatomic) IBOutlet AvatarView* imgvAvatar;
@property (retain) IBOutlet EGOImageView* imgvAttach;
@property (retain, nonatomic) IBOutlet UIImageView* imgType;

//Use this method after create the cell to customize the appearance of the Avatar
- (void)customizeAvatarDecorations;
- (void)configureCell;
- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth;
- (void)setSocialActivityDetail:(SocialActivity *)socialActivityDetail;
- (void)updateSizeToFitSubViews;
- (void)updateLabelsWithNewLanguage;

@end
