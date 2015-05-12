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

#define MAX_HEIGHT_FILE_NAME    32
#define LEFT_PADDING            70
#define LINE_DEFAULT_PADDING    5

@implementation ActivityPictureTableViewCell

@synthesize imgvAttach = _imgvAttach, urlForAttachment = _urlForAttachment, lbFileName = _lbFileName;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        [_imgvAttach needToBeResizedForSize:CGSizeMake(45,45)];
        
    }
    return self;
}


- (void)configureFonts:(BOOL)highlighted {
    
    if (!highlighted) {
        _lbFileName.textColor = [UIColor grayColor];
        _lbFileName.backgroundColor = [UIColor whiteColor];
        
    } else {
        _lbFileName.textColor = [UIColor darkGrayColor];
        _lbFileName.backgroundColor = SELECTED_CELL_BG_COLOR;
        
    }
    
    [super configureFonts:highlighted];
}

- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth {
    
    CGRect tmpFrame = CGRectZero;
    if (fWidth > 320) {
        tmpFrame = CGRectMake(70, 14, WIDTH_FOR_CONTENT_IPAD, 21);
        width = WIDTH_FOR_CONTENT_IPAD;
    } else {
        tmpFrame = CGRectMake(70, 14, WIDTH_FOR_CONTENT_IPHONE, 21);
        width = WIDTH_FOR_CONTENT_IPHONE;
    }
    
    _lbFileName.textAlignment = NSTextAlignmentCenter;
    _lbFileName.userInteractionEnabled = NO;
    _lbFileName.backgroundColor = [UIColor clearColor];
    _lbFileName.font = [UIFont systemFontOfSize:14.0];
    _lbFileName.textColor = [UIColor grayColor];
    _lbFileName.numberOfLines = 2;
    
    
    self.htmlMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    self.htmlMessage.userInteractionEnabled = NO;
    self.htmlMessage.font = [UIFont systemFontOfSize:14.0];
    self.htmlMessage.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.htmlMessage];
}

- (void)setSocialActivityStreamForSpecificContent:(SocialActivity *)socialActivityStream {
    //Set the UserName of the activity
    NSString *type = [socialActivityStream.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityStream.activityStream valueForKey:@"fullName"];
    }
        
    NSString *title = [NSString stringWithFormat:@"%@%@", [socialActivityStream.posterIdentity.fullName copy], space ? [NSString stringWithFormat:@" in %@ space", space] : @""];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize theSize = [title boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                         options:nil
                                      attributes:@{
                                                   NSFontAttributeName: kFontForTitle,
                                                   NSParagraphStyleAttributeName: style
                                                   }
                                         context:nil].size;
    CGRect nameFrame = self.lbName.frame;
    nameFrame.size.height = ceil(theSize.height + 5);
    
    self.lbName.text = title;

   
    NSString *html = nil;
    switch (socialActivityStream.activityType) {
        case ACTIVITY_DOC:{
            html = [[[socialActivityStream.templateParams valueForKey:@"MESSAGE"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
            
            self.htmlMessage.html = html?html:@"";
            [self.htmlMessage sizeToFit];
            
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
            
            
            /**/
            

        }
            break;
        case ACTIVITY_CONTENTS_SPACE:{
            
            float plfVersion = [[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_VERSION_SERVER] floatValue];
            if(plfVersion >= 4.0) { // in plf 4, no state in template params.
                html = [NSString stringWithFormat:@"<a>%@</a> was created by <a>%@</a>", [socialActivityStream.templateParams valueForKey:@"contentName"], [socialActivityStream.templateParams valueForKey:@"author"]];
            } else {
                html = [NSString stringWithFormat:@"<a>%@</a> was created by <a>%@</a> state: %@", [socialActivityStream.templateParams valueForKey:@"contentName"], [socialActivityStream.templateParams valueForKey:@"author"], [socialActivityStream.templateParams valueForKey:@"state"]];
            }
            
            self.htmlMessage.html = [NSString stringWithFormat:@"<p>%@</p>", html?html:@""];
            [self.htmlMessage sizeToFit];
            
            _lbFileName.text = @"";
            [_lbFileName sizeToFit];
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
    
    //Set the position of lbMessage
    /*
     Cell Structure:
     - Avatar: all left side until 55 px
     On the Right Side:
     1. Name's Label: from 5px to the top, height default (22px)
     2. HTML Message: next under Name, height to be estime
     3. Image View.
     4. Image name's label: under the image view, height to be estime
     5. Tool View (time, like, comment button): 40px from the buttom, height 28px.
     */
    float cellHeight = [ActivityHelper getHeightForActivityCell:socialActivityStream forTableViewWidth:width];
    
    
    //Set the position of Title
    double heigthForTTLabel = [[[self htmlMessage] text] height];
    if (heigthForTTLabel > EXO_MAX_HEIGHT){
        heigthForTTLabel = EXO_MAX_HEIGHT;
    }
    
    CGRect htmlMessageFrame = self.htmlMessage.frame;
    htmlMessageFrame.origin.x =  LEFT_PADDING;
    htmlMessageFrame.origin.y =  nameFrame.origin.y + nameFrame.size.height + LINE_DEFAULT_PADDING;
    htmlMessageFrame.size.width =  width;
    htmlMessageFrame.size.height = heigthForTTLabel+5;
    
    
    // estime Image Name Label frame from the buttom.
    
    CGSize nameFileLabelSize = [[socialActivityStream.templateParams valueForKey:@"DOCNAME"] sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)                                                                                          lineBreakMode:NSLineBreakByWordWrapping];
    if(nameFileLabelSize.height > MAX_HEIGHT_FILE_NAME){
        nameFileLabelSize.height = MAX_HEIGHT_FILE_NAME;
    }
    
    CGRect lbFileNameFrame   = _lbFileName.frame;
    lbFileNameFrame.origin.x = nameFrame.origin.x;
    lbFileNameFrame.origin.y = cellHeight - 40 - nameFileLabelSize.height;  // 40 = size of lbDate & buttom padding
    lbFileNameFrame.size.width = width;
    lbFileNameFrame.size.height = nameFileLabelSize.height;
    
    CGRect imageFrame = _imgvAttach.frame;
    
    imageFrame.origin.x = nameFrame.origin.x;
    imageFrame.origin.y = htmlMessageFrame.origin.y + htmlMessageFrame.size.height+LINE_DEFAULT_PADDING;
    imageFrame.size.width = width;
    imageFrame.size.height = lbFileNameFrame.origin.y - LINE_DEFAULT_PADDING - imageFrame.origin.y;
    
    
    dispatch_async(dispatch_get_main_queue(),^(void){
        [self.lbName setFrame:nameFrame];
        [self.htmlMessage setFrame:htmlMessageFrame];
        [self.imgvAttach setFrame:imageFrame];
        [self.lbFileName setFrame:lbFileNameFrame];
    });
    
}


- (void)startLoadingImageAttached {
    //if(self.imgvAttach.imageURL == nil)
    self.imgvAttach.imageURL = self.urlForAttachment;
}


- (void)resetImageAttached {
    self.imgvAttach.imageURL = nil;
}

- (void)dealloc
{
    [_urlForAttachment release];
    _urlForAttachment = nil;
    
    [super dealloc];
}

@end
