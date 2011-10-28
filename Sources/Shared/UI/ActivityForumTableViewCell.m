//
//  ActivityForumTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityForumTableViewCell.h"
#import "SocialActivityStream.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"

@implementation ActivityForumTableViewCell

- (void)setSocialActivityStream:(SocialActivityStream*)socialActivityStream{
    [super setSocialActivityStream:socialActivityStream];

    switch (socialActivityStream.activityType) {
        case ACTIVITY_FORUM_CREATE_POST:
            htmlName.html = [NSString stringWithFormat:@"<a> %@</a> %@<a> %@</a>", socialActivityStream.posterUserProfile.fullName, Localize(@"NewPost"), [socialActivityStream.templateParams valueForKey:@"PostName"]];
            break;
        case ACTIVITY_FORUM_CREATE_TOPIC:
            htmlName.html = [NSString stringWithFormat:@"<a> %@</a> %@<a> %@</a>", socialActivityStream.posterUserProfile.fullName, Localize(@"NewTopic"), [socialActivityStream.templateParams valueForKey:@"TopicName"]];
            break; 
        default:
            break;
    }
    _lbName.text = @"";
    _lbMessage.text = socialActivityStream.title;
    htmlLabel.html = @"";
}

@end
