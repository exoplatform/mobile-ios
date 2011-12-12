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
@synthesize htmlName =_htmlName;
@synthesize htmlTitle = _htmlTitle;

- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth{
    CGRect tmpFrame = CGRectZero;
    //width = fWidth;
    if (fWidth > 320) {
        tmpFrame = CGRectMake(70, 0, WIDTH_FOR_CONTENT_IPAD, 21);
        width = WIDTH_FOR_CONTENT_IPAD;
    } else {
        tmpFrame = CGRectMake(70, 0, WIDTH_FOR_CONTENT_IPHONE , 21);
        width = WIDTH_FOR_CONTENT_IPHONE;
    }
    
    _htmlName = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlName.userInteractionEnabled = NO;
    _htmlName.backgroundColor = [UIColor clearColor];
    _htmlName.font = [UIFont systemFontOfSize:13.0];
    _htmlName.textColor = [UIColor grayColor];
    _htmlName.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:_htmlName];
    
    _htmlTitle = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlTitle.userInteractionEnabled = NO;
    _htmlTitle.backgroundColor = [UIColor clearColor];
    _htmlTitle.font = [UIFont systemFontOfSize:13.0];
    _htmlTitle.textColor = [UIColor grayColor];
    _htmlTitle.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:_htmlTitle];
    
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
    NSString *htmlStr = nil;
    switch (_activityType) {
        case ACTIVITY_CALENDAR_ADD_EVENT:{
            htmlStr = [NSString stringWithFormat:@"<a>%@</a> %@", socialActivityDetail.posterIdentity.fullName, Localize(@"EventAdded")];
            
        }
            break;
        case ACTIVITY_CALENDAR_UPDATE_EVENT:{
            htmlStr = [NSString stringWithFormat:@"<a>%@</a> %@", socialActivityDetail.posterIdentity.fullName, Localize(@"EventUpdated")];
        }
            break; 
        case ACTIVITY_CALENDAR_ADD_TASK:{
            htmlStr = [NSString stringWithFormat:@"<a>%@</a> %@", socialActivityDetail.posterIdentity.fullName, Localize(@"TaskAdded")];
            
        }
            
            break;
        case ACTIVITY_CALENDAR_UPDATE_TASK:{
            htmlStr = [NSString stringWithFormat:@"<a>%@</a> %@", socialActivityDetail.posterIdentity.fullName, Localize(@"TaskUpdated")];
        }
            break;
    }
    _htmlName.html = htmlStr;
    [_htmlName sizeToFit];
    
    _htmlTitle.html = [NSString stringWithFormat:@"<a>%@</a>", [[[_templateParams valueForKey:@"EventSummary"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML]];
    
    NSString *startTime = [[NSDate date] dateWithTimeInterval:[[_templateParams valueForKey:@"EventStartTime"] stringByConvertingHTMLToPlainText]];
    NSString *endTime = [[NSDate date] dateWithTimeInterval:[[_templateParams valueForKey:@"EventEndTime"] stringByConvertingHTMLToPlainText]];
    
    _htmlMessage.html = [NSString stringWithFormat:@"%@: %@\n%@: %@\n%@: %@\n%@: %@\n",Localize(@"Description"), [[_templateParams valueForKey:@"EventDescription"] stringByConvertingHTMLToPlainText], Localize(@"Location"),[[_templateParams valueForKey:@"EventLocale"] stringByConvertingHTMLToPlainText], Localize(@"StartTime"), startTime, Localize(@"EndTime"), endTime];

    //Set the position of web
    CGRect tmpFrame = _htmlName.frame;
    tmpFrame.origin.y = 6;
    _htmlName.frame = tmpFrame;
    
    tmpFrame = _htmlTitle.frame;
    tmpFrame.origin.y = _htmlName.frame.size.height + _htmlName.frame.origin.y + 5;
    _htmlTitle.frame = tmpFrame;

    tmpFrame = _htmlMessage.frame;
    tmpFrame.origin.y = _htmlTitle.frame.size.height + _htmlTitle.frame.origin.y + 5;
    _htmlMessage.frame = tmpFrame;
    
    [_htmlMessage sizeToFit];
    [_htmlTitle sizeToFit];
}

- (void)dealloc {
    [_htmlTitle release];
    [_htmlMessage release];
    _htmlMessage = nil;
    
    [super dealloc];
}

@end
