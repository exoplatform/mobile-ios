//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
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
@synthesize lbTitle = _lbTitle;

- (void)setSocialActivityStreamForSpecificContent:(SocialActivity *)socialActivityStream {

    NSString *type = [socialActivityStream.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityStream.activityStream valueForKey:@"fullName"];
    }
    NSString * name = socialActivityStream.posterIdentity.fullName;
    switch (socialActivityStream.activityType) {
        case ACTIVITY_CALENDAR_ADD_EVENT:
            name = [NSString stringWithFormat:@"%@%@ %@",
                              socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"EventAdded")];
            break;
        case ACTIVITY_CALENDAR_UPDATE_EVENT:
            name = [NSString stringWithFormat:@"%@%@ %@",
                              socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"EventUpdated")];
            break;
        case ACTIVITY_CALENDAR_ADD_TASK:
            name = [NSString stringWithFormat:@"%@%@ %@",
                              socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"TaskAdded")];
            break;
        case ACTIVITY_CALENDAR_UPDATE_TASK:
            name = [NSString stringWithFormat:@"%@%@ %@",
                              socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"TaskUpdated")];
            break; 
        default:
            break;
    }
    
    NSDictionary * attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    
    NSMutableAttributedString * attributedName = [[NSMutableAttributedString alloc] initWithString:name];
    [attributedName setAttributes:attributes range:NSMakeRange(socialActivityStream.posterIdentity.fullName.length, name.length-socialActivityStream.posterIdentity.fullName.length)];
    _lbName.attributedText = attributedName;
    
    _lbTitle.text =[[[socialActivityStream.templateParams valueForKey:@"EventSummary"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
    

    NSString *startTime = [[NSDate dateWithTimeIntervalSince1970:[[[socialActivityStream.templateParams valueForKey:@"EventStartTime"] stringByConvertingHTMLToPlainText] doubleValue]/1000] distanceOfTimeInWords];
    NSString *endTime = [[NSDate dateWithTimeIntervalSince1970:[[[socialActivityStream.templateParams valueForKey:@"EventEndTime"] stringByConvertingHTMLToPlainText] doubleValue]/1000] distanceOfTimeInWords];
    
    _lbMessage.text = [NSString stringWithFormat:@"%@: %@\n%@: %@\n%@: %@\n%@: %@",Localize(@"Description"), [[socialActivityStream.templateParams valueForKey:@"EventDescription"] stringByConvertingHTMLToPlainText], Localize(@"Location"),[[socialActivityStream.templateParams valueForKey:@"EventLocale"] stringByConvertingHTMLToPlainText], Localize(@"StartTime"), startTime, Localize(@"EndTime"), endTime];
    
    
}



- (void)dealloc {
    
    _lbMessage = nil;
    [_lbMessage release];
    [_lbTitle release];
    [super dealloc];
}

@end

