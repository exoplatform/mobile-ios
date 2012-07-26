//
//  ActivityPictureTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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

- (void)updateSizeToFitSubViews {
    //Set the position of lbMessage
    CGRect rect = self.imgvAttach.frame;
    rect.origin.y =  _webViewForContent.frame.size.height + _webViewForContent.frame.origin.y + 5;
    rect.origin.x = (width > 320)? (width/3 + 110) : (width/3 + 60);
    self.imgvAttach.frame = rect;
    
    rect = _lbFileName.frame;
    rect.origin.y = self.imgvAttach.frame.origin.y + self.imgvAttach.frame.size.height + 5;
    CGSize theSize = [[self.socialActivity.templateParams valueForKey:@"DOCNAME"] sizeWithFont:kFontForMessage 
                                                   constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)             
                                                       lineBreakMode:UILineBreakModeWordWrap];
    if(theSize.height > MAX_HEIGHT_FILE_NAME){
        theSize.height = MAX_HEIGHT_FILE_NAME;
    }
    rect.size.height = theSize.height;
    rect.size.width = _lbName.frame.size.width;
    _lbFileName.frame = rect;
    
    [_webViewForContent sizeToFit];
    
    rect = self.frame;
    rect.size.height = _lbFileName.frame.origin.y + _lbFileName.frame.size.height + _lbDate.frame.size.height + kBottomMargin;
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
    CGSize theSize = [title sizeWithFont:kFontForTitle constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                      lineBreakMode:UILineBreakModeWordWrap];
    CGRect rect = _lbName.frame;
    rect.size.height = theSize.height + 5;
    _lbName.frame = rect;
    
    _lbName.text = title;
    
    _imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForPlaceholderImage.png"];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
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
            _imgvAttach.imageURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@", [userDefault valueForKey:EXO_PREFERENCE_DOMAIN],  imgPath] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [_webViewForContent loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;} a{color: #115EAD; text-decoration: none; font-weight: bold;}</style></head><body>%@</body></html>", [_templateParams valueForKey:@"MESSAGE"]?[[_templateParams valueForKey:@"MESSAGE"] stringByConvertingHTMLToPlainText]:@""]
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
            _imgvAttach.imageURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@", [userDefault valueForKey:EXO_PREFERENCE_DOMAIN], [NSString stringWithFormat:@"/rest/thumbnailImage/large/%@", [_templateParams valueForKey:@"contenLink"]]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            [_webViewForContent loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;} a{color: #115EAD; text-decoration: none; font-weight: bold;}</style></head><a href=\"%@\">%@</a> was created by <a>%@</a> state : %@</body></html>", [NSString stringWithFormat:@"/portal/rest/jcr/%@", [_templateParams valueForKey:@"contenLink"]],[_templateParams valueForKey:@"contentName"], [_templateParams valueForKey:@"author"], [_templateParams valueForKey:@"state"]]
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            htmlStr = [NSString stringWithFormat:@"%@ was created by %@ state : %@", [_templateParams valueForKey:@"contentName"], [_templateParams valueForKey:@"author"], [_templateParams valueForKey:@"state"]];
            _lbFileName.text = @"";
        }
            break;
    }
    htmlStr = [htmlStr stringByConvertingHTMLToPlainText];
    
    theSize = [htmlStr sizeWithFont:kFontForTitle constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    //_webViewForContent.contentMode = UIViewContentModeScaleAspectFit;
    
    rect = _webViewForContent.frame;
    rect.origin.y =  _lbName.frame.size.height + _lbName.frame.origin.y;
    rect.size.height =  theSize.height + 5;
    _webViewForContent.frame = rect;
    
    
    [self updateSizeToFitSubViews];
    
}

@end
