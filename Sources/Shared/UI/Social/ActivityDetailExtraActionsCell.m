//
//  ActivityDetailExtraActionsCell.m
//  eXo Platform
//
//  Created by Le Thanh Quang on 6/5/12.
//  Copyright (c) 2012 eXo Platform. All rights reserved.
//

#import "ActivityDetailExtraActionsCell.h"
#import "SocialActivity.h"

#define kExtraActionsCellTopMargin 30.0
#define kExtraActionsCellBottomMargin 10.0
#define kExtraActionsCellLeftRightMargin 20.0

@interface ActivityDetailExtraActionsCell ()

- (void)doInit;

@end

@implementation ActivityDetailExtraActionsCell

@synthesize socialActivity = _socialActivity;
@synthesize likeButton = _likeButton;
@synthesize likeActivityIndicatorView = _likeActivityIndicatorView;

- (void)dealloc {
    [_socialActivity release];
    [_likeButton release];
    [_likeActivityIndicatorView release];
    [super dealloc];
}

- (void)doInit {
    UIImage *backgroundImage = [UIImage imageNamed:@"activity-detail-actions-cell"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:backgroundImage.size.width/2 topCapHeight:0];
    self.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.likeButton];
    
    CGRect viewFrame = CGRectZero;
    viewFrame.size.width = [UIScreen mainScreen].bounds.size.width;
    viewFrame.size.height = kExtraActionsCellTopMargin + kExtraActionsCellBottomMargin + self.likeButton.bounds.size.height;
    self.frame = viewFrame;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self doInit];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self doInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect likeButtonFrame = self.likeButton.frame;
    likeButtonFrame.origin.x = kExtraActionsCellLeftRightMargin;
    likeButtonFrame.origin.y = kExtraActionsCellTopMargin;
    self.likeButton.frame = likeButtonFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)updateSubViews {
    NSString *likeImage = self.socialActivity.liked ? @"activity-detail-action-dislike" : @"activity-detail-action-like";
    [self.likeButton setBackgroundImage:[UIImage imageNamed:likeImage] forState:UIControlStateNormal];
    [self layoutIfNeeded];
}

- (void)setSocialActivity:(SocialActivity *)socialActivity {
    [socialActivity retain];
    [_socialActivity release];
    _socialActivity = socialActivity;
    [self updateSubViews];
}

#pragma mark - variable initialization
- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        UIImage *image = [UIImage imageNamed:@"activity-detail-action-like"];
        [_likeButton setBackgroundImage:image forState:UIControlStateNormal];
        _likeButton.bounds = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    }
    return _likeButton;
}

- (UIActivityIndicatorView *)likeActivityIndicatorView {
    if (!_likeActivityIndicatorView) {
        _likeActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return  _likeActivityIndicatorView;
}

- (void)activityIndicatorToLikeButton {
    [UIView transitionFromView:self.likeActivityIndicatorView toView:self.likeButton duration:0 options:UIViewAnimationOptionTransitionNone completion:NULL];
}

- (void)likeButtonToActivityIndicator {
    self.likeActivityIndicatorView.frame = self.likeButton.frame;
    [self.likeActivityIndicatorView sizeToFit];
    [self.likeActivityIndicatorView startAnimating];
    [UIView transitionFromView:self.likeButton toView:self.likeActivityIndicatorView duration:0 options:UIViewAnimationOptionTransitionNone completion:NULL];
}

@end
