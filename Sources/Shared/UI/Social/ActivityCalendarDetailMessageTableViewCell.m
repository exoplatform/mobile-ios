//
//  ActivityCalendarDetailMessageTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityCalendarDetailMessageTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialActivityDetails.h"
#import "defines.h"
#import "ActivityHelper.h"
#import "LanguageHelper.h"
#import "EGOImageView.h"
#import "NSString+HTML.h"
#import "NSDate+Formatting.h"

@implementation ActivityCalendarDetailMessageTableViewCell

- (void)setSocialActivityDetail:(SocialActivityDetails*)socialActivityDetail
{
    [super setSocialActivityDetail:socialActivityDetail];
    switch (_activityType) {
        case ACTIVITY_CALENDAR_ADD_EVENT:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head><a  href=\"%@\">%@</a> %@<a href=\"%@\"> %@</a></body></html>", socialActivityDetail.posterIdentity.fullName, socialActivityDetail.posterIdentity.fullName, Localize(@"EventAdded"), [_templateParams valueForKey:@"TopicLink"],[_templateParams valueForKey:@"EventSummary"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            
        }
            break;
        case ACTIVITY_CALENDAR_UPDATE_EVENT:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head><a  href=\"%@\">%@</a> %@<a href=\"%@\"> %@</a></body></html>", socialActivityDetail.posterIdentity.fullName, socialActivityDetail.posterIdentity.fullName, Localize(@"EventUpdated"), [_templateParams valueForKey:@"PostLink"],[_templateParams valueForKey:@"EventSummary"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
        }
            

            break; 
        case ACTIVITY_CALENDAR_ADD_TASK:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head><a href=\"%@\">%@</a> %@<a href=\"%@\"> %@</a></body></html>", socialActivityDetail.posterIdentity.fullName, socialActivityDetail.posterIdentity.fullName, Localize(@"TaskAdded"), [_templateParams valueForKey:@"PostLink"],[_templateParams valueForKey:@"EventSummary"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            
        }
            
            break;
        case ACTIVITY_CALENDAR_UPDATE_TASK:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head><a href=\"%@\">%@</a> %@<a href=\"%@\"> %@</a></body></html>", socialActivityDetail.posterIdentity.fullName, socialActivityDetail.posterIdentity.fullName, Localize(@"TaskUpdated"), [_templateParams valueForKey:@"TopicLink"],[_templateParams valueForKey:@"EventSummary"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            
        }
            break;
        default:
        {
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head><body>%@</body></html>",[socialActivityDetail.title copy]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            _lbName.text = [socialActivityDetail.posterIdentity.fullName copy];
        }
            break;
    }
    //Set the position of web
    CGRect tmpFrame = _webViewForContent.frame;
    tmpFrame.origin.y = 6;
    _webViewForContent.frame = tmpFrame;
    

    NSString *startTime = [[NSDate date] dateWithTimeInterval:[[_templateParams valueForKey:@"EventStartTime"] stringByConvertingHTMLToPlainText]];
    NSString *endTime = [[NSDate date] dateWithTimeInterval:[[_templateParams valueForKey:@"EventEndTime"] stringByConvertingHTMLToPlainText]];
    
    _lbMessage.text = [NSString stringWithFormat:@"%@: %@\n%@: %@\n%@: %@\n%@: %@",Localize(@"Description"), [[_templateParams valueForKey:@"EventDescription"] stringByConvertingHTMLToPlainText], Localize(@"Location"),[[_templateParams valueForKey:@"EventLocale"] stringByConvertingHTMLToPlainText], Localize(@"StartTime"), startTime, Localize(@"EndTime"), endTime];
}

@end
