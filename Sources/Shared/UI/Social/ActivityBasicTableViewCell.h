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
#import "Three20/Three20.h"
#import "defines.h"
#import "AvatarView.h"

@class Activity;
@class SocialActivity;
@class ActivityStreamBrowseViewController;
@class SocialUserProfile;

@interface ActivityBasicTableViewCell : UITableViewCell 

@property (retain, nonatomic) IBOutlet AvatarView*                imgvAvatar;
@property (retain, nonatomic) IBOutlet UIButton*                  btnLike;
@property (retain, nonatomic) IBOutlet UIButton*                  btnComment;
@property (retain, nonatomic) IBOutlet UIImageView*               imgvMessageBg;
@property (retain, nonatomic) SocialActivity*                     socialActivytyStream;
@property (assign, nonatomic) ActivityStreamBrowseViewController* delegate;
@property (retain, nonatomic) IBOutlet UIImageView*               imgType;
@property (retain, nonatomic) IBOutlet UILabel*                   lbDate;
@property (retain, nonatomic) IBOutlet UILabel*                   lbName;
@property (retain, nonatomic) TTStyledTextLabel*                  htmlMessage;
@property NSInteger                                               activityType;

//Use this method after create the cell to customize the appearance of the Avatar
- (void)customizeAvatarDecorations;
- (void)configureCellForWidth:(CGFloat)fWidth;
- (void)configureFonts:(BOOL)highlighted;
- (void)setSocialActivityStream:(SocialActivity *)socialActivityStream;
- (void)setPlatformVersion:(float)version;


//Methods for customizing + setting the content of the cell for specific activity
- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth;
- (void)setSocialActivityStreamForSpecificContent:(SocialActivity *)socialActivityStream;


//Actions over the cell
- (void)btnLikeAction:(UIButton *)sender;
- (void)btnCommentAction:(UIButton *)sender;


@end
