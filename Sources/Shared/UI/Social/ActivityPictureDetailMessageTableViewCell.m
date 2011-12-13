//
//  ActivityPictureTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityPictureDetailMessageTableViewCell.h"
#import "SocialActivityDetails.h"
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

- (void)setSocialActivityDetail:(SocialActivityDetails*)socialActivityDetail{
    [super setSocialActivityDetail:socialActivityDetail];
    _lbName.text = [socialActivityDetail.posterIdentity.fullName copy];
    _imgvAttach.placeholderImage = [UIImage imageNamed:@"DocumentIconForUnknown.png"];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *htmlStr = nil;
    switch (_activityType) {
        case ACTIVITY_DOC:{
//            NSLog(@"%@", [NSString stringWithFormat:@"%@%@", [userDefault valueForKey:EXO_PREFERENCE_DOMAIN], [_templateParams valueForKey:@"DOCLINK"]]);
            _imgvAttach.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [userDefault valueForKey:EXO_PREFERENCE_DOMAIN], [[_templateParams valueForKey:@"DOCLINK"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            [_webViewForContent loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;} a{color: #115EAD; text-decoration: none; font-weight: bold;}</style></head><body>%@</body></html>", [_templateParams valueForKey:@"MESSAGE"]?[[_templateParams valueForKey:@"MESSAGE"] stringByConvertingHTMLToPlainText]:@""]
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            
            htmlStr = [NSString stringWithFormat:@"%@", [_templateParams valueForKey:@"MESSAGE"]];
            _lbFileName.text = [_templateParams valueForKey:@"DOCNAME"];
        }
            break;
        case ACTIVITY_CONTENTS_SPACE:{
//            NSLog(@"%@", [NSString stringWithFormat:@"%@%@", [userDefault valueForKey:EXO_PREFERENCE_DOMAIN], [NSString stringWithFormat:@"/portal/rest/jcr/%@", [_templateParams valueForKey:@"contenLink"]]]);
            _imgvAttach.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [userDefault valueForKey:EXO_PREFERENCE_DOMAIN], [NSString stringWithFormat:@"/portal/rest/jcr/%@", [[_templateParams valueForKey:@"contenLink"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
            [_webViewForContent loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;} a{color: #115EAD; text-decoration: none; font-weight: bold;}</style></head><a href=\"%@\">%@</a> was created by <a>%@</a> state : %@</body></html>", [NSString stringWithFormat:@"/portal/rest/jcr/%@", [_templateParams valueForKey:@"contenLink"]],[_templateParams valueForKey:@"contentName"], [_templateParams valueForKey:@"author"], [_templateParams valueForKey:@"state"]]
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            htmlStr = [NSString stringWithFormat:@"%@ was created by %@ state : %@", [_templateParams valueForKey:@"contentName"], [_templateParams valueForKey:@"author"], [_templateParams valueForKey:@"state"]];
            _lbFileName.text = @"";
        }
            break;
    }
    htmlStr = [htmlStr stringByConvertingHTMLToPlainText];
    
    CGSize theSize = [htmlStr sizeWithFont:kFontForTitle constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    //_webViewForContent.contentMode = UIViewContentModeScaleAspectFit;
    
    CGRect rect = _webViewForContent.frame;
    rect.origin.y =  _lbName.frame.size.height + _lbName.frame.origin.y;
    rect.size.height =  theSize.height + 5;
    _webViewForContent.frame = rect;
    
    
    //Set the position of lbMessage
    rect = self.imgvAttach.frame;
    rect.origin.y =  _webViewForContent.frame.size.height + _webViewForContent.frame.origin.y + 5;
    rect.origin.x = (width > 320)? (width/3 + 120) : (width/3 + 60);
    self.imgvAttach.frame = rect;
    
    rect = _lbFileName.frame;
    rect.origin.y = self.imgvAttach.frame.origin.y + self.imgvAttach.frame.size.height + 5;
    theSize = [[_templateParams valueForKey:@"DOCNAME"] sizeWithFont:kFontForMessage 
                                                          constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)             
                                                              lineBreakMode:UILineBreakModeWordWrap];
    if(theSize.height > MAX_HEIGHT_FILE_NAME){
        theSize.height = MAX_HEIGHT_FILE_NAME;
    }
    rect.size.height = theSize.height;
    rect.size.width = _lbName.frame.size.width;
    _lbFileName.frame = rect;
    
    [_webViewForContent sizeToFit];
    
}

@end
