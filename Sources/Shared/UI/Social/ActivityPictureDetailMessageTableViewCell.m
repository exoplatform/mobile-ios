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

#import "ActivityPictureDetailMessageTableViewCell.h"
#import "SocialActivity.h"
#import "EGOImageView.h"
#import "defines.h"
#import "ActivityHelper.h"
#import "NSString+HTML.h"

#define MAX_HEIGHT_FILE_NAME 32

@implementation ActivityPictureDetailMessageTableViewCell

@synthesize lbFileName = _lbFileName;


- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth{
    CGRect tmpFrame = CGRectZero;
    
    if (fWidth > 320) {
        tmpFrame = CGRectMake(67, 14, WIDTH_FOR_CONTENT_IPAD, 21);
        width = WIDTH_FOR_CONTENT_IPAD;
    } else {
        tmpFrame = CGRectMake(67, 14, WIDTH_FOR_CONTENT_IPHONE, 21);
        width = WIDTH_FOR_CONTENT_IPHONE;
    }
    
    _lbFileName.textAlignment = UITextAlignmentCenter;
    _lbFileName.userInteractionEnabled = NO;
    _lbFileName.backgroundColor = [UIColor clearColor];
    _lbFileName.font = [UIFont systemFontOfSize:13.0];
    _lbFileName.textColor = [UIColor grayColor];
    _lbFileName.numberOfLines = 2;
}


- (void)setSocialActivityDetail:(SocialActivity *)socialActivityDetail{
    [super setSocialActivityDetail:socialActivityDetail];
    
    NSString *type = [socialActivityDetail.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityDetail.activityStream valueForKey:@"fullName"];
    }
    
    
    NSString *title = [NSString stringWithFormat:@"%@%@", [socialActivityDetail.posterIdentity.fullName copy], space ? [NSString stringWithFormat:@" in %@ space", space] : @""];
    
    _lbName.text = title;
    
    _imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForPlaceholderImage.png"];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    float plfVersion = [[userDefault valueForKey:EXO_PREFERENCE_VERSION_SERVER] floatValue];

    NSString *message = nil;
    NSDictionary *_templateParams = self.socialActivity.templateParams;
    switch (self.socialActivity.activityType) {
        case ACTIVITY_DOC:{
            NSString *imgPath = [_templateParams valueForKey:@"DOCLINK"];
            // Using the thumbnail image instead of real one. Suppose that the image path format is "/{rest context name}/jcr/{relative path}"
            // The link for thumbnail image is in the format "/{rest context name}/thumbnailImage/large/{relative path}"
            NSRange range = [imgPath rangeOfString:@"jcr"];
            if (range.location != NSNotFound) {
                imgPath = [imgPath substringFromIndex:(range.location + range.length)];
                imgPath = [NSString stringWithFormat:@"/rest/thumbnailImage/large%@", imgPath];
            }
            _imgvAttach.imageURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@", [userDefault valueForKey:EXO_PREFERENCE_DOMAIN],  imgPath] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            message = [NSString stringWithFormat:@"%@", [_templateParams valueForKey:@"MESSAGE"]];
            self.lbMessage.text = message;
            
            _lbFileName.text = [_templateParams valueForKey:@"DOCNAME"];
        }
            break;
        case ACTIVITY_CONTENTS_SPACE:{
            // check the mimetype of the document
            if ([[_templateParams valueForKey:@"mimeType"] rangeOfString:@"image"].location != NSNotFound) {
                self.imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForPlaceholderImage.png"];
            } else {
                self.imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForUnreadableFile.png"];
            }
            
            // Using the thumbnail image instead of real one. Suppose that value format of contentLink is "/{repository name}/{workspace name}/{relative path}"
            // The link for thumbnail image is in the format "/{rest context name}/thumbnailImage/large/{relative path}"
            _imgvAttach.imageURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@", [userDefault valueForKey:EXO_PREFERENCE_DOMAIN], [NSString stringWithFormat:@"/rest/thumbnailImage/large/%@", [_templateParams valueForKey:@"contenLink"]]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
             
            float plfVersion = [[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_VERSION_SERVER] floatValue];
            NSString * message;
            
            if(plfVersion >= 4.0) { // in plf 4, no state in template params.
                
                message = [NSString stringWithFormat:@"%@ was created by %@", [_templateParams valueForKey:@"contentName"], [_templateParams valueForKey:@"author"]];
                
            } else {
                message = [NSString stringWithFormat:@"%@ was created by %@ state: %@", [_templateParams valueForKey:@"contentName"], [_templateParams valueForKey:@"author"], [_templateParams valueForKey:@"state"]];
            }
            
            _lbFileName.text = @"";

            if (message){
                NSMutableAttributedString * attributedMessage = [[NSMutableAttributedString alloc] initWithString:message];
                NSDictionary * attribute =@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Bold" size:14], NSForegroundColorAttributeName:[UIColor blackColor]};
                
                [attributedMessage setAttributes:attribute range:[message rangeOfString:[socialActivityDetail.templateParams valueForKey:@"contentName"]]];
                [attributedMessage setAttributes:attribute range:[message rangeOfString:[socialActivityDetail.templateParams valueForKey:@"author"]]];
                
                if(plfVersion < 4.0) {
                    [attributedMessage setAttributes:attribute range:[message rangeOfString:[socialActivityDetail.templateParams valueForKey:@"state"]]];
                }
                
                self.lbMessage.attributedText = attributedMessage;
            } else {
                self.lbMessage.text = @"";
            }
        }
            break;
    }
    


    
}

@end
