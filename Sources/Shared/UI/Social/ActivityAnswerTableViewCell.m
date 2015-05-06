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

#import "ActivityAnswerTableViewCell.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "NSString+HTML.h"
#import "defines.h"

@implementation ActivityAnswerTableViewCell

@synthesize lbMessage = _lbMessage;
@synthesize lbTitle = _lbTitle;



- (void)setSocialActivityStreamForSpecificContent:(SocialActivity *)socialActivityStream {
    [self backgroundConfiguration];
    
    NSString *type = [socialActivityStream.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityStream.activityStream valueForKey:@"fullName"];
    }
    NSString * name = socialActivityStream.posterIdentity.fullName;
    
    switch (socialActivityStream.activityType) {
        case ACTIVITY_ANSWER_ADD_QUESTION:
            name = [NSString stringWithFormat:@"%@%@ %@", socialActivityStream.posterIdentity.fullName,  space ? [NSString stringWithFormat:@" in %@ space", space] : @"",Localize(@"Asked")];
            break;
        case ACTIVITY_ANSWER_QUESTION:
            name = [NSString stringWithFormat:@"%@%@ %@", socialActivityStream.posterIdentity.fullName,  space ? [NSString stringWithFormat:@" in %@ space", space] : @"",Localize(@"Answered")];
            break; 
        case ACTIVITY_ANSWER_UPDATE_QUESTION:
            name = [NSString stringWithFormat:@"%@%@ %@", socialActivityStream.posterIdentity.fullName,  space ? [NSString stringWithFormat:@" in %@ space", space] : @"",Localize(@"UpdateQuestion")];
            break; 
        default:
            break;
    }
    
    NSDictionary * attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    
    NSMutableAttributedString * attributedName = [[NSMutableAttributedString alloc] initWithString:name];
    [attributedName setAttributes:attributes range:NSMakeRange(socialActivityStream.posterIdentity.fullName.length, name.length-socialActivityStream.posterIdentity.fullName.length)];
    _lbName.attributedText = attributedName;
    
    //Set the position of Title
    float plfVersion = [[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_VERSION_SERVER] floatValue];
    // in plf 4, no Name in template params, it's the title of ActivityStream
    NSString *title = plfVersion >= 4.0 ? socialActivityStream.title : [socialActivityStream.templateParams valueForKey:@"Name"];
    
    _lbTitle.text = title;
    
    _lbMessage.text = [[socialActivityStream.body stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
    
    
}


- (void)dealloc {
    
    _lbMessage = nil;
    
    [_lbMessage release];
    [_lbTitle release];
    [super dealloc];
}


@end
