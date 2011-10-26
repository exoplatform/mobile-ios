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
#import "SocialActivityStream.h"
#import "ActivityStreamBrowseViewController.h"
#import "SocialUserProfile.h"
#import "Three20/Three20.h"
#import "NSString+HTML.h"

@interface ActivityBasicTableViewCell (PrivateMethods)
- (void)configureFonts:(BOOL)highlighted;
@end

@implementation ActivityBasicTableViewCell

@synthesize lbMessage=_lbMessage, lbDate=_lbDate, lbName=_lbName, imgvAvatar=_imgvAvatar, imgType = _imgType;
@synthesize btnLike = _btnLike, btnComment = _btnComment, imgvMessageBg=_imgvMessageBg, socialActivytyStream = _socialActivytyStream, delegate = _delegate;

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
    
    [self configureFonts:highlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    [_imgvMessageBg setHighlighted:selected];
    [_btnComment setSelected:selected];
    [_btnLike setSelected:selected];
    [self configureFonts:selected];

}

-(void)btnLikeAction:(UIButton *)sender
{
    [_delegate likeDislikeActivity:_socialActivytyStream.activityId like:_socialActivytyStream.liked];
}


- (void)btnCommentAction:(UIButton *)sender 
{
    [_delegate postACommentOnActivity:_socialActivytyStream.activityId];
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
    [[_imgvAvatar layer] setBorderColor:[UIColor colorWithRed:113./255 green:113./255 blue:113./255 alpha:1.].CGColor];
    CGFloat borderWidth = 1.0;
    [[_imgvAvatar layer] setBorderWidth:borderWidth];
    
    //Add the inner shadow
    /*CALayer *innerShadowLayer = [CALayer layer];
    innerShadowLayer.contents = (id)[UIImage imageNamed: @"ActivityAvatarShadow.png"].CGImage;
    innerShadowLayer.contentsCenter = CGRectMake(10.0f/21.0f, 10.0f/21.0f, 1.0f/21.0f, 1.0f/21.0f);
    innerShadowLayer.frame = CGRectMake(borderWidth,borderWidth,_imgvAvatar.frame.size.width-2*borderWidth, _imgvAvatar.frame.size.height-2*borderWidth);
    [_imgvAvatar.layer addSublayer:innerShadowLayer];*/
    _imgvAvatar.placeholderImage = [UIImage imageNamed:@"default-avatar"];
}


- (void)configureFonts:(BOOL)highlighted {
    
    if (!highlighted) {
        _lbName.textColor = [UIColor colorWithRed:22./255 green:124./255 blue:205./255 alpha:1.];
        _lbName.shadowOffset = CGSizeMake(0,1);
        _lbName.shadowColor = [UIColor whiteColor];
    
        htmlLabel.textColor = [UIColor grayColor];

 
        _lbDate.textColor = [UIColor colorWithRed:167./255 green:170./255 blue:174./255 alpha:1.];
        _lbDate.shadowOffset = CGSizeMake(0,1);
        _lbDate.shadowColor = [UIColor whiteColor];
    } else {
        //_lbName.textColor = [UIColor colorWithRed:22./255 green:124./255 blue:205./255 alpha:1.];
        //_lbName.textColor = [UIColor whiteColor];
        //_lbName.shadowOffset = CGSizeMake(0,1);
        //_lbName.shadowColor = [UIColor darkGrayColor];
        
        htmlLabel.textColor = [UIColor darkGrayColor];

        
        _lbDate.textColor = [UIColor colorWithRed:130./255 green:130./255 blue:130./255 alpha:1.];
        _lbDate.shadowOffset = CGSizeMake(0,0);
        _lbDate.shadowColor = [UIColor darkGrayColor];
    }
    
    
}


- (void)configureCell {
    
    [self customizeAvatarDecorations];
    
    [self configureFonts:NO];
    
    //Add images for Background Message
    UIImage *strechBg = [[UIImage imageNamed:@"SocialActivityBrowserActivityBg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
    
    UIImage *strechBgSelected = [[UIImage imageNamed:@"SocialActivityBrowserActivityBgSelected.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
    
    _imgvMessageBg.image = strechBg;
    _imgvMessageBg.highlightedImage = strechBgSelected;
    
    htmlLabel = [[[TTStyledTextLabel alloc] initWithFrame:_lbMessage.frame] autorelease];
    htmlLabel.userInteractionEnabled = NO;
    htmlLabel.backgroundColor = [UIColor clearColor];
    htmlLabel.font = [UIFont systemFontOfSize:13.0];
    htmlLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;// | 
//        UIViewAutoresizingFlexibleBottomMargin |
//        UIViewAutoresizingFlexibleRightMargin ;
    htmlLabel.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:htmlLabel];
    
    
    
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


//- (void)setActivity:(Activity*)activity
- (void)setSocialActivityStream:(SocialActivityStream*)socialActivityStream
{
    //SonTH commented out
    //NSLog(@"%@",socialActivityStream.posterUserProfile.avatarUrl);
    _imgvAvatar.imageURL = [NSURL URLWithString:socialActivityStream.posterUserProfile.avatarUrl]; 
    htmlLabel.html = socialActivityStream.title;

    //htmlLabel.text = [TTStyledText textFromXHTML:socialActivityStream.title];
    //htmlLabel.backgroundColor = [UIColor redColor];


    _lbMessage.text = @"";//socialActivityStream.title;
    //TTStyledTextLabel
    
    //_lbMessage.text = [socialActivityStream.title copy];
    _lbDate.text = [socialActivityStream.postedTimeInWords copy];
    _lbName.text = [socialActivityStream.posterUserProfile.fullName copy];
    
    //display the like number '+' if 0
    NSString *stringForLikes;
    if (socialActivityStream.totalNumberOfLikes == 0) {
        stringForLikes = @"+";
    } else {
        stringForLikes = [NSString stringWithFormat:@"%d",socialActivityStream.totalNumberOfLikes];
    }
    [_btnLike setTitle:stringForLikes forState:UIControlStateNormal];
    
    //Set the size of the font in the button (to fit the width)
    if ([socialActivityStream.likedByIdentities count] >= 100) {
        _btnLike.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:7];
    } else {
        _btnLike.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10];
    }
    
    //display the comment number '+' if 0
    NSString *stringForComments;
    if (socialActivityStream.totalNumberOfComments == 0) {
        stringForComments = @"+";
    } else {
        stringForComments = [NSString stringWithFormat:@"%d",socialActivityStream.totalNumberOfComments];
    }
    [_btnComment setTitle:stringForComments forState:UIControlStateNormal];
    [_btnComment addTarget:self action:@selector(btnCommentAction:) forControlEvents:UIControlEventTouchUpInside];

    

    //Set the size of the font in the button (to fit the width)
    if (socialActivityStream.totalNumberOfComments >= 100) {
        _btnComment.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:7];
    } else {
        _btnComment.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10];
    }
 
     [_btnLike addTarget:self action:@selector(btnLikeAction:) forControlEvents:UIControlEventTouchUpInside];
}



@end
