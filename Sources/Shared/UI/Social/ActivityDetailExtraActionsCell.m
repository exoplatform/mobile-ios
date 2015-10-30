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

#import "ActivityDetailExtraActionsCell.h"
#import "SocialActivity.h"

#define kExtraActionsCellTopMargin 30.0
#define kExtraActionsCellBottomMargin 10.0
#define kExtraActionsCellLeftRightMargin 20.0
#define kExtraActionsCellPadding 15.0

@interface ActivityDetailExtraActionsCell ()

- (void)doInit;

@end

@implementation ActivityDetailExtraActionsCell

@synthesize socialActivity = _socialActivity;
@synthesize likeButton = _likeButton;
@synthesize commentButton = _commentButton;
@synthesize likeActivityIndicatorView = _likeActivityIndicatorView;


- (void)doInit {
    UIImage *backgroundImage = [UIImage imageNamed:@"activity-detail-actions-cell"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:backgroundImage.size.width/2 topCapHeight:0];
    self.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.likeButton];
    [self.contentView addSubview:self.commentButton];
    
    CGRect viewFrame = CGRectZero;
    viewFrame.size.width = [UIScreen mainScreen].bounds.size.width;
    viewFrame.size.height = kExtraActionsCellTopMargin + kExtraActionsCellBottomMargin + self.likeButton.bounds.size.height;
    self.frame = viewFrame;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self doInit];
    }
    return self;
}

- (instancetype)init {
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
    self.commentButton.frame = CGRectOffset(likeButtonFrame, likeButtonFrame.size.width + kExtraActionsCellPadding, 0);
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
    _socialActivity = socialActivity;
    [self updateSubViews];
}

#pragma mark - variable initialization
- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"activity-detail-action-like"];
        [_likeButton setBackgroundImage:image forState:UIControlStateNormal];
        _likeButton.bounds = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    }
    return _likeButton;
}

- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"activity-detail-action-comment"];
        [_commentButton setBackgroundImage:image forState:UIControlStateNormal];
        _commentButton.bounds = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    }
    return _commentButton;
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
