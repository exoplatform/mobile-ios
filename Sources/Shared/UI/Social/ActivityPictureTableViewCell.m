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

#import "ActivityPictureTableViewCell.h"
#import "SocialActivity.h"
#import "EGOImageView.h"
#import "defines.h"
#import "NSString+HTML.h"
#import "ActivityHelper.h"
#import "ApplicationPreferencesManager.h"

#define MAX_HEIGHT_FILE_NAME 32

@implementation ActivityPictureTableViewCell

@synthesize imgvAttach = _imgvAttach, urlForAttachment = _urlForAttachment, lbFileName = _lbFileName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
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
    //Set the UserName of the activity
    NSString *type = [socialActivityStream.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityStream.activityStream valueForKey:@"fullName"];
    }
    

    NSString *title = [NSString stringWithFormat:@"%@%@", [socialActivityStream.posterIdentity.fullName copy], space ? [NSString stringWithFormat:@" in %@ space", space] : @""];
    
    _lbName.text = title;
    
   

    switch (socialActivityStream.activityType) {
        case ACTIVITY_DOC:{
            NSString * message  = [[[socialActivityStream.templateParams valueForKey:@"MESSAGE"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
            
            self.activityMessage.text = message?message:@"";
            
            _lbFileName.text = [socialActivityStream.templateParams valueForKey:@"DOCNAME"];

            self.imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForPlaceholderImage.png"];
            
            NSString *imagePath = [socialActivityStream.templateParams valueForKey:@"DOCLINK"];
            // Using the thumbnail image instead of real one. Suppose that the image path format is "/{rest context name}/jcr/{relative path}"
            // The link for thumbnail image is in the format "/{rest context name}/thumbnailImage/large/{relative path}"
            NSRange range = [imagePath rangeOfString:@"jcr"];
            if (range.location != NSNotFound) {
                imagePath = [imagePath substringFromIndex:range.location + range.length];
                imagePath = [NSString stringWithFormat:@"/rest/thumbnailImage/large%@", imagePath];
            }
            NSString *strURL = [NSString stringWithFormat:@"%@%@", [ApplicationPreferencesManager sharedInstance].selectedDomain, imagePath];
            
            _urlForAttachment = [[NSURL alloc] initWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; 
            

        }
            break;
        case ACTIVITY_CONTENTS_SPACE:{
            
            float plfVersion = [[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_VERSION_SERVER] floatValue];
            NSString * message;
            
            if(plfVersion >= 4.0) { // in plf 4, no state in template params.
                
                message = [NSString stringWithFormat:@"%@ was created by %@", [socialActivityStream.templateParams valueForKey:@"contentName"], [socialActivityStream.templateParams valueForKey:@"author"]];

            } else {
                message = [NSString stringWithFormat:@"%@ was created by %@ state: %@", [socialActivityStream.templateParams valueForKey:@"contentName"], [socialActivityStream.templateParams valueForKey:@"author"], [socialActivityStream.templateParams valueForKey:@"state"]];
            }
            if (message){
                NSMutableAttributedString * attributedMessage = [[NSMutableAttributedString alloc] initWithString:message];
                NSDictionary * attribute =@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Bold" size:14], NSForegroundColorAttributeName:[UIColor blackColor]};
                
                [attributedMessage setAttributes:attribute range:[message rangeOfString:[socialActivityStream.templateParams valueForKey:@"contentName"]]];
                [attributedMessage setAttributes:attribute range:[message rangeOfString:[socialActivityStream.templateParams valueForKey:@"author"]]];
   
                if(plfVersion < 4.0) {
                 [attributedMessage setAttributes:attribute range:[message rangeOfString:[socialActivityStream.templateParams valueForKey:@"state"]]];
                }
                
                self.activityMessage.attributedText = attributedMessage;
            } else {
                self.activityMessage.text = @"";
            }
            
            _lbFileName.text = @"";
            if ([[socialActivityStream.templateParams valueForKey:@"mimeType"] rangeOfString:@"image"].location != NSNotFound) {
                self.imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForPlaceholderImage.png"];
            } else {
                self.imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForUnreadableFile.png"];
            }
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            // The link for thumbnail image is in the format "/{rest context name}/thumbnailImage/large/{relative path}"
            NSString *strURL = [NSString stringWithFormat:@"%@/rest/thumbnailImage/large/%@", [userDefaults valueForKey:EXO_PREFERENCE_DOMAIN], [socialActivityStream.templateParams valueForKey:@"contenLink"]];
            
            _urlForAttachment = [[NSURL alloc] initWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; 
            
        }
            break;
    }
}


- (void)startLoadingImageAttached {
    self.imgvAttach.imageURL = self.urlForAttachment;
}


- (void)resetImageAttached {
    self.imgvAttach.imageURL = nil;
}

- (void)dealloc
{
    [_urlForAttachment release];
    _urlForAttachment = nil;
    
    [_activityMessage release];
    [super dealloc];
}

@end
