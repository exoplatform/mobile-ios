//
//  ActivityBasicTableViewCell.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityBasicTableViewCell.h"
#import "EGOImageView.h"
#import "MockSocial_Activity.h"
#import <QuartzCore/QuartzCore.h>


@implementation ActivityBasicTableViewCell

@synthesize lbMessage=_lbMessage, lbDate=_lbDate, lbName=_lbName, imgvAvatar=_imgvAvatar;
@synthesize btnLike = _btnLike, btnComment = _btnComment, imgvMessageBg=_imgvMessageBg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];

    [_imgvMessageBg setHighlighted:highlighted]; 
    
    [_btnComment setHighlighted:highlighted];
    [_btnLike setHighlighted:highlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    [_imgvMessageBg setHighlighted:selected];
    [_btnComment setSelected:selected];
    [_btnLike setSelected:selected];
}

- (void)dealloc
{
    
    self.lbMessage = nil;
    self.lbDate = nil;
    self.lbName = nil;
    
    self.imgvAvatar = nil;
    self.btnLike = nil;
    self.btnComment = nil;
    
    self.imgvMessageBg = nil;
    
    [super dealloc];
}


#pragma mark - Activity Cell methods 

- (void)customizeAvatarDecorations {
    //Add the CornerRadius
    [[_imgvAvatar layer] setCornerRadius:6.0];
    [[_imgvAvatar layer] setMasksToBounds:YES];
    
    //Add the border
    [[_imgvAvatar layer] setBorderColor:[UIColor colorWithRed:170./255 green:170./255 blue:170./255 alpha:1.].CGColor];
    CGFloat borderWidth = 2.0;
    [[_imgvAvatar layer] setBorderWidth:borderWidth];
    
    //Add the inner shadow
    CALayer *innerShadowLayer = [CALayer layer];
    innerShadowLayer.contents = (id)[UIImage imageNamed: @"ActivityAvatarShadow.png"].CGImage;
    innerShadowLayer.contentsCenter = CGRectMake(10.0f/21.0f, 10.0f/21.0f, 1.0f/21.0f, 1.0f/21.0f);
    innerShadowLayer.frame = CGRectMake(borderWidth,borderWidth,_imgvAvatar.frame.size.width-2*borderWidth, _imgvAvatar.frame.size.height-2*borderWidth);
    [_imgvAvatar.layer addSublayer:innerShadowLayer];
}


- (void)configureFonts {
    
}


- (void)configureCell {
    
    [self customizeAvatarDecorations];
    
    //Add images for Background Message
    UIImage *strechBg = [[UIImage imageNamed:@"SocialActivityBrowserActivityBg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
    
    UIImage *strechBgSelected = [[UIImage imageNamed:@"SocialActivityBrowserActivityBgSelected.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
    
    _imgvMessageBg.image = strechBg;
    _imgvMessageBg.highlightedImage = strechBgSelected;
    
    
    //Add images for Comment button
    [_btnComment setBackgroundImage:[[UIImage imageNamed:@"SocialActivityBrowserCommentButton.png"] 
                                     stretchableImageWithLeftCapWidth:15 topCapHeight:0] 
                           forState:UIControlStateNormal];
    [_btnComment setBackgroundImage:[[UIImage imageNamed:@"SocialActivityBrowserCommentButtonSelected.png"] 
                                     stretchableImageWithLeftCapWidth:15 topCapHeight:0] 
                           forState:UIControlStateSelected];
    [_btnComment setBackgroundImage:[[UIImage imageNamed:@"SocialActivityBrowserCommentButtonSelected.png"] 
                                     stretchableImageWithLeftCapWidth:15 topCapHeight:0] 
                           forState:UIControlStateHighlighted];
    
    
    
    //Add images for Like button
    [_btnLike setBackgroundImage:[[UIImage imageNamed:@"SocialActivityBrowserLikeButton.png"] 
                                     stretchableImageWithLeftCapWidth:15 topCapHeight:0] 
                           forState:UIControlStateNormal];
    [_btnLike setBackgroundImage:[[UIImage imageNamed:@"SocialActivityBrowserLikeButtonSelected.png"] 
                                  stretchableImageWithLeftCapWidth:15 topCapHeight:0] 
                        forState:UIControlStateSelected];
    [_btnLike setBackgroundImage:[[UIImage imageNamed:@"SocialActivityBrowserLikeButtonSelected.png"] 
                                  stretchableImageWithLeftCapWidth:15 topCapHeight:0] 
                        forState:UIControlStateHighlighted];
    
    


    
   
}


- (void)setActivity:(Activity*)activity
{
    _imgvAvatar.imageURL = [NSURL URLWithString:activity.avatarUrl];    
    _lbMessage.text = [activity.title copy];
    _lbDate.text = [activity.postedTimeInWords copy];
    _lbName.text = [activity.userFullName copy];
    
    //display the like number '+' if 0
    NSString *stringForLikes;
    if (activity.nbLikes == 0) {
        stringForLikes = @"+";
    } else {
        stringForLikes = [NSString stringWithFormat:@"%d",activity.nbLikes];
    }
    [_btnLike setTitle:stringForLikes forState:UIControlStateNormal];
    
    //Set the size of the font in the button (to fit the width)
    if (activity.nbLikes >= 100) {
        _btnLike.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:7];
    } else {
        _btnLike.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10];
    }
    
    //display the comment number '+' if 0
    NSString *stringForComments;
    if (activity.nbComments == 0) {
        stringForComments = @"+";
    } else {
        stringForComments = [NSString stringWithFormat:@"%d",activity.nbComments];
    }
    [_btnComment setTitle:stringForComments forState:UIControlStateNormal];

    //Set the size of the font in the button (to fit the width)
    if (activity.nbComments >= 100) {
        _btnComment.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:7];
    } else {
        _btnComment.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10];
    }
    
}


@end
