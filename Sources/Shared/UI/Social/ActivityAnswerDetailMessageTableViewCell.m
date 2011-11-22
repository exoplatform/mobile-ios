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

- (void)setSocialActivityDetail:(SocialActivityDetails*)socialActivityDetail{
    [super setSocialActivityDetail:socialActivityDetail];
    switch (_activityType) {
        case ACTIVITY_ANSWER_ADD_QUESTION:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head><a  href=\"%@\">%@</a> %@<a href=\"%@\"> %@</a></body></html>", socialActivityDetail.posterIdentity.fullName, socialActivityDetail.posterIdentity.fullName, Localize(@"Asked"), [_templateParams valueForKey:@"Name"],[_templateParams valueForKey:@"Name"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
        }
            break;
        case ACTIVITY_ANSWER_QUESTION:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head><a  href=\"%@\">%@</a> %@<a href=\"%@\"> %@</a></body></html>", socialActivityDetail.posterIdentity.fullName, socialActivityDetail.posterIdentity.fullName, Localize(@"Answered"), [_templateParams valueForKey:@"Name"],[_templateParams valueForKey:@"Name"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
        }
            break;
        case ACTIVITY_ANSWER_UPDATE_QUESTION:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head><a  href=\"%@\">%@</a> %@<a href=\"%@\"> %@</a></body></html>", socialActivityDetail.posterIdentity.fullName, socialActivityDetail.posterIdentity.fullName, Localize(@"UpdateQuestion"), [_templateParams valueForKey:@"Name"],[_templateParams valueForKey:@"Name"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
        }
            break;
    }
    //Set the position of web
    CGRect tmpFrame = _webViewForContent.frame;
    tmpFrame.origin.y = 6;
    _webViewForContent.frame = tmpFrame;
    
    _lbMessage.text = [socialActivityDetail.title stringByConvertingHTMLToPlainText];
}

@end