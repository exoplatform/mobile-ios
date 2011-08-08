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
    
    UIButton*              _btnLike;
    
    SocialActivityDetails*  _socialActivityDetails;
    SocialUserProfile*      _socialUserProfile;
    id                      _delegate;
}

@property (retain, nonatomic) id delegate;
@property (retain, nonatomic) IBOutlet UILabel* lbMessage;
@property (retain, nonatomic) IBOutlet UIButton* btnLike;

//Use this method after create the cell to customize the appearance of the Avatar
- (void)configureCell;
- (void)setUserProfile:(SocialUserProfile*)socialUserProfile;
- (void)setUserLikeThisActivity:(BOOL)userLikeThisActivity;
- (void)setContent:(NSString*)strLikes;
- (void)setSocialActivityDetails:(SocialActivityDetails*)socialActivityDetails;
@end
