//
//  ActivityDetailExtraActionsCell.h
//  eXo Platform
//
//  Created by Le Thanh Quang on 6/5/12.
//  Copyright (c) 2012 eXo Platform. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SocialActivity;


@interface ActivityDetailExtraActionsCell : UITableViewCell

@property (nonatomic, retain) SocialActivity *socialActivity;
@property (nonatomic, retain) UIButton *likeButton;
@property (nonatomic, retain) UIActivityIndicatorView *likeActivityIndicatorView;

- (void)updateSubViews;
- (void)likeButtonToActivityIndicator;
- (void)activityIndicatorToLikeButton;

@end
