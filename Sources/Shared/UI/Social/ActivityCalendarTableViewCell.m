//
//  ActivityCalendarTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityCalendarTableViewCell.h"

#import "SocialActivity.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "NSString+HTML.h"
#import "NSDate+Formatting.h"
#import "defines.h"

@implementation ActivityCalendarTableViewCell

@synthesize lbMessage = _lbMessage;
@synthesize htmlName = _htmlName;
@synthesize htmlTitle = _htmlTitle;


- (void)configureFonts:(BOOL)highlighted {
    
    if (!highlighted) {
        _htmlName.textColor = [UIColor grayColor];
        _htmlName.backgroundColor = [UIColor whiteColor];
        
        _htmlTitle.textColor = [UIColor grayColor];
        _htmlTitle.backgroundColor = [UIColor whiteColor];
        
        _lbMessage.textColor = [UIColor grayColor];
        _lbMessage.backgroundColor = [UIColor whiteColor];
    } else {
        _htmlName.textColor = [UIColor darkGrayColor];
        _htmlName.backgroundColor = SELECTED_CELL_BG_COLOR;
        
        _htmlTitle.textColor = [UIColor darkGrayColor];
        _htmlTitle.backgroundColor = SELECTED_CELL_BG_COLOR;
        
        _lbMessage.textColor = [UIColor darkGrayColor];
        _lbMessage.backgroundColor = SELECTED_CELL_BG_COLOR;
        
    }
    
    [super configureFonts:highlighted];
}



- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth {
    
    CGRect tmpFrame = CGRectZero;
    
    if (fWidth > 320) {
        tmpFrame = CGRectMake(70, 14, WIDTH_FOR_CONTENT_IPAD, 21);
    } else {
        tmpFrame = CGRectMake(70, 14, WIDTH_FOR_CONTENT_IPHONE, 21);
    }
    
    //Use an html styled label to display informations about the author of the wiki page
    _htmlName = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlName.userInteractionEnabled = NO;
    _htmlName.backgroundColor = [UIColor clearColor];
    _htmlName.font = [UIFont systemFontOfSize:13.0];
    //_htmlName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:_htmlName];
    
    //Use an html styled label to display informations about the author of the wiki page
    _htmlTitle = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlTitle.userInteractionEnabled = NO;
    _htmlTitle.backgroundColor = [UIColor clearColor];
    _htmlTitle.font = [UIFont systemFontOfSize:13.0];
    //_htmlName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:_htmlTitle];
    
    
    _lbMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _lbMessage.userInteractionEnabled = NO;
    _lbMessage.backgroundColor = [UIColor clearColor];
    _lbMessage.font = [UIFont systemFontOfSize:13.0];
    //_lbMessage.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:_lbMessage];
}



- (void)setSocialActivityStreamForSpecificContent:(SocialActivity *)socialActivityStream {
    NSString *type = [socialActivityStream.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityStream.activityStream valueForKey:@"fullName"];
    }
    
    switch (socialActivityStream.activityType) {
        case ACTIVITY_CALENDAR_ADD_EVENT:
            _htmlName.html = [NSString stringWithFormat:@"<a>%@%@</a> %@", 
                              socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"EventAdded")];
            break;
        case ACTIVITY_CALENDAR_UPDATE_EVENT:
            _htmlName.html = [NSString stringWithFormat:@"<a>%@%@</a> %@", 
                              socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"EventUpdated")];
            break;
        case ACTIVITY_CALENDAR_ADD_TASK:
            _htmlName.html = [NSString stringWithFormat:@"<a>%@%@</a> %@", 
                              socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"TaskAdded")];
            break;
        case ACTIVITY_CALENDAR_UPDATE_TASK:
            _htmlName.html = [NSString stringWithFormat:@"<a>%@%@</a> %@", 
                              socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"TaskUpdated")];
            break; 
        default:
            break;
    }
    
    [_htmlName sizeToFit];
    
    _htmlTitle.html = [NSString stringWithFormat:@"<a>%@</a>", [[[socialActivityStream.templateParams valueForKey:@"EventSummary"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML]];

    [_htmlTitle sizeToFit];
    
    NSString *startTime = [[NSDate dateWithTimeIntervalSince1970:[[[socialActivityStream.templateParams valueForKey:@"EventStartTime"] stringByConvertingHTMLToPlainText] doubleValue]/1000] distanceOfTimeInWords];
    NSString *endTime = [[NSDate dateWithTimeIntervalSince1970:[[[socialActivityStream.templateParams valueForKey:@"EventEndTime"] stringByConvertingHTMLToPlainText] doubleValue]/1000] distanceOfTimeInWords];
    
    _lbMessage.html = [NSString stringWithFormat:@"%@: %@\n%@: %@\n%@: %@\n%@: %@",Localize(@"Description"), [[socialActivityStream.templateParams valueForKey:@"EventDescription"] stringByConvertingHTMLToPlainText], Localize(@"Location"),[[socialActivityStream.templateParams valueForKey:@"EventLocale"] stringByConvertingHTMLToPlainText], Localize(@"StartTime"), startTime, Localize(@"EndTime"), endTime];
    
    [_lbMessage sizeToFit];
    
    //Set the position of lbMessage
    CGRect tmpFrame = _htmlTitle.frame;
    tmpFrame.origin.y = _htmlName.frame.origin.y + _htmlName.frame.size.height;
    double heigthForTTLabel = [[[self htmlTitle] text] height];
    if (heigthForTTLabel > EXO_MAX_HEIGHT) heigthForTTLabel = EXO_MAX_HEIGHT;  
    tmpFrame.size.height = heigthForTTLabel;
    _htmlTitle.frame = tmpFrame;
    
    tmpFrame = _lbMessage.frame;
    tmpFrame.origin.y = _htmlTitle.frame.origin.y + _htmlTitle.frame.size.height + 5;
    heigthForTTLabel = [[[self lbMessage] text] height];
    if (heigthForTTLabel > EXO_MAX_HEIGHT) heigthForTTLabel = EXO_MAX_HEIGHT;  
    tmpFrame.size.height = heigthForTTLabel;
    _lbMessage.frame = tmpFrame;
    
}



- (void)dealloc {
    
    _lbMessage = nil;
    
    [_htmlTitle release];
    
    [_htmlName release];
    _htmlName = nil;
    
    
    [super dealloc];
}

@end

