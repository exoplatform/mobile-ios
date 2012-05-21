//
//  ActivityDetailLikeTableViewCell.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityDetailLikeTableViewCell.h"
#import "EGOImageView.h"
#import "MockSocial_Activity.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialActivity.h"
#import "ActivityDetailViewController.h"

@implementation ActivityDetailLikeTableViewCell

@synthesize lbMessage=_lbMessage;
@synthesize btnLike=_btnLike, delegate=_delegate;

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

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (void)dealloc
{
    self.lbMessage = nil;
    [super dealloc];
}


#pragma mark - Activity Cell methods 


#define kSeparatorLineLeftMarging 20

- (void)configureCell {
        
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(kSeparatorLineLeftMarging, self.frame.size.height-6, self.frame.size.width - (2*kSeparatorLineLeftMarging), 1)];
    separatorLine.backgroundColor = [UIColor colorWithRed:112./255 green:112./255 blue:112./255 alpha:1.];
    separatorLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:separatorLine];
    [separatorLine release];
}


- (void)setUserLikeThisActivity:(BOOL)userLikeThisActivity
{
    if(userLikeThisActivity) {
        [_btnLike setImage:[UIImage imageNamed:@"SocialActivityDetailDislikeButton.png"] forState:UIControlStateNormal];
    }else {
        [_btnLike setImage:[UIImage imageNamed:@"SocialActivityDetailLikeButton.png"] forState:UIControlStateNormal];
    }
    
}

- (void)setContent:(NSString*)strLikes
{
    _lbMessage.text = strLikes;
}

- (void)setSocialActivityDetails:(SocialActivity *)socialActivityDetails
{
    _socialActivityDetails = [socialActivityDetails retain];
    [_btnLike addTarget:self action:@selector(btnLikeAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUserProfile:(SocialUserProfile*)socialUserProfile
{
    _socialUserProfile = [socialUserProfile retain];
}

-(void)btnLikeAction:(UIButton *)sender
{
    if([_delegate respondsToSelector:@selector(likeDislikeActivity:)])
        [_delegate likeDislikeActivity:_socialActivityDetails.identityId];
    
}

@end
