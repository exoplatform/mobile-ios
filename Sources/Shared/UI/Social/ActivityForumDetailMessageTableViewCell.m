//
//  ActivityForumDetailMessageTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityForumDetailMessageTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialActivityStream.h"
#import "SocialActivityDetails.h"
#import "defines.h"
#import "ActivityHelper.h"
#import "LanguageHelper.h"
#import "EGOImageView.h"
#import "NSString+HTML.h"

@implementation ActivityForumDetailMessageTableViewCell

@synthesize htmlMessage = _htmlMessage;
@synthesize htmlName = _htmlName;

- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth{
    CGRect tmpFrame = CGRectZero;
    if (fWidth > 320) {
        tmpFrame = CGRectMake(67, 0, WIDTH_FOR_CONTENT_IPAD, 21);
        width = WIDTH_FOR_CONTENT_IPAD;
     } else {
        tmpFrame = CGRectMake(67, 0, WIDTH_FOR_CONTENT_IPHONE , 21);
        width = WIDTH_FOR_CONTENT_IPHONE;
    }
    
    _htmlName = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlName.userInteractionEnabled = NO;
    _htmlName.backgroundColor = [UIColor clearColor];
    _htmlName.font = [UIFont systemFontOfSize:13.0];
    _htmlName.textColor = [UIColor grayColor];
    _htmlName.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:_htmlName];
    
    _htmlMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlMessage.userInteractionEnabled = NO;
    _htmlMessage.backgroundColor = [UIColor clearColor];
    _htmlMessage.font = [UIFont systemFontOfSize:13.0];
    _htmlMessage.textColor = [UIColor grayColor];
    _htmlMessage.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:_htmlMessage];
}

- (void)setSocialActivityDetail:(SocialActivityDetails*)socialActivityDetail
{
    [super setSocialActivityDetail:socialActivityDetail];
    NSString *textWithoutHtml = @"";
    NSString *htmlStr = nil;
    switch (_activityType) {
        case ACTIVITY_FORUM_CREATE_TOPIC:{
            htmlStr = [NSString stringWithFormat:@"<p><a>%@</a> %@</p>", socialActivityDetail.posterIdentity.fullName, Localize(@"NewTopic")];
            [_webViewForContent loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;} a{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><a href=\"%@\">%@</a></body></html>", [_templateParams valueForKey:@"TopicLink"],[_templateParams valueForKey:@"TopicName"]]
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
             textWithoutHtml = [NSString stringWithFormat:@"%@ %@ %@", socialActivityDetail.posterIdentity.fullName, Localize(@"NewTopic"),[_templateParams valueForKey:@"TopicName"]];
        }
            break;
        case ACTIVITY_FORUM_CREATE_POST:{
            htmlStr = [NSString stringWithFormat:@"<p><a>%@</a> %@</p>", socialActivityDetail.posterIdentity.fullName, Localize(@"NewPost")];

            [_webViewForContent loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;} a{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><a href=\"%@\">%@</a></body></html>",[_templateParams valueForKey:@"PostLink"],[_templateParams valueForKey:@"PostName"]]
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            textWithoutHtml = [NSString stringWithFormat:@"%@ %@ %@", socialActivityDetail.posterIdentity.fullName, Localize(@"NewPost"),[_templateParams valueForKey:@"PostName"]];
        }
            
            break; 
        case ACTIVITY_FORUM_UPDATE_POST:{
            htmlStr = [NSString stringWithFormat:@"<p><a>%@</a> %@</p>", socialActivityDetail.posterIdentity.fullName, Localize(@"UpdatePost")];
            [_webViewForContent loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;} a{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><a href=\"%@\">%@</a></body></html>", [_templateParams valueForKey:@"PostLink"],[_templateParams valueForKey:@"PostName"]]
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            textWithoutHtml = [NSString stringWithFormat:@"%@ %@ %@", socialActivityDetail.posterIdentity.fullName, Localize(@"UpdatePost"),[_templateParams valueForKey:@"PostName"]];
        }
            
            break;
        case ACTIVITY_FORUM_UPDATE_TOPIC:{
            htmlStr = [NSString stringWithFormat:@"<p><a>%@</a> %@</p>", socialActivityDetail.posterIdentity.fullName, Localize(@"UpdateTopic")];
            [_webViewForContent loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;} a{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><a href=\"%@\">%@</a></body></html>", [_templateParams valueForKey:@"TopicLink"],[_templateParams valueForKey:@"TopicName"]]
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            textWithoutHtml = [NSString stringWithFormat:@"%@ %@ %@", socialActivityDetail.posterIdentity.fullName, Localize(@"UpdateTopic"),[_templateParams valueForKey:@"TopicName"]];
        }
            break;
    }
    // Name
    _htmlName.html = htmlStr;
    [_htmlName sizeToFit];
    
    _htmlMessage.html = [socialActivityDetail.body stringByConvertingHTMLToPlainText];
    [_htmlMessage sizeToFit];
    
    CGRect tmpFrame = _htmlName.frame;
    tmpFrame.origin.y = 5;
    _htmlName.frame = tmpFrame;

    //Set the position of web
    CGSize theSize = [textWithoutHtml sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    
    _webViewForContent.contentMode = UIViewContentModeScaleAspectFit;
    tmpFrame = _webViewForContent.frame;
    tmpFrame.origin.y = _htmlName.frame.size.height + _htmlName.frame.origin.y;
    tmpFrame.size.height = theSize.height;
    _webViewForContent.frame = tmpFrame;
    [_webViewForContent sizeToFit];
    
    // Content
    tmpFrame = _htmlMessage.frame;
    tmpFrame.origin.y = _webViewForContent.frame.size.height + _webViewForContent.frame.origin.y;
    _htmlMessage.frame = tmpFrame;
    
    
}

- (void)dealloc {
    [_htmlMessage release];
    _htmlMessage = nil;
    
    [super dealloc];
}

@end
