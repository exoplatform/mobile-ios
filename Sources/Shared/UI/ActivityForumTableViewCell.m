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
#import "NSString+HTML.h"

@implementation ActivityForumTableViewCell

- (void)setSocialActivityStream:(SocialActivityStream*)socialActivityStream{
    [super setSocialActivityStream:socialActivityStream];

    switch (socialActivityStream.activityType) {
        case ACTIVITY_WIKI_MODIFY_PAGE:
            htmlName.html = [NSString stringWithFormat:@"<a>%@</a> %@<a> %@</a>", socialActivityStream.posterUserProfile.fullName, Localize(@"EditWiki"), [socialActivityStream.templateParams valueForKey:@"page_name"]];
            break;
        case ACTIVITY_WIKI_ADD_PAGE:
            htmlName.html = [NSString stringWithFormat:@"<a>%@</a> %@<a> %@</a>", socialActivityStream.posterUserProfile.fullName, Localize(@"CreateWiki"), [socialActivityStream.templateParams valueForKey:@"page_name"]];
            break; 
        
        case ACTIVITY_FORUM_CREATE_POST:
            htmlName.html = [NSString stringWithFormat:@"<a>%@</a> %@<a> %@</a>", socialActivityStream.posterUserProfile.fullName, Localize(@"NewPost"), [socialActivityStream.templateParams valueForKey:@"PostName"]];
            break;
        case ACTIVITY_FORUM_CREATE_TOPIC:
            htmlName.html = [NSString stringWithFormat:@"<a>%@</a> %@<a> %@</a>", socialActivityStream.posterUserProfile.fullName, Localize(@"NewTopic"), [socialActivityStream.templateParams valueForKey:@"TopicName"]];
            break; 
        case ACTIVITY_FORUM_UPDATE_TOPIC:
            htmlName.html = [NSString stringWithFormat:@"<a>%@</a> %@<a> %@</a>", socialActivityStream.posterUserProfile.fullName, Localize(@"UpdateTopic"), [socialActivityStream.templateParams valueForKey:@"TopicName"]];
            break; 
        case ACTIVITY_FORUM_UPDATE_POST:
            htmlName.html = [NSString stringWithFormat:@"<a>%@</a> %@<a> %@</a>", socialActivityStream.posterUserProfile.fullName, Localize(@"UpdatePost"), [socialActivityStream.templateParams valueForKey:@"PostName"]];
            break; 
        default:
            break;
    }
    _lbName.text = @"";
    if([socialActivityStream.templateParams valueForKey:@"page_exceprt"] == nil){
        _lbMessage.text = [socialActivityStream.title stringByConvertingHTMLToPlainText];
    } else {
        _lbMessage.text = [[socialActivityStream.templateParams valueForKey:@"page_exceprt"] stringByConvertingHTMLToPlainText];
    }
    htmlLabel.html = @"";
}


@end
