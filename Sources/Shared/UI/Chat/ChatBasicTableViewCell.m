//
//  ActivityBasicTableViewCell.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChatBasicTableViewCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation ChatBasicTableViewCell

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
    [_lbName release];    
    [_imgvAvatar release];
    
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
    
    /*
    //Add the inner shadow
    CALayer *innerShadowLayer = [CALayer layer];
    innerShadowLayer.contents = (id)[UIImage imageNamed: @"ActivityAvatarShadow.png"].CGImage;
    innerShadowLayer.contentsCenter = CGRectMake(10.0f/21.0f, 10.0f/21.0f, 1.0f/21.0f, 1.0f/21.0f);
    innerShadowLayer.frame = CGRectMake(borderWidth,borderWidth,_imgvAvatar.frame.size.width-2*borderWidth, _imgvAvatar.frame.size.height-2*borderWidth);
    [_imgvAvatar.layer addSublayer:innerShadowLayer];
//    _imgvAvatar.placeholderImage = [UIImage imageNamed:@"default-avatar"];
     */
}


- (void)configureFonts {
    
    _lbName.textColor = [UIColor darkGrayColor];
    self.backgroundColor = [UIColor lightGrayColor];
    
//    _lbName.shadowOffset = CGSizeMake(0,1);
//    _lbName.shadowColor = [UIColor brownColor];
    
}


- (void)configureCell {
    
//    [self customizeAvatarDecorations];

    [self configureFonts];
    
}

- (void)setChatUser:(XMPPUser *)chatUser
{
    UIImage *imgAvatar = nil;
    
    if([chatUser isOnline])
	{	
//		_lbName.textColor = [UIColor blueColor];
		imgAvatar = [UIImage imageNamed:@"ChatContactAvailable"];
	}
	else
	{
//		_lbName.textColor = [UIColor blackColor];
		imgAvatar = [UIImage imageNamed:@"ChatContactNotAvailable"];
	}
    
    CGSize imageSize = imgAvatar.size;
    _imgvAvatar.frame = CGRectMake(5, 0, imageSize.width, imageSize.height);
    _imgvAvatar.center = CGPointMake(_imgvAvatar.center.x, self.center.y);
    _imgvAvatar.image = imgAvatar;
    
    CGRect userNameTextFrame = _lbName.frame;
    userNameTextFrame.origin.x = _imgvAvatar.frame.origin.x + _imgvAvatar.frame.size.width + 10;
    
    _lbName.frame = userNameTextFrame;
    _lbName.center = CGPointMake(_lbName.center.x, self.center.y);
    _lbName.text = [chatUser nickname];
}

@end
