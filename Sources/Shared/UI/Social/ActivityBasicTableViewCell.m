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

@synthesize lbDate=_lbDate, lbName=_lbName, imgvAvatar=_imgvAvatar, imgType = _imgType;
@synthesize btnLike = _btnLike, btnComment = _btnComment, imgvMessageBg=_imgvMessageBg, socialActivytyStream = _socialActivytyStream, delegate = _delegate;
@synthesize activityType = _activityType;
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
    
    [_message release];
    [super dealloc];
}


#pragma mark - Activity Cell methods 

- (void)customizeAvatarDecorations {

}

- (void)configureFonts:(BOOL)highlighted {
    
    if (!highlighted) {
        _lbName.textColor = [UIColor colorWithRed:17./255 green:94./255 blue:173./255 alpha:1.];
        _lbName.shadowOffset = CGSizeMake(0,1);
        _lbName.shadowColor = [UIColor whiteColor];
        _lbName.backgroundColor = [UIColor whiteColor];
     
        _lbDate.textColor = [UIColor colorWithRed:167./255 green:170./255 blue:174./255 alpha:1.];
        _lbDate.shadowOffset = CGSizeMake(0,1);
        _lbDate.shadowColor = [UIColor whiteColor];
        _lbDate.backgroundColor = [UIColor whiteColor];
    } else {
        
        _lbName.backgroundColor = SELECTED_CELL_BG_COLOR;
        
        _lbDate.textColor = [UIColor colorWithRed:130./255 green:130./255 blue:130./255 alpha:1.];
        _lbDate.shadowOffset = CGSizeMake(0,0);
        _lbDate.shadowColor = [UIColor darkGrayColor];
        _lbDate.backgroundColor = SELECTED_CELL_BG_COLOR;
        
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
    
}

- (void)setSocialActivityStream:(SocialActivity *)socialActivityStream
{ 
    
    //Setting the avatar without starting the download to prevent troubles during scrolling
    [_imgvAvatar setImageURLWithoutDownloading:[NSURL URLWithString:socialActivityStream.posterIdentity.avatarUrl]];
    
    self.socialActivytyStream = socialActivityStream;
    
    //On Platform 4.0 and + we display the updated time on the stream
    //Otherwise we display the posted time
    if(plfVersion >= 4.0)
        _lbDate.text = [socialActivityStream.updatedTimeInWords copy];
    else
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


- (void)setPlatformVersion:(float)version {
    plfVersion = version;
}

-(void) backgroundConfiguration {
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
    
    
}


- (void)setSocialActivityStreamForSpecificContent:(SocialActivity *)socialActivityStream {
    [self backgroundConfiguration];
    

    _message.attributedText = socialActivityStream.attributedMessage;
    
    _lbName.text = [socialActivityStream.posterIdentity.fullName copy];
}




@end
