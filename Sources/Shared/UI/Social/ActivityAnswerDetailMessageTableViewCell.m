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

#import "ActivityAnswerDetailMessageTableViewCell.h"

#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "defines.h"
#import "NSString+HTML.h"

@implementation ActivityAnswerDetailMessageTableViewCell


- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth{
    CGRect tmpFrame = CGRectZero;
    if (fWidth > 320) {
        tmpFrame = CGRectMake(67, 0, WIDTH_FOR_CONTENT_IPAD, 21);
        width = WIDTH_FOR_CONTENT_IPAD;
    } else {
        tmpFrame = CGRectMake(67, 0, WIDTH_FOR_CONTENT_IPHONE , 21);
        width = WIDTH_FOR_CONTENT_IPHONE;
    }
    
}

- (void)updateSizeToFitSubViews {

}

- (void)setSocialActivityDetail:(SocialActivity *)socialActivityDetail{
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
    
    switch (socialActivityDetail.activityType) {
        case ACTIVITY_ANSWER_ADD_QUESTION:
            name = [NSString stringWithFormat:@"%@%@ %@", socialActivityDetail.posterIdentity.fullName,  space ? [NSString stringWithFormat:@" in %@ space", space] : @"",Localize(@"Asked")];
            break;
        case ACTIVITY_ANSWER_QUESTION:
            name = [NSString stringWithFormat:@"%@%@ %@", socialActivityDetail.posterIdentity.fullName,  space ? [NSString stringWithFormat:@" in %@ space", space] : @"",Localize(@"Answered")];
            break;
        case ACTIVITY_ANSWER_UPDATE_QUESTION:
            name = [NSString stringWithFormat:@"%@%@ %@", socialActivityDetail.posterIdentity.fullName,  space ? [NSString stringWithFormat:@" in %@ space", space] : @"",Localize(@"UpdateQuestion")];
            break;
        default:
            break;
    }
    
    
    
    NSMutableAttributedString * attributedName = [[NSMutableAttributedString alloc] initWithString:name];
    [attributedName setAttributes:kAttributeText range:NSMakeRange(socialActivityDetail.posterIdentity.fullName.length, name.length-socialActivityDetail.posterIdentity.fullName.length)];
    if (space){
        [attributedName setAttributes:kAttributeNameSpace range:[name rangeOfString:[NSString stringWithFormat:@" %@ ",space]]];
    }
    
    _lbName.attributedText = attributedName;
    
    //Set the position of Title
    float plfVersion = [[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_VERSION_SERVER] floatValue];
    // in plf 4, no Name in template params, it's the title of ActivityStream
    NSString *title = plfVersion >= 4.0 ? socialActivityDetail.title : [socialActivityDetail.templateParams valueForKey:@"Name"];
    
    _lbTitle.text = title;
    
    _lbMessage.text = [[socialActivityDetail.body stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
}

- (void)dealloc {
    [self.lbTitle release];
    [super dealloc];
}

@end
