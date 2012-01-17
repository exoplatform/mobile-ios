//
//  ActivityBasicTableViewCell.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "defines.h"

@class Activity;
@class EGOImageView;
@class SocialActivityStream;
@class ActivityStreamBrowseViewController;
@class SocialUserProfile;


@interface ActivityBasicTableViewCell : UITableViewCell {
    
    UILabel*                                _lbDate;
    UILabel*                                _lbName;
    
    EGOImageView*                           _imgvAvatar;
    UIImageView*                            _imgType;
    UIButton*                               _btnLike;
    UIButton*                               _btnComment;
    
    UIImageView*                            _imgvMessageBg;
    
    SocialActivityStream*                   _socialActivytyStream;
    ActivityStreamBrowseViewController*     _delegate;
    NSInteger                               _activityType;
    
    TTStyledTextLabel*                      _htmlMessage;
}

@property (retain, nonatomic) IBOutlet EGOImageView* imgvAvatar;
@property (retain, nonatomic) IBOutlet UIButton* btnLike;
@property (retain, nonatomic) IBOutlet UIButton* btnComment;
@property (retain, nonatomic) IBOutlet UIImageView* imgvMessageBg;
@property (retain, nonatomic) SocialActivityStream*  socialActivytyStream;
@property (retain, nonatomic) ActivityStreamBrowseViewController* delegate;

@property (retain, nonatomic) IBOutlet UIImageView*  imgType;
@property (retain, nonatomic) IBOutlet UILabel* lbDate;
@property (retain, nonatomic) IBOutlet UILabel* lbName;
@property (retain, nonatomic) TTStyledTextLabel   *htmlMessage;

@property NSInteger activityType;

//Use this method after create the cell to customize the appearance of the Avatar
- (void)customizeAvatarDecorations;
- (void)configureCellForWidth:(CGFloat)fWidth;
- (void)configureFonts:(BOOL)highlighted;
- (void)setSocialActivityStream:(SocialActivityStream*)socialActivityStream;


//Methods for customizing + setting the content of the cell for specific activity
- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth;
- (void)setSocialActivityStreamForSpecificContent:(SocialActivityStream*)socialActivityStream;


//Actions over the cell
- (void)btnLikeAction:(UIButton *)sender;
- (void)btnCommentAction:(UIButton *)sender;


@end
