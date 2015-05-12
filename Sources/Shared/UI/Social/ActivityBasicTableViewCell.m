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

#import "ActivityBasicTableViewCell.h"
#import "MockSocial_Activity.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialActivity.h"
#import "ActivityStreamBrowseViewController.h"
#import "SocialUserProfile.h"
#import "Three20/Three20.h"
#import "NSString+HTML.h"
#import "ActivityHelper.h"

@implementation ActivityBasicTableViewCell {
    float plfVersion;
}

@synthesize lbDate=_lbDate, lbName=_lbName, imgvAvatar=_imgvAvatar, imgType = _imgType,
btnLike = _btnLike, btnComment = _btnComment, imgvMessageBg=_imgvMessageBg,
socialActivytyStream = _socialActivytyStream, delegate = _delegate,
activityType = _activityType, htmlMessage = _htmlMessage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.imgvAvatar needToBeResizedForSize:CGSizeMake(45,45)];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];

    [self.imgvMessageBg setHighlighted:highlighted];
    [self.btnComment setHighlighted:highlighted];
    [self.btnLike setHighlighted:highlighted];
    [self configureFonts:highlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    [self.imgvMessageBg setHighlighted:selected];
    [self.btnComment setSelected:selected];
    [self.btnLike setSelected:selected];
    [self configureFonts:selected];

}

-(void)btnLikeAction:(UIButton *)sender
{
    [self.delegate likeDislikeActivity:self.socialActivytyStream.activityId
                                  like:self.socialActivytyStream.liked];
}


- (void)btnCommentAction:(UIButton *)sender 
{
    [self.delegate postACommentOnActivity:self.socialActivytyStream.activityId];
} 



- (void)dealloc
{
    self.imgvAvatar = nil;
    self.btnLike = nil;
    self.btnComment = nil;
    self.imgvMessageBg = nil;
    self.socialActivytyStream = nil;
    self.delegate = nil;
    self.imgType = nil;
    self.lbDate = nil;
    self.lbName = nil;
    self.htmlMessage = nil;
    self.activityType = nil;

    [super dealloc];
}


#pragma mark - Activity Cell methods 

- (void)customizeAvatarDecorations {

}


- (void)configureFonts:(BOOL)highlighted {
    
    if (!highlighted) {
        
        self.lbName.textColor = [UIColor colorWithRed:17./255 green:94./255 blue:173./255 alpha:1.];
        self.lbName.shadowOffset = CGSizeMake(0,1);
        self.lbName.shadowColor = [UIColor whiteColor];
        self.lbName.backgroundColor = [UIColor whiteColor];
    
        self.htmlMessage.textColor = [UIColor grayColor];
        self.htmlMessage.backgroundColor = [UIColor whiteColor];
 
        self.lbDate.textColor = [UIColor colorWithRed:167./255 green:170./255 blue:174./255 alpha:1.];
        self.lbDate.shadowOffset = CGSizeMake(0,1);
        self.lbDate.shadowColor = [UIColor whiteColor];
        self.lbDate.backgroundColor = [UIColor whiteColor];
        
    } else {
        
        self.lbName.backgroundColor = SELECTED_CELL_BG_COLOR;
        self.htmlMessage.textColor = [UIColor darkGrayColor];
        self.htmlMessage.backgroundColor = SELECTED_CELL_BG_COLOR;
        
        self.lbDate.textColor = [UIColor colorWithRed:130./255 green:130./255 blue:130./255 alpha:1.];
        self.lbDate.shadowOffset = CGSizeMake(0,0);
        self.lbDate.shadowColor = [UIColor darkGrayColor];
        self.lbDate.backgroundColor = SELECTED_CELL_BG_COLOR;
        
    }
}


