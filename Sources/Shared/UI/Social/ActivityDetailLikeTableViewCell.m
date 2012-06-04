//
//  ActivityDetailLikeTableViewCell.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityDetailLikeTableViewCell.h"
#import "AvatarView.h"
#import "MockSocial_Activity.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialActivity.h"
#import "ActivityDetailViewController.h"
#import "LanguageHelper.h"


#define kSeparatorLineLeftMargin 20.0
#define kTopMargin 15.0
#define kBottomMargin 5.0
#define kLeftRightMargin 10.0
#define kPadding 5.0
#define kNumberOfDisplayedAvatars 4
#define kThreePointAvatarTag 100

@interface ActivityDetailLikeTableViewCell () 

@property (nonatomic, retain) NSMutableArray *likerAvatarImageViews;
- (void)reloadAvatarViews;
- (UIImage *)imageOfThreePointsWithSize:(CGSize)imageSize;
- (AvatarView *)newAvatarView;


@end

@implementation ActivityDetailLikeTableViewCell

@synthesize socialActivity = _socialActivity;
@synthesize lbMessage=_lbMessage;
@synthesize btnLike=_btnLike, delegate=_delegate;
@synthesize likerAvatarImageViews = _likerAvatarImageViews;
@synthesize myAccessoryView = _myAccessoryView;

- (void)dealloc
{
    [_lbMessage release];
    [_btnLike release];
    [_socialActivity release];
    [_likerAvatarImageViews release];
    [_myAccessoryView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *backgroundImage = [UIImage imageNamed:@"activityDetailLikeBg"];
        UIImage *selectedBGImage = [UIImage imageNamed:@"activityDetailLikeBgSelected"];
        self.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:selectedBGImage] autorelease];
        self.likerAvatarImageViews = [NSMutableArray arrayWithCapacity:kNumberOfDisplayedAvatars];
        
        [self.contentView addSubview:self.myAccessoryView];
        
        [self.contentView addSubview:self.lbMessage];
        
        [self.contentView addSubview:self.btnLike];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentBounds = self.contentView.bounds;
    /* ### Configure message label ### */
    CGSize messageSize = [_lbMessage.text sizeWithFont:_lbMessage.font];
    _lbMessage.frame = CGRectMake(kLeftRightMargin, kTopMargin, messageSize.width, messageSize.height); // the message is on the top of the content view
    /* ##### */
    float avatarHeight = (contentBounds.size.height - (kTopMargin + kBottomMargin) - self.lbMessage.bounds.size.height - kPadding);
    
    /* ### Configure accessory view ### */
    if (self.selected) {
        self.myAccessoryView.imageView.image = [UIImage imageNamed:@"activityDetailLikersAccessoryViewSelected"];
    } else {
        self.myAccessoryView.imageView.image = [UIImage imageNamed:@"activityDetailLikersAccessoryView"];
    }
    CGSize accessorySize = self.myAccessoryView.imageView.image.size;
    CGSize likeButtonSize = self.btnLike.imageView.image.size;
    
    
    float secondLineHeight = self.socialActivity.totalNumberOfLikes > 0 ? avatarHeight : MAX(accessorySize.height, likeButtonSize.height);
    
    float secondLineY = contentBounds.size.height - kBottomMargin - secondLineHeight;
    
    /* ##### */
    self.myAccessoryView.frame = CGRectMake(contentBounds.size.width - kLeftRightMargin - accessorySize.width, secondLineY + (secondLineHeight - accessorySize.height) / 2, accessorySize.width, accessorySize.height);
    
    /* ### Configure liked button ### */
    _btnLike.frame = CGRectMake(contentBounds.size.width - kLeftRightMargin - self.myAccessoryView.bounds.size.width - kPadding - likeButtonSize.width, secondLineY + (secondLineHeight - likeButtonSize.height) / 2, likeButtonSize.width, likeButtonSize.height); // The like button is on the right bottom corner of the content view
    /* ##### */
    
    /* ### Configure avatar view ### */
    int i = 0;
    for (EGOImageView *avatarView in self.likerAvatarImageViews) {
        // the avatar view is putted consequently on the left bottom corner of the content view
        avatarView.frame = CGRectMake(kLeftRightMargin + i * (avatarHeight + kPadding), contentBounds.size.height - kBottomMargin - avatarHeight, avatarHeight, avatarHeight);
        i++;
    }
    /* ##### */
    
        /* ### Configure three point view ### */
        EGOImageView *threePointView = (EGOImageView *)[self.contentView viewWithTag:kThreePointAvatarTag];
        if (!threePointView) {
            threePointView = [self newAvatarView];
            threePointView.image = [self imageOfThreePointsWithSize:CGSizeMake(avatarHeight, avatarHeight)];
            [threePointView setTag:kThreePointAvatarTag];
            [self.contentView addSubview:threePointView];
        }
    if (self.socialActivity.totalNumberOfLikes > kNumberOfDisplayedAvatars) {
        threePointView.frame = CGRectMake(kLeftRightMargin + i * (avatarHeight + kPadding), contentBounds.size.height - kBottomMargin - avatarHeight, avatarHeight, avatarHeight);
    } else {
        [threePointView setHidden:YES];
    }
    /* ##### */
}

