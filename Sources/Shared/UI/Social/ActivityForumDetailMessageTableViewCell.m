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

- (void)setSocialActivityDetail:(SocialActivityDetails*)socialActivityDetail
{
    [super setSocialActivityDetail:socialActivityDetail];
    switch (_activityType) {
        case ACTIVITY_FORUM_CREATE_TOPIC:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><a  href=\"%@\">%@</a> %@<a href=\"%@\"> %@</a></body></html>", socialActivityDetail.posterIdentity.fullName, socialActivityDetail.posterIdentity.fullName, Localize(@"NewTopic"), [_templateParams valueForKey:@"TopicLink"],[_templateParams valueForKey:@"TopicName"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
             
        }
            break;
        case ACTIVITY_FORUM_CREATE_POST:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><a  href=\"%@\">%@</a> %@<a href=\"%@\"> %@</a></body></html>", socialActivityDetail.posterIdentity.fullName, socialActivityDetail.posterIdentity.fullName, Localize(@"NewPost"), [_templateParams valueForKey:@"PostLink"],[_templateParams valueForKey:@"PostName"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
        }
            
            break; 
        case ACTIVITY_FORUM_UPDATE_POST:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><a href=\"%@\">%@</a> %@<a href=\"%@\"> %@</a></body></html>", socialActivityDetail.posterIdentity.fullName, socialActivityDetail.posterIdentity.fullName, Localize(@"UpdatePost"), [_templateParams valueForKey:@"PostLink"],[_templateParams valueForKey:@"PostName"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            
        }
            
            break;
        case ACTIVITY_FORUM_UPDATE_TOPIC:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><a href=\"%@\">%@</a> %@<a href=\"%@\"> %@</a></body></html>", socialActivityDetail.posterIdentity.fullName, socialActivityDetail.posterIdentity.fullName, Localize(@"UpdateTopic"), [_templateParams valueForKey:@"TopicLink"],[_templateParams valueForKey:@"TopicName"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            
        }
            break;
        default:
        {
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><body>%@</body></html>",[socialActivityDetail.title copy]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            _lbName.text = [socialActivityDetail.posterIdentity.fullName copy];
        }
            break;
    }
    //Set the position of web
    CGRect tmpFrame = _webViewForContent.frame;
    tmpFrame.origin.y = 2;
    _webViewForContent.frame = tmpFrame;
    
    _lbMessage.text = socialActivityDetail.title;
}

@end
