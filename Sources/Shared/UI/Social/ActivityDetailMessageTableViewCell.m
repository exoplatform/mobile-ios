//
//  ActivityDetailMessageTableViewCell.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityDetailMessageTableViewCell.h"
#import "EGOImageView.h"
#import "MockSocial_Activity.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialActivityStream.h"
#import "SocialActivityDetails.h"

@implementation ActivityDetailMessageTableViewCell

@synthesize lbMessage=_lbMessage, lbDate=_lbDate, lbName=_lbName, imgvAvatar=_imgvAvatar;
@synthesize imgvMessageBg=_imgvMessageBg;

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    [_imgvMessageBg setHighlighted:selected];
}

- (void)dealloc
{
    
    self.lbMessage = nil;
    self.lbDate = nil;
    self.lbName = nil;
    
    self.imgvAvatar = nil;
    
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
    _imgvAvatar.placeholderImage = [UIImage imageNamed:@"default-avatar"];
    
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
    
    UIImage *strechBg = [[UIImage imageNamed:@"SocialActivityDetailMessageBg.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:60];
    
    UIImage *strechBgSelected = [[UIImage imageNamed:@"SocialActivityDetailMessageBg.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:60];
    
    _imgvMessageBg.image = strechBg;
    _imgvMessageBg.highlightedImage = strechBgSelected;
}


- (void)setSocialActivityDetail:(SocialActivityDetails*)socialActivityDetail andUserName:(NSString *)username;
{
    _lbMessage.text = [socialActivityDetail.title copy];
    _lbName.text = [username copy];
    _lbDate.text = [socialActivityDetail.postedTimeInWords copy];
}


@end
