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
#import "ActivityHelper.h"



@implementation ActivityBasicTableViewCell

@synthesize lbDate=_lbDate, lbName=_lbName, imgvAvatar=_imgvAvatar, imgType = _imgType;
@synthesize btnLike = _btnLike, btnComment = _btnComment, imgvMessageBg=_imgvMessageBg, socialActivytyStream = _socialActivytyStream, delegate = _delegate;
@synthesize activityType = _activityType;
@synthesize htmlMessage = _htmlMessage;

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
    
    self.lbDate = nil;
    self.lbName = nil;
    
    self.imgvAvatar = nil;
    self.btnLike = nil;
    self.btnComment = nil;
    
    self.imgvMessageBg = nil;
    
    [_htmlMessage release];
    _htmlMessage = nil;
    
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
}


- (void)configureFonts:(BOOL)highlighted {
    
    if (!highlighted) {
        _lbName.textColor = [UIColor colorWithRed:22./255 green:124./255 blue:205./255 alpha:1.];
        _lbName.shadowOffset = CGSizeMake(0,1);
        _lbName.shadowColor = [UIColor whiteColor];
        _lbName.backgroundColor = [UIColor whiteColor];
    
        _htmlMessage.textColor = [UIColor grayColor];
        _htmlMessage.backgroundColor = [UIColor purpleColor];
 
        _lbDate.textColor = [UIColor colorWithRed:167./255 green:170./255 blue:174./255 alpha:1.];
        _lbDate.shadowOffset = CGSizeMake(0,1);
        _lbDate.shadowColor = [UIColor whiteColor];
        _lbDate.backgroundColor = [UIColor whiteColor];
    } else {
        
        _lbName.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];

        
        _htmlMessage.textColor = [UIColor darkGrayColor];
        _htmlMessage.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
        
        _lbDate.textColor = [UIColor colorWithRed:130./255 green:130./255 blue:130./255 alpha:1.];
        _lbDate.shadowOffset = CGSizeMake(0,0);
        _lbDate.shadowColor = [UIColor darkGrayColor];
        _lbDate.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
        
        
        
    }
    
    
}


- (void)configureCellForWidth:(CGFloat)fWidth {
    
    [self customizeAvatarDecorations];
    
    [self configureFonts:NO];
    
    //Add images for Background Message
    UIImage *strechBg = [[UIImage imageNamed:@"SocialActivityBrowserActivityBg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
    
    UIImage *strechBgSelected = [[UIImage imageNamed:@"SocialActivityBrowserActivityBgSelected.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
    
    _imgvMessageBg.image = strechBg;
    _imgvMessageBg.highlightedImage = strechBgSelected;
            
    //Add images for Comment button
    [_btnComment setBackgroundImage:[[UIImage imageNamed:@"SocialActivityBrowserCommentButton.png"] 
                                     stretchableImageWithLeftCapWidth:14 topCapHeight:0] 
                           forState:UIControlStateNormal];
    [_btnComment setBackgroundImage:[[UIImage imageNamed:@"SocialActivityBrowserCommentButtonSelected.png"] 
                                     stretchableImageWithLeftCapWidth:14 topCapHeight:0] 
                           forState:UIControlStateSelected];
    [_btnComment setBackgroundImage:[[UIImage imageNamed:@"SocialActivityBrowserCommentButtonSelected.png"] 
                                     stretchableImageWithLeftCapWidth:14 topCapHeight:0] 
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
    
    
    [self configureCellForSpecificContentWithWidth:fWidth];

    
}



- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth {

    CGRect tmpFrame = CGRectZero;
    
    if (fWidth > 320) {
        tmpFrame = CGRectMake(70, 38, WIDTH_FOR_CONTENT_IPAD, 21);
    } else {
        tmpFrame = CGRectMake(70, 38, WIDTH_FOR_CONTENT_IPHONE, 21);
    }
    
    _htmlMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];

    
    _htmlMessage.userInteractionEnabled = NO;
    _htmlMessage.autoresizesSubviews = YES;
    _htmlMessage.backgroundColor = [UIColor clearColor];
    _htmlMessage.font = [UIFont systemFontOfSize:13.0];
    _htmlMessage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _htmlMessage.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:_htmlMessage];
}









- (void)setSocialActivityStream:(SocialActivityStream*)socialActivityStream
{ 
    
    self.socialActivytyStream = socialActivityStream;
    
    _lbDate.text = [socialActivityStream.postedTimeInWords copy];
    
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
    
    
    [self setSocialActivityStreamForSpecificContent:socialActivityStream];
}





- (void)setSocialActivityStreamForSpecificContent:(SocialActivityStream*)socialActivityStream {
 
    _htmlMessage.html = socialActivityStream.title;
    _lbName.text = [socialActivityStream.posterUserProfile.fullName copy];
    
    switch (socialActivityStream.activityType) {
        case ACTIVITY_ANSWER_UPDATE_QUESTION:
        case ACTIVITY_ANSWER_ADD_QUESTION:{
            _htmlMessage.html = [socialActivityStream.templateParams valueForKey:@"Name"];
        }
            
            break;
        default:
            break;
    }
}




@end
