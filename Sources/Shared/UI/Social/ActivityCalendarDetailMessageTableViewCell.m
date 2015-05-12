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

#import "ActivityCalendarDetailMessageTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "defines.h"
#import "ActivityHelper.h"
#import "LanguageHelper.h"
#import "EGOImageView.h"
#import "NSString+HTML.h"
#import "NSDate+Formatting.h"


@implementation ActivityCalendarDetailMessageTableViewCell

- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth{
    CGRect tmpFrame = CGRectZero;
    //width = fWidth;
    if (fWidth > 320) {
        tmpFrame = CGRectMake(65, 0, WIDTH_FOR_CONTENT_IPAD, 21);
        width = WIDTH_FOR_CONTENT_IPAD;
    } else {
        tmpFrame = CGRectMake(65, 0, WIDTH_FOR_CONTENT_IPHONE , 21);
        width = WIDTH_FOR_CONTENT_IPHONE;
    }
}

- (void)updateSizeToFitSubViews {
}

- (void)setSocialActivityDetail:(SocialActivity *)socialActivityDetail
{
    [super setSocialActivityDetail:socialActivityDetail];
    NSString *type = [socialActivityDetail.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityDetail.activityStream valueForKey:@"fullName"];
    }
    NSString * name = socialActivityDetail.posterIdentity.fullName;
    switch (socialActivityDetail.activityType) {
        case ACTIVITY_CALENDAR_ADD_EVENT:
            name = [NSString stringWithFormat:@"%@%@ %@",
                    socialActivityDetail.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"EventAdded")];
            break;
        case ACTIVITY_CALENDAR_UPDATE_EVENT:
            name = [NSString stringWithFormat:@"%@%@ %@",
                    socialActivityDetail.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"EventUpdated")];
            break;
        case ACTIVITY_CALENDAR_ADD_TASK:
            name = [NSString stringWithFormat:@"%@%@ %@",
                    socialActivityDetail.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"TaskAdded")];
            break;
        case ACTIVITY_CALENDAR_UPDATE_TASK:
            name = [NSString stringWithFormat:@"%@%@ %@",
                    socialActivityDetail.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"TaskUpdated")];
            break;
        default:
            break;
    }
    
    NSDictionary * attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    
    NSMutableAttributedString * attributedName = [[NSMutableAttributedString alloc] initWithString:name];
    [attributedName setAttributes:attributes range:NSMakeRange(socialActivityDetail.posterIdentity.fullName.length, name.length-socialActivityDetail.posterIdentity.fullName.length)];
    _lbName.attributedText = attributedName;
    
    _lbTitle.text =[[[socialActivityDetail.templateParams valueForKey:@"EventSummary"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
    
    
    NSString *startTime = [[NSDate dateWithTimeIntervalSince1970:[[[socialActivityDetail.templateParams valueForKey:@"EventStartTime"] stringByConvertingHTMLToPlainText] doubleValue]/1000] distanceOfTimeInWords];
    NSString *endTime = [[NSDate dateWithTimeIntervalSince1970:[[[socialActivityDetail.templateParams valueForKey:@"EventEndTime"] stringByConvertingHTMLToPlainText] doubleValue]/1000] distanceOfTimeInWords];
    
    _lbMessage.text = [NSString stringWithFormat:@"%@: %@\n%@: %@\n%@: %@\n%@: %@",Localize(@"Description"), [[socialActivityDetail.templateParams valueForKey:@"EventDescription"] stringByConvertingHTMLToPlainText], Localize(@"Location"),[[socialActivityDetail.templateParams valueForKey:@"EventLocale"] stringByConvertingHTMLToPlainText], Localize(@"StartTime"), startTime, Localize(@"EndTime"), endTime];
}

- (void)dealloc {
    
    [_lbTitle release];
    [super dealloc];
}

@end
