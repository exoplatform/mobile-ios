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

#import "ActivityWikiTableViewCell.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "NSString+HTML.h"
#import "defines.h"

#define MAX_LENGTH 80

@implementation ActivityWikiTableViewCell

@synthesize lbMessage = _lbMessage;
@synthesize lbTitle = _lbTitle;

- (void)configureFonts:(BOOL)highlighted {
    
}



- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth {
    
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
    
    NSString *type = [socialActivityStream.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityStream.activityStream valueForKey:@"fullName"];
    }
    NSString * name = socialActivityStream.posterIdentity.fullName;
    switch (socialActivityStream.activityType) {
        case ACTIVITY_WIKI_MODIFY_PAGE:{
            name =  [NSString stringWithFormat:@"%@%@ %@",
                                         socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"",
                                         Localize(@"EditWiki")];
            
        }
            break;
        case ACTIVITY_WIKI_ADD_PAGE:
        {
            name =  [NSString stringWithFormat:@"%@%@ %@",
                                socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"",
                                Localize(@"CreateWiki")];
            
        }
            
            break; 
        default:
            break;
    }
    NSDictionary * attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    
    NSMutableAttributedString * attributedName = [[NSMutableAttributedString alloc] initWithString:name];
    [attributedName setAttributes:attributes range:NSMakeRange(socialActivityStream.posterIdentity.fullName.length, name.length-socialActivityStream.posterIdentity.fullName.length)];
    _lbName.attributedText = attributedName;
    
    _lbTitle.text =[[[socialActivityStream.templateParams valueForKey:@"page_name"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
    
    _lbMessage.text =  [[[socialActivityStream.templateParams valueForKey:@"page_exceprt"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
}



- (void)dealloc {
    
    _lbMessage = nil;
    
    _lbTitle = nil;
    
    
    
    [_lbTitle release];
    [_lbMessage release];
    [super dealloc];
}

@end
