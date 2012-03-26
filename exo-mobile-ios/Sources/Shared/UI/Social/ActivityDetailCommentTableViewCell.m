//
//  ActivityDetailCommentTableViewCell.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityDetailCommentTableViewCell.h"
#import "EGOImageView.h"
#import "MockSocial_Activity.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialComment.h"
#import "defines.h"


@implementation ActivityDetailCommentTableViewCell

@synthesize lbMessage=_lbMessage, lbDate=_lbDate, lbName=_lbName, imgvAvatar=_imgvAvatar;
@synthesize imgvMessageBg=_imgvMessageBg;
@synthesize imgvCellBg = _imgvCellBg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [_imgvAvatar needToBeResizedForSize:CGSizeMake(45,45)];
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
    self.imgvCellBg = nil;
    
    [super dealloc];
}


#pragma mark - Activity Cell methods 

- (void)customizeAvatarDecorations {
    //Add the CornerRadius
    [[_imgvAvatar layer] setCornerRadius:6.0];
    [[_imgvAvatar layer] setMasksToBounds:YES];
    
    //Add the border
    [[_imgvAvatar layer] setBorderColor:[UIColor colorWithRed:113./255 green:113./255 blue:113./255 alpha:1.].CGColor];
    CGFloat borderWidth = 1.0;
    [[_imgvAvatar layer] setBorderWidth:borderWidth];
    _imgvAvatar.placeholderImage = [UIImage imageNamed:@"default-avatar"];
    
    //Add the inner shadow
    /*CALayer *innerShadowLayer = [CALayer layer];
    innerShadowLayer.contents = (id)[UIImage imageNamed: @"ActivityAvatarShadow.png"].CGImage;
    innerShadowLayer.contentsCenter = CGRectMake(10.0f/21.0f, 10.0f/21.0f, 1.0f/21.0f, 1.0f/21.0f);
    innerShadowLayer.frame = CGRectMake(borderWidth,borderWidth,_imgvAvatar.frame.size.width-2*borderWidth, _imgvAvatar.frame.size.height-2*borderWidth);
    [_imgvAvatar.layer addSublayer:innerShadowLayer];*/
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
    
    htmlLabel = [[[TTStyledTextLabel alloc] initWithFrame:_lbMessage.frame] autorelease];
    htmlLabel.userInteractionEnabled = NO;
    htmlLabel.backgroundColor = [UIColor clearColor];
    htmlLabel.font = [UIFont systemFontOfSize:13.0];
    htmlLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    htmlLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:htmlLabel];

    
}


- (void)setSocialComment:(SocialComment*)socialComment
{
    NSString* tmp = socialComment.userProfile.avatarUrl;
    NSString* domainName = [(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_DOMAIN] copy];
    NSRange rang = [tmp rangeOfString:domainName];
    if (rang.length == 0) 
    {
        tmp = [NSString stringWithFormat:@"%@%@",domainName,tmp];
    }
    
    
    _imgvAvatar.imageURL = [NSURL URLWithString:tmp];    
    _lbMessage.text = @"";
    htmlLabel.html = [socialComment.text copy];
    _lbName.text = [socialComment.userProfile.fullName copy];
    _lbDate.text = [socialComment.postedTimeInWords copy];
}


@end
 
