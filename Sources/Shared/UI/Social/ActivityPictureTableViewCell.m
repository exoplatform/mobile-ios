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
    //width = fWidth;
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
    _lbFileName.font = [UIFont systemFontOfSize:13.0];
    _lbFileName.textColor = [UIColor grayColor];
    _lbFileName.numberOfLines = 2;
    
    self.htmlMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    self.htmlMessage.userInteractionEnabled = NO;
    self.htmlMessage.autoresizesSubviews = YES;
    self.htmlMessage.font = [UIFont systemFontOfSize:13.0];
    self.htmlMessage.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
    
//    _lbName.text = [NSString stringWithFormat:@"%@%@", [socialActivityStream.posterUserProfile.fullName copy], space ? [NSString stringWithFormat:@" in %@ space", space] : @""];
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
    CGRect rect = self.lbName.frame;
    rect.size.height = theSize.height + 5;
    self.lbName.frame = rect;
    
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
            
                        
            //Set the position of Title
            CGRect tmpFrame = self.htmlMessage.frame;
            tmpFrame.origin.y = self.lbName.frame.origin.y + self.lbName.frame.size.height + 5;
            double heigthForTTLabel = [[[self htmlMessage] text] height];
            if (heigthForTTLabel > EXO_MAX_HEIGHT){
                heigthForTTLabel = EXO_MAX_HEIGHT; 
            }
            tmpFrame.size.height = heigthForTTLabel;
            tmpFrame.size.width = self.lbName.frame.size.width;
            self.htmlMessage.frame = tmpFrame;
            
            //Set the position of lbMessage
            tmpFrame = self.imgvAttach.frame;
            tmpFrame.origin.y = self.htmlMessage.frame.origin.y + self.htmlMessage.frame.size.height + 5;
            tmpFrame.origin.x = (width > 320)? (width/3 + 100) : (width/3 + 70);
            self.imgvAttach.frame = tmpFrame;
            
            
            tmpFrame = _lbFileName.frame;
            tmpFrame.origin.y = self.imgvAttach.frame.origin.y + self.imgvAttach.frame.size.height + 5;
            CGSize theSize = [[socialActivityStream.templateParams valueForKey:@"DOCNAME"] sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                                             lineBreakMode:NSLineBreakByWordWrapping];
            if(theSize.height > MAX_HEIGHT_FILE_NAME){
                theSize.height = MAX_HEIGHT_FILE_NAME;
            }
            tmpFrame.size.height = theSize.height;
            tmpFrame.size.width = self.lbName.frame.size.width;
            _lbFileName.frame = tmpFrame;
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
            
            
            //Set the position of Title
            CGRect tmpFrame = self.htmlMessage.frame;
            tmpFrame.origin.y = self.lbName.frame.origin.y + self.lbName.frame.size.height + 5;
            double heigthForTTLabel = [[[self htmlMessage] text] height];
            if (heigthForTTLabel > EXO_MAX_HEIGHT){
                heigthForTTLabel = EXO_MAX_HEIGHT; 
            }
            tmpFrame.size.height = heigthForTTLabel;
            tmpFrame.size.width = self.lbName.frame.size.width;
            self.htmlMessage.frame = tmpFrame;
            
            
            //Set the position of lbMessage
            tmpFrame = self.imgvAttach.frame;
            tmpFrame.origin.y = self.htmlMessage.frame.origin.y + self.htmlMessage.frame.size.height + 10;
            tmpFrame.origin.x = (width > 320)? (width/3 + 100) : (width/3 + 70);
            self.imgvAttach.frame = tmpFrame;
        }
            break;
    }
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
