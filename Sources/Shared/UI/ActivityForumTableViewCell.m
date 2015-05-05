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

#import "ActivityForumTableViewCell.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "NSString+HTML.h"
#import "defines.h"

@implementation ActivityForumTableViewCell

@synthesize lbMessage = _lbMessage;
@synthesize lbTitle = _lbTitle;

/*
- (void)configureFonts:(BOOL)highlighted {
    
    if (!highlighted) {
        _htmlName.textColor = [UIColor grayColor];
        _htmlName.backgroundColor = [UIColor whiteColor];
        
        _lbMessage.textColor = [UIColor grayColor];
        _lbMessage.backgroundColor = [UIColor whiteColor];
        
        
        _lbTitle.textColor = [UIColor grayColor];
        _lbTitle.backgroundColor = [UIColor whiteColor];
    } else {
        _htmlName.textColor = [UIColor darkGrayColor];
        _htmlName.backgroundColor = SELECTED_CELL_BG_COLOR;
        
        _lbMessage.textColor = [UIColor darkGrayColor];
        _lbMessage.backgroundColor = SELECTED_CELL_BG_COLOR;
        
        _lbTitle.textColor = [UIColor darkGrayColor];
        _lbTitle.backgroundColor = SELECTED_CELL_BG_COLOR;
    }
    
    [super configureFonts:highlighted];
}


- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth {
    
    CGRect tmpFrame = CGRectZero;
    
    if (fWidth > 320) {
        tmpFrame = CGRectMake(70, 14, WIDTH_FOR_CONTENT_IPAD, 21);
    } else {
        tmpFrame = CGRectMake(70, 14, WIDTH_FOR_CONTENT_IPHONE, 21);
    }
    
    //Use an html styled label to display informations about the author of the wiki page
    _htmlName = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlName.userInteractionEnabled = NO;
    _htmlName.backgroundColor = [UIColor clearColor];
    _htmlName.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:_htmlName];
    
    //Use an html styled label to display informations about the author of the wiki page
    _lbTitle = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _lbTitle.userInteractionEnabled = NO;
    _lbTitle.backgroundColor = [UIColor clearColor];
    _lbTitle.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:_lbTitle];
    
    _lbMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _lbMessage.userInteractionEnabled = NO;
    _lbMessage.backgroundColor = [UIColor clearColor];
    _lbMessage.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:_lbMessage];
}
*/


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
    
    
    NSString *type = [socialActivityStream.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityStream.activityStream valueForKey:@"fullName"];
    }
    
    NSString * name = socialActivityStream.posterIdentity.fullName;
    NSString * title = nil;
    switch (socialActivityStream.activityType) {
        case ACTIVITY_FORUM_CREATE_POST:
            name = [NSString stringWithFormat:@"%@%@ %@", socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"NewPost")];
            title = [socialActivityStream.templateParams valueForKey:@"PostName"];
            break;
        case ACTIVITY_FORUM_CREATE_TOPIC:
            name = [NSString stringWithFormat:@"%@%@ %@", socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"NewTopic")];
            
            float plfVersion = [[[NSUserDefaults standardUserDefaults] stringForKey:EXO_PREFERENCE_VERSION_SERVER] floatValue];
            
            if(plfVersion >= 4.0) { // plf 4 and later: TopicName is not in template params, it is title of socialActivityStream
                title = socialActivityStream.title;
            } else {
                title = [socialActivityStream.templateParams valueForKey:@"TopicName" ];
            }
            
            break;
        case ACTIVITY_FORUM_UPDATE_TOPIC:
            name = [NSString stringWithFormat:@"%@%@ %@", socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"UpdateTopic")];
            title = [[[socialActivityStream.templateParams valueForKey:@"TopicName"] stringByEncodeWithHTML] stringByConvertingHTMLToPlainText];
            break; 
        case ACTIVITY_FORUM_UPDATE_POST:
            name = [NSString stringWithFormat:@"%@%@ %@", socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"UpdatePost")];
            title = [[[socialActivityStream.templateParams valueForKey:@"PostName"] stringByEncodeWithHTML] stringByConvertingHTMLToPlainText];
            break; 
        default:
            break;
    }
    
    NSDictionary * attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    
    NSMutableAttributedString * attributedName = [[NSMutableAttributedString alloc] initWithString:name];
    [attributedName setAttributes:attributes range:NSMakeRange(socialActivityStream.posterIdentity.fullName.length, name.length-socialActivityStream.posterIdentity.fullName.length)];
    _lbName.attributedText = attributedName;
    
    _lbTitle.text = title;

    _lbMessage.text = [socialActivityStream.body stringByConvertingHTMLToPlainText];

}


- (void)dealloc {
    
    _lbMessage = nil;
    
    [super dealloc];
}


@end
