//
//  ActivityDetailLikeTableViewCell.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;
@class EGOImageView;
@class SocialActivityDetails;
@class SocialUserProfile;
@interface ActivityDetailLikeTableViewCell : UITableViewCell {
    
    UILabel*               _lbMessage;
    UILabel*               _lbDate;
    
    EGOImageView*          _imgvAvatar;

    UIImageView*           _imgvMessageBg;
    UIButton*              _btnLike;
    
    SocialActivityDetails*  _socialActivityDetails;
    SocialUserProfile*      _socialUserProfile;
    id                      _delegate;
}

@property (retain, nonatomic) id delegate;
@property (retain, nonatomic) IBOutlet UILabel* lbMessage;
@property (retain, nonatomic) IBOutlet UILabel* lbDate;
@property (retain, nonatomic) IBOutlet EGOImageView* imgvAvatar;
@property (retain, nonatomic) IBOutlet UIImageView* imgvMessageBg;
@property (retain, nonatomic) IBOutlet UIButton* btnLike;

//Use this method after create the cell to customize the appearance of the Avatar
- (void)customizeAvatarDecorations;
- (void)configureCell;
- (void)setUserProfile:(SocialUserProfile*)socialUserProfile;
- (void)setActivity:(Activity*)activity;
- (void)setContent:(NSString*)strLikes;
- (void)setSocialActivityDetails:(SocialActivityDetails*)socialActivityDetails;
@end