- (void)configureCellForWidth:(CGFloat)fWidth {
    
    [self customizeAvatarDecorations];
    [self configureFonts:NO];
    
    //Add images for Background Message
    UIImage *strechBg = [[UIImage imageNamed:@"SocialActivityBrowserActivityBg.png"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake(22, 15, 15, 15)];
    
    UIImage *strechBgSelected = [[UIImage imageNamed:@"SocialActivityBrowserActivityBgSelected.png"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(22, 15, 15, 15)];
    
    self.imgvMessageBg.image = strechBg;
    self.imgvMessageBg.highlightedImage = strechBgSelected;
            
    //Add images for Comment button
    [self.btnComment setBackgroundImage:
     [[UIImage imageNamed:@"SocialActivityBrowserCommentButton.png"]
      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 4)]
                           forState:UIControlStateNormal];
    [self.btnComment setBackgroundImage:
     [[UIImage imageNamed:@"SocialActivityBrowserCommentButtonSelected.png"]
      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 4)]
                           forState:UIControlStateSelected];
    [self.btnComment setBackgroundImage:
     [[UIImage imageNamed:@"SocialActivityBrowserCommentButtonSelected.png"]
      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 4)]
                           forState:UIControlStateHighlighted];
    
    //Add images for Like button
    [self.btnLike setBackgroundImage:
     [[UIImage imageNamed:@"SocialActivityBrowserLikeButton.png"]
      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 5)]
                        forState:UIControlStateNormal];
    [self.btnLike setBackgroundImage:
     [[UIImage imageNamed:@"SocialActivityBrowserLikeButtonSelected.png"]
      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 5)]
                        forState:UIControlStateSelected];
    [self.btnLike setBackgroundImage:
     [[UIImage imageNamed:@"SocialActivityBrowserLikeButtonSelected.png"]
      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 5)]
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
    
    self.htmlMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    self.htmlMessage.userInteractionEnabled = NO;
    self.htmlMessage.autoresizesSubviews = YES;
    self.htmlMessage.font = [UIFont systemFontOfSize:13.0];
    self.htmlMessage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.htmlMessage.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:self.htmlMessage];
}

- (void)setSocialActivityStream:(SocialActivity *)socialActivityStream
{ 
    
    //Setting the avatar without starting the download to prevent troubles during scrolling
    [self.imgvAvatar setImageURLWithoutDownloading:[NSURL URLWithString:socialActivityStream.posterIdentity.avatarUrl]];
    
    self.socialActivytyStream = socialActivityStream;
    
    //On Platform 4.0 and + we display the updated time on the stream
    //Otherwise we display the posted time
    if(plfVersion >= 4.0)
        self.lbDate.text = [socialActivityStream.updatedTimeInWords copy];
    else
        self.lbDate.text = [socialActivityStream.postedTimeInWords copy];
    
    // LIKE BUTTON
    //display the like number '+' if 0
    NSString *stringForLikes;
    if (socialActivityStream.totalNumberOfLikes == 0) {
        stringForLikes = @"+";
    } else {
        stringForLikes = [NSString stringWithFormat:@"%d",socialActivityStream.totalNumberOfLikes];
    }
    [self.btnLike setTitle:stringForLikes forState:UIControlStateNormal];
    [self.btnLike addTarget:self action:@selector(btnLikeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //Set the size of the font in the button (to fit the width)
    if ([socialActivityStream.likedByIdentities count] >= 100) {
        self.btnLike.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:7];
    } else {
        self.btnLike.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10];
    }
    
    // COMMENT BUTTON
    //display the comment number '+' if 0
    NSString *stringForComments;
    if (socialActivityStream.totalNumberOfComments == 0) {
        stringForComments = @"+";
    } else {
        stringForComments = [NSString stringWithFormat:@"%d",socialActivityStream.totalNumberOfComments];
    }
    [self.btnComment setTitle:stringForComments forState:UIControlStateNormal];
    [self.btnComment addTarget:self action:@selector(btnCommentAction:) forControlEvents:UIControlEventTouchUpInside];

    //Set the size of the font in the button (to fit the width)
    if (socialActivityStream.totalNumberOfComments >= 100) {
        self.btnComment.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:7];
    } else {
        self.btnComment.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10];
    }
 
    [self setSocialActivityStreamForSpecificContent:socialActivityStream];
}


- (void)setPlatformVersion:(float)version {
    plfVersion = version;
}


- (void)setSocialActivityStreamForSpecificContent:(SocialActivity *)socialActivityStream {
 
    self.htmlMessage.html = socialActivityStream.title;
    self.lbName.text = [socialActivityStream.posterIdentity.fullName copy];
}

@end