#pragma mark - getters & setters
- (UILabel *)lbMessage {
    if (!_lbMessage) {
        _lbMessage = [[UILabel alloc] init];
        [_lbMessage setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
        _lbMessage.backgroundColor = [UIColor clearColor];
        _lbMessage.textColor = [UIColor whiteColor];
    }
    return _lbMessage;
}

- (UIButton *)btnLike {
    if (!_btnLike) {
        _btnLike = [[UIButton alloc] init];
        [_btnLike setImage:[UIImage imageNamed:@"SocialActivityDetailLikeButton.png"] forState:UIControlStateNormal];
        [_btnLike addTarget:self action:@selector(btnLikeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLike;
}

- (UIButton *)myAccessoryView {
    if (!_myAccessoryView) {
        _myAccessoryView = [[UIButton alloc] init];
        [_myAccessoryView setImage:[UIImage imageNamed:@"activityDetailLikersAccessoryView"] forState:UIControlStateNormal];
    }
    return _myAccessoryView;
}

#pragma mark - Liker avatar management
- (AvatarView *)newAvatarView {
    AvatarView *imageView = [[[AvatarView alloc] init] autorelease];
    // Update the CornerRadius
    [[imageView layer] setMasksToBounds:YES];
    // Update the border color
//    [[imageView layer] setBorderColor:[UIColor colorWithRed:134./255 green:134./255 blue:134./255 alpha:1.].CGColor];
    
    return imageView;
}

- (void)reloadAvatarViews {
    for (EGOImageView *avatarView in _likerAvatarImageViews) {
        [avatarView removeFromSuperview];
    }
    [_likerAvatarImageViews removeAllObjects];
    
    int i = 0;
    for (SocialUserProfile *user in self.socialActivity.likedByIdentities) {
        if (i == kNumberOfDisplayedAvatars) break;
        EGOImageView *imageView = [self newAvatarView];
        [_likerAvatarImageViews addObject:imageView];
        [self.contentView addSubview:imageView]; // add the avatar view to the content view
        [imageView setImageURL:[NSURL URLWithString:user.avatarUrl]];
        i++;
    }
}

// create image for the text "..."
- (UIImage *)imageOfThreePointsWithSize:(CGSize)imageSize {
    NSString *threePoints = @"...";
    UIFont *font = [UIFont boldSystemFontOfSize:20.0];
    CGRect rect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
    // this method is available from iOS 4.0
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:134./255 green:134./255 blue:134./255 alpha:1.].CGColor);
    [threePoints drawInRect:rect withFont:font lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Activity Cell methods 

- (void)setUserLikeThisActivity:(BOOL)userLikeThisActivity
{
    if(userLikeThisActivity) {
        [_btnLike setImage:[UIImage imageNamed:@"SocialActivityDetailDislikeButton.png"] forState:UIControlStateNormal];
    }else {
        [_btnLike setImage:[UIImage imageNamed:@"SocialActivityDetailLikeButton.png"] forState:UIControlStateNormal];
    }
    
}


- (void)setSocialActivity:(SocialActivity *)socialActivity
{
    [_socialActivity release];
    _socialActivity = [socialActivity retain];
    
    self.lbMessage.text = [NSString stringWithFormat:Localize(@"likeThisActivity"), _socialActivity.totalNumberOfLikes];
    [self setUserLikeThisActivity:_socialActivity.liked];
    [self reloadAvatarViews];
}


-(void)btnLikeAction:(UIButton *)sender
{
    if([_delegate respondsToSelector:@selector(likeDislikeActivity:)])
        [_delegate likeDislikeActivity:self.socialActivity.activityId];
    
}

@end
