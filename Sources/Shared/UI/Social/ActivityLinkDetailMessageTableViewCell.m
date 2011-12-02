//
//  ActivityLinkDetailMessageTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityLinkDetailMessageTableViewCell.h"
#import "SocialActivityDetails.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "defines.h"
#import "NSString+HTML.h"
#import "EGOImageView.h"
#import "ActivityHelper.h"
#import "LanguageHelper.h"

#define WIDTH_FOR_CONTENT_IPHONE 237
#define WIDTH_FOR_CONTENT_IPAD 409

@implementation ActivityLinkDetailMessageTableViewCell

@synthesize lbComment = _lbComment;

- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth {
    
    CGRect tmpFrame = CGRectZero;
    
    if (fWidth > 320) {
        tmpFrame = CGRectMake(70, 38, WIDTH_FOR_CONTENT_IPAD, 21);
        width = WIDTH_FOR_CONTENT_IPAD;
    } else {
        tmpFrame = CGRectMake(70, 38, WIDTH_FOR_CONTENT_IPHONE, 21);
        width = WIDTH_FOR_CONTENT_IPHONE;
    }
        
    _webViewComment = [[UIWebView alloc] initWithFrame:CGRectMake(60, 38, WIDTH_FOR_CONTENT_IPAD + 10, 28)];
    _webViewComment.contentMode = UIViewContentModeScaleAspectFit;
    [_webViewComment setBackgroundColor:[UIColor clearColor]];
    UIScrollView *scrollView = (UIScrollView *)[[_webViewComment subviews] objectAtIndex:0];
    scrollView.bounces = NO;
    [scrollView flashScrollIndicators];
    _webViewComment.dataDetectorTypes = UIDataDetectorTypeLink | UIDataDetectorTypeAddress;

    [_webViewComment setOpaque:NO];
    [self.contentView addSubview:_webViewComment];
}

#define kFontForLink [UIFont fontWithName:@"Helvetica" size:15]
- (void)setSocialActivityDetail:(SocialActivityDetails*)socialActivityDetail{
    [super setSocialActivityDetail:socialActivityDetail];
    //Set the UserName of the activity
    _lbName.text = [socialActivityDetail.posterIdentity.fullName copy];
    
    NSString *textWithoutHtml = [NSString stringWithFormat:@"Shared a link: %@", [_templateParams valueForKey:@"title"]];
    CGSize theSize = [textWithoutHtml sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    
    
    CGRect frame = _webViewForContent.frame;
    frame.origin.y =  _lbName.frame.size.height + _lbName.frame.origin.y + 5;
    frame.size.height =  theSize.height + 10;
    _webViewForContent.frame = frame;
    [_webViewForContent loadHTMLString:
     [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head>Shared a link: <a href=\"%@\">%@</a></body></html>",[_templateParams valueForKey:@"link"], [_templateParams valueForKey:@"title"]?[_templateParams valueForKey:@"title"]:@""] 
                               baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
     ];

    CGRect rect = _webViewComment.frame;
    rect.origin.y = _lbName.frame.size.height + _lbName.frame.origin.y + theSize.height + 10;
    
    if([[_templateParams valueForKey:@"image"] isEqualToString:@""]){
        
        rect.size.width = _webViewForContent.frame.size.width - 10;
        
    } else {
        self.imgvAttach.placeholderImage = [UIImage imageNamed:@"ActivityTypeDocument.png"];
        self.imgvAttach.imageURL = [NSURL URLWithString:[_templateParams valueForKey:@"image"]];
        
        rect.origin.x = _imgvAttach.frame.size.width + _imgvAttach.frame.origin.x + 10;
        rect.size.width = _webViewForContent.frame.size.width - self.imgvAttach.frame.size.width - 10; 
        
        CGRect rectOfAttachImg = _imgvAttach.frame;
        rectOfAttachImg.origin.y = rect.origin.y;
        _imgvAttach.frame = rectOfAttachImg;
    }
    
    theSize = [[_templateParams valueForKey:@"comment"] sizeWithFont:kFontForLink constrainedToSize:CGSizeMake(rect.size.width, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    rect.size.height = theSize.height + 10;
    _webViewComment.frame = rect;
    [_webViewComment loadHTMLString:
     [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head><body>%@</body></html>",[_templateParams valueForKey:@"comment"]?[_templateParams valueForKey:@"comment"]:@"" ] 
                               baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
     ];
}

- (void)dealloc {
    [_htmlLinkMessage release];
    _htmlLinkMessage = nil;
    
    [_lbComment release];
    _lbComment = nil;
    
    [super dealloc];
}


@end
