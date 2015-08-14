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

#import "ActivityForumDetailMessageTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "defines.h"
#import "ActivityHelper.h"
#import "LanguageHelper.h"
#import "EGOImageView.h"
#import "NSString+HTML.h"
#import "ApplicationPreferencesManager.h"
@implementation ActivityForumDetailMessageTableViewCell



- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth{
    CGRect tmpFrame = CGRectZero;
    if (fWidth > 320) {
        tmpFrame = CGRectMake(65, 0, WIDTH_FOR_CONTENT_IPAD, 21);
        width = WIDTH_FOR_CONTENT_IPAD;
     } else {
        tmpFrame = CGRectMake(65, 0, WIDTH_FOR_CONTENT_IPHONE , 21);
        width = WIDTH_FOR_CONTENT_IPHONE;
    }
    
}

- (void)updateSizeToFitSubViews {
    // update position of last line: icon and date label
}

- (void)setSocialActivityDetail:(SocialActivity *)socialActivityDetail
{
    [super setSocialActivityDetail:socialActivityDetail];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        self.lbTitle.preferredMaxLayoutWidth = WIDTH_FOR_LABEL_IPAD;
    }

    NSString *type = [socialActivityDetail.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityDetail.activityStream valueForKey:@"fullName"];
    }
    
    NSString * name = socialActivityDetail.posterIdentity.fullName;
    NSString * title = nil;
    switch (socialActivityDetail.activityType) {
        case ACTIVITY_FORUM_CREATE_POST:
            name = [NSString stringWithFormat:@"%@%@ %@", socialActivityDetail.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"NewPost")];
            title = [socialActivityDetail.templateParams valueForKey:@"PostName"];
            break;
        case ACTIVITY_FORUM_CREATE_TOPIC:
            name = [NSString stringWithFormat:@"%@%@ %@", socialActivityDetail.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"NewTopic")];
            float plfVersion = [[ApplicationPreferencesManager sharedInstance].platformVersion floatValue];
            if(plfVersion >= 4.0) { // plf 4 and later: TopicName is not in template params, it is title of socialActivityDetail
                title = socialActivityDetail.title;
            } else {
                title = [socialActivityDetail.templateParams valueForKey:@"TopicName" ];
            }
            
            break;
        case ACTIVITY_FORUM_UPDATE_TOPIC:
            name = [NSString stringWithFormat:@"%@%@ %@", socialActivityDetail.posterIdentity.fullName, space ? [NSString stringWithFormat:@" %@ %@ %@",Localize(@"in"), space, Localize(@"space")] : @"", Localize(@"UpdateTopic")];
            title = [[[socialActivityDetail.templateParams valueForKey:@"TopicName"] stringByEncodeWithHTML] stringByConvertingHTMLToPlainText];
            break;
        case ACTIVITY_FORUM_UPDATE_POST:
            name = [NSString stringWithFormat:@"%@%@ %@", socialActivityDetail.posterIdentity.fullName, space ? [NSString stringWithFormat:@" %@ %@ %@",Localize(@"in"), space, Localize(@"space")] : @"", Localize(@"UpdatePost")];
            title = [[[socialActivityDetail.templateParams valueForKey:@"PostName"] stringByEncodeWithHTML] stringByConvertingHTMLToPlainText];
            break;
        default:
            break;
    }
    
    
    NSMutableAttributedString * attributedName = [[NSMutableAttributedString alloc] initWithString:name];
    [attributedName setAttributes:kAttributeText range:NSMakeRange(socialActivityDetail.posterIdentity.fullName.length, name.length-socialActivityDetail.posterIdentity.fullName.length)];
    
    if (space) {
        [attributedName setAttributes:kAttributeNameSpace range:[name rangeOfString:[NSString stringWithFormat:@" %@ ",space]]];
    }
    _lbName.attributedText = attributedName;
    
    _lbTitle.text = title;
    
    _lbMessage.text = [socialActivityDetail.body stringByConvertingHTMLToPlainText];
}


@end
