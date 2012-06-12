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
@class SocialActivity;
@class SocialUserProfile;
@interface ActivityDetailLikeTableViewCell : UITableViewCell {
    id                      _delegate;
}

@property (retain, nonatomic) SocialActivity *socialActivity;
@property (assign, nonatomic) id delegate;
@property (retain, nonatomic) IBOutlet UILabel* lbMessage;
@property (retain, nonatomic) IBOutlet UIButton* btnLike;
@property (retain, nonatomic) UIButton *myAccessoryView;

- (void)setUserLikeThisActivity:(BOOL)userLikeThisActivity;
- (void)likeButtonToActivityIndicator;
- (void)activityIndicatorToLikeButton;

@end
