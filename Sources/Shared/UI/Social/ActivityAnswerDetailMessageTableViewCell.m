//
//  ActivityAnswerDetailMessageTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityAnswerDetailMessageTableViewCell.h"

#import "SocialActivityDetails.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "defines.h"
#import "NSString+HTML.h"

@implementation ActivityAnswerDetailMessageTableViewCell

@synthesize htmlMessage = _htmlMessage;


- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth{
    CGRect tmpFrame = CGRectZero;
    if (fWidth > 320) {
        tmpFrame = CGRectMake(70, 0, WIDTH_FOR_CONTENT_IPAD, 21);
        width = WIDTH_FOR_CONTENT_IPAD;
    } else {
        tmpFrame = CGRectMake(70, 0, WIDTH_FOR_CONTENT_IPHONE - 10, 21);
        width = WIDTH_FOR_CONTENT_IPHONE;
    }
    
    _htmlMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlMessage.userInteractionEnabled = NO;
    _htmlMessage.backgroundColor = [UIColor clearColor];
    _htmlMessage.font = [UIFont systemFontOfSize:13.0];
    _htmlMessage.textColor = [UIColor grayColor];
    _htmlMessage.backgroundColor = [UIColor whiteColor];
    //_htmlMessage.autoresizingMask = UIViewAutoresizingFlexibleWidth;// |UIViewAutoresizingFlexibleTopMargin;
    [self.contentView addSubview:_htmlMessage];
}

- (void)setSocialActivityDetail:(SocialActivityDetails*)socialActivityDetail{
    [super setSocialActivityDetail:socialActivityDetail];
    NSString *textWithoutHtml = @"";
    switch (_activityType) {
        case ACTIVITY_ANSWER_ADD_QUESTION:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head><a>%@</a> %@<a> %@</a></body></html>",  socialActivityDetail.posterIdentity.fullName, Localize(@"Asked"), [_templateParams valueForKey:@"Name"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            textWithoutHtml = [NSString stringWithFormat:@"%@ %@ %@", socialActivityDetail.posterIdentity.fullName, Localize(@"Asked"),[_templateParams valueForKey:@"Name"]];
        }
            break;
        case ACTIVITY_ANSWER_QUESTION:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head><a>%@</a> %@<a> %@</a></body></html>",  socialActivityDetail.posterIdentity.fullName, Localize(@"Answered"), [_templateParams valueForKey:@"Name"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            textWithoutHtml = [NSString stringWithFormat:@"%@ %@ %@", socialActivityDetail.posterIdentity.fullName, Localize(@"Answered"),[_templateParams valueForKey:@"Name"]];
        }
            break;
        case ACTIVITY_ANSWER_UPDATE_QUESTION:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head><a>%@</a> %@<a> %@</a></body></html>", socialActivityDetail.posterIdentity.fullName, Localize(@"UpdateQuestion"), [_templateParams valueForKey:@"Name"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            textWithoutHtml = [NSString stringWithFormat:@"%@ %@ %@", socialActivityDetail.posterIdentity.fullName, Localize(@"UpdateQuestion"),[_templateParams valueForKey:@"Name"]];
        }
            break;
    }
    //Set the position of web
    CGRect tmpFrame = _webViewForContent.frame;
    tmpFrame.origin.y = 6;
    _webViewForContent.frame = tmpFrame;
    
    CGSize theSize = [textWithoutHtml sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    
    tmpFrame = _htmlMessage.frame;
    tmpFrame.origin.y = theSize.height + 20;
    _htmlMessage.frame = tmpFrame;
    
    NSLog(@"%@", [[_templateParams valueForKey:@"Name"] stringByConvertingHTMLToPlainText]);
    //_lbMessage.text = [[_templateParams valueForKey:@"page_exceprt"] stringByConvertingHTMLToPlainText];
    _htmlMessage.text = [_templateParams valueForKey:@"Name"];
    [_htmlMessage sizeToFit];
    
    //_lbMessage.text = [socialActivityDetail.title stringByConvertingHTMLToPlainText];
}

- (void)dealloc {
    [_htmlMessage release];
    _htmlMessage = nil;
    
    [super dealloc];
}

@end