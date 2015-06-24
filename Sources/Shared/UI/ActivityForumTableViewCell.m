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

#import "ActivityForumTableViewCell.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "NSString+HTML.h"
#import "defines.h"

@implementation ActivityForumTableViewCell

@synthesize lbTitle = _lbTitle;



- (void)setSocialActivityStreamForSpecificContent:(SocialActivity *)socialActivityStream {    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        self.lbTitle.preferredMaxLayoutWidth = WIDTH_FOR_LABEL_IPAD;
    }

    NSString *type = [socialActivityStream.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityStream.activityStream valueForKey:@"fullName"];
    }
    
    NSString * name = socialActivityStream.posterIdentity.fullName;
    NSString * title = nil;
    switch (socialActivityStream.activityType) {
        case ACTIVITY_FORUM_CREATE_POST:
            name = [NSString stringWithFormat:@"%@%@ %@", socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"NewPost")];
            title = [socialActivityStream.templateParams valueForKey:@"PostName"];
            break;
        case ACTIVITY_FORUM_CREATE_TOPIC:
            name = [NSString stringWithFormat:@"%@%@ %@", socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"NewTopic")];
            
            
            if(plfVersion >= 4.0) { // plf 4 and later: TopicName is not in template params, it is title of socialActivityStream
                title = socialActivityStream.title;
            } else {
                title = [socialActivityStream.templateParams valueForKey:@"TopicName" ];
            }
            
            break;
        case ACTIVITY_FORUM_UPDATE_TOPIC:
            name = [NSString stringWithFormat:@"%@%@ %@", socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" %@ %@ %@",Localize(@"in"), space, Localize(@"space")] : @"", Localize(@"UpdateTopic")];
            title = [[[socialActivityStream.templateParams valueForKey:@"TopicName"] stringByEncodeWithHTML] stringByConvertingHTMLToPlainText];
            break; 
        case ACTIVITY_FORUM_UPDATE_POST:
            name = [NSString stringWithFormat:@"%@%@ %@", socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" %@ %@ %@",Localize(@"in"), space, Localize(@"space")] : @"", Localize(@"UpdatePost")];
            title = [[[socialActivityStream.templateParams valueForKey:@"PostName"] stringByEncodeWithHTML] stringByConvertingHTMLToPlainText];
            break; 
        default:
            break;
    }
    
    
    NSMutableAttributedString * attributedName = [[NSMutableAttributedString alloc] initWithString:name];
    [attributedName setAttributes:kAttributeText range:NSMakeRange(socialActivityStream.posterIdentity.fullName.length, name.length-socialActivityStream.posterIdentity.fullName.length)];
    
    if (space) {
        [attributedName setAttributes:kAttributeNameSpace range:[name rangeOfString:[NSString stringWithFormat:@" %@ ",space]]];
    }
    _lbName.attributedText = attributedName;
    
    _lbTitle.text = title;

    self.lbMessage.text = [socialActivityStream.body stringByConvertingHTMLToPlainText];

}


- (void)dealloc {
    [_lbTitle release];
    [super dealloc];
}


@end
