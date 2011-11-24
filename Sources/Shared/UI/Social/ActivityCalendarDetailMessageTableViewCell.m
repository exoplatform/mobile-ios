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

@synthesize htmlMessage = _htmlMessage;


- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth{
    CGRect tmpFrame = CGRectZero;
    width = fWidth;
    if (fWidth > 320) {
        tmpFrame = CGRectMake(70, 0, WIDTH_FOR_CONTENT_IPAD, 21);
    } else {
        tmpFrame = CGRectMake(70, 0, WIDTH_FOR_CONTENT_IPHONE, 21);
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

- (void)setSocialActivityDetail:(SocialActivityDetails*)socialActivityDetail
{
    [super setSocialActivityDetail:socialActivityDetail];
    NSString *textWithoutHtml = @"";
    switch (_activityType) {
        case ACTIVITY_CALENDAR_ADD_EVENT:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head><a>%@</a> %@<a> %@</a></body></html>", socialActivityDetail.posterIdentity.fullName, Localize(@"EventAdded"),[_templateParams valueForKey:@"EventSummary"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            
            textWithoutHtml = [NSString stringWithFormat:@"%@ %@ %@", socialActivityDetail.posterIdentity.fullName, Localize(@"EventAdded"),[_templateParams valueForKey:@"EventSummary"]];
            
        }
            break;
        case ACTIVITY_CALENDAR_UPDATE_EVENT:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head><a>%@</a> %@<a> %@</a></body></html>", socialActivityDetail.posterIdentity.fullName, Localize(@"EventUpdated"), [_templateParams valueForKey:@"EventSummary"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            textWithoutHtml = [NSString stringWithFormat:@"%@ %@ %@", socialActivityDetail.posterIdentity.fullName, Localize(@"EventUpdated"),[_templateParams valueForKey:@"EventSummary"]];
        }
            

            break; 
        case ACTIVITY_CALENDAR_ADD_TASK:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head><a>%@</a> %@<a> %@</a></body></html>", socialActivityDetail.posterIdentity.fullName, Localize(@"TaskAdded"), [_templateParams valueForKey:@"EventSummary"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            textWithoutHtml = [NSString stringWithFormat:@"%@ %@ %@", socialActivityDetail.posterIdentity.fullName, Localize(@"TaskAdded"),[_templateParams valueForKey:@"EventSummary"]];
            
        }
            
            break;
        case ACTIVITY_CALENDAR_UPDATE_TASK:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head><a>%@</a> %@<a> %@</a></body></html>",  socialActivityDetail.posterIdentity.fullName, Localize(@"TaskUpdated"), [_templateParams valueForKey:@"EventSummary"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            textWithoutHtml = [NSString stringWithFormat:@"%@ %@ %@", socialActivityDetail.posterIdentity.fullName, Localize(@"TaskUpdated"),[_templateParams valueForKey:@"EventSummary"]];
            
        }
            break;
    }
    _webViewForContent.contentMode = UIViewContentModeScaleAspectFit;

    //Set the position of web
    CGRect tmpFrame = _webViewForContent.frame;
    tmpFrame.origin.y = 6;
    _webViewForContent.frame = tmpFrame;
    
    tmpFrame = _htmlMessage.frame;
    tmpFrame.origin.y = _webViewForContent.frame.size.height + _webViewForContent.frame.origin.y;
    _lbMessage.frame = tmpFrame;
    
    CGSize theSize = [textWithoutHtml sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    tmpFrame = _htmlMessage.frame;
    tmpFrame.origin.y = theSize.height + 35;
    _htmlMessage.frame = tmpFrame;
    
    NSString *startTime = [[NSDate date] dateWithTimeInterval:[[_templateParams valueForKey:@"EventStartTime"] stringByConvertingHTMLToPlainText]];
    NSString *endTime = [[NSDate date] dateWithTimeInterval:[[_templateParams valueForKey:@"EventEndTime"] stringByConvertingHTMLToPlainText]];
    
    _htmlMessage.html = [NSString stringWithFormat:@"%@: %@\n%@: %@\n%@: %@\n%@: %@\n",Localize(@"Description"), [[_templateParams valueForKey:@"EventDescription"] stringByConvertingHTMLToPlainText], Localize(@"Location"),[[_templateParams valueForKey:@"EventLocale"] stringByConvertingHTMLToPlainText], Localize(@"StartTime"), startTime, Localize(@"EndTime"), endTime];
    [_htmlMessage sizeToFit];
}

- (void)dealloc {
    [_htmlMessage release];
    _htmlMessage = nil;
    
    [super dealloc];
}

@end
