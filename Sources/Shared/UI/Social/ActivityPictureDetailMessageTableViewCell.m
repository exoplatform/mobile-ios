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
    
    _lbFileName.textAlignment = NSTextAlignmentCenter;
    _lbFileName.userInteractionEnabled = NO;
    _lbFileName.backgroundColor = [UIColor clearColor];
    _lbFileName.font = [UIFont systemFontOfSize:13.0];
    _lbFileName.textColor = [UIColor grayColor];
    _lbFileName.numberOfLines = 2;
}

- (void)updateSizeToFitSubViews {
    //Set the position of lbMessage
    CGRect rect = self.imgvAttach.frame;
    rect.origin.y =  self.webViewForContent.frame.size.height + self.webViewForContent.frame.origin.y + 5;
    rect.origin.x = (width > 320)? (width/3 + 110) : (width/3 + 60);
    self.imgvAttach.frame = rect;
    
    rect = _lbFileName.frame;
    rect.origin.y = self.imgvAttach.frame.origin.y + self.imgvAttach.frame.size.height + 5;
    CGSize theSize = [[self.socialActivity.templateParams valueForKey:@"DOCNAME"] sizeWithFont:kFontForMessage 
                                                   constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)             
                                                       lineBreakMode:NSLineBreakByWordWrapping];
    if(theSize.height > MAX_HEIGHT_FILE_NAME){
        theSize.height = MAX_HEIGHT_FILE_NAME;
    }
    rect.size.height = theSize.height;
    rect.size.width = self.lbName.frame.size.width;
    _lbFileName.frame = rect;
    
    [self.webViewForContent sizeToFit];
    
    rect = self.frame;
    rect.size.height = self.lbFileName.frame.origin.y + self.lbFileName.frame.size.height + self.lbDate.frame.size.height + kBottomMargin;
    self.frame = rect;
}

- (void)setSocialActivityDetail:(SocialActivity *)socialActivityDetail{
    [super setSocialActivityDetail:socialActivityDetail];
    
    NSString *type = [socialActivityDetail.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityDetail.activityStream valueForKey:@"fullName"];
    }
    NSString *title = [NSString stringWithFormat:@"%@%@", [socialActivityDetail.posterIdentity.fullName copy], space ? [NSString stringWithFormat:@" in %@ space", space] : @""];
    NSMutableParagraphStyle *wordWrapStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    wordWrapStyle.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize theSize = [title boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                         options:nil
                                      attributes:@{
                                                   NSFontAttributeName: kFontForTitle,
                                                   NSParagraphStyleAttributeName: wordWrapStyle
                                                   }
                                         context:nil].size;
    CGRect rect = self.lbName.frame;
    rect.size.height = theSize.height + 5;
    self.lbName.frame = rect;
    
    self.lbName.text = title;
    
    self.imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForPlaceholderImage.png"];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    float plfVersion = [[userDefault valueForKey:EXO_PREFERENCE_VERSION_SERVER] floatValue];

    NSString *htmlStr = nil;
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
            self.imgvAttach.imageURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@", [userDefault valueForKey:EXO_PREFERENCE_DOMAIN],  imgPath] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [self.webViewForContent loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;} a{color: #115EAD; text-decoration: none; font-weight: bold;}</style></head><body>%@</body></html>", [_templateParams valueForKey:@"MESSAGE"]?[[_templateParams valueForKey:@"MESSAGE"] stringByConvertingHTMLToPlainText]:@""]
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            
            htmlStr = [NSString stringWithFormat:@"%@", [_templateParams valueForKey:@"MESSAGE"]];
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
            self.imgvAttach.imageURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@", [userDefault valueForKey:EXO_PREFERENCE_DOMAIN], [NSString stringWithFormat:@"/rest/thumbnailImage/large/%@", [_templateParams valueForKey:@"contenLink"]]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
             
            if(plfVersion >= 4.0) { // plf4 : no state
                htmlStr = [NSString stringWithFormat:@"<a href=\"%@\">%@</a> was created by <a>%@</a>", [NSString stringWithFormat:@"/portal/rest/jcr/%@", [_templateParams valueForKey:@"contenLink"]], [_templateParams valueForKey:@"contentName"], [_templateParams valueForKey:@"author"]];
            } else {
                htmlStr = [NSString stringWithFormat:@"<a href=\"%@\">%@</a> was created by <a>%@</a> state: %@", [NSString stringWithFormat:@"/portal/rest/jcr/%@", [_templateParams valueForKey:@"contenLink"]], [_templateParams valueForKey:@"contentName"], [_templateParams valueForKey:@"author"], [_templateParams valueForKey:@"state"]];
            }
                        
            NSString *htmlForWebView = [NSString stringWithFormat:@"<html><head><style>body {background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link {color: #115EAD; text-decoration: none; font-weight: bold;} a {color: #115EAD; text-decoration: none; font-weight: bold;}</style></head><body>%@</body></html>", htmlStr];
            [self.webViewForContent loadHTMLString:htmlForWebView
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            
            _lbFileName.text = @"";
        }
            break;
    }
    
    htmlStr = [htmlStr stringByStrippingTags];
    theSize = [htmlStr boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                    options:nil
                                 attributes:@{
                                              NSFontAttributeName: kFontForTitle,
                                              NSParagraphStyleAttributeName: wordWrapStyle
                                              }
                                    context:nil].size;
    
    rect = self.webViewForContent.frame;
    rect.origin.y =  self.lbName.frame.size.height + self.lbName.frame.origin.y;
    rect.size.height =  theSize.height + 5;
    self.webViewForContent.frame = rect;
    
    
    [self updateSizeToFitSubViews];
    
}

@end
