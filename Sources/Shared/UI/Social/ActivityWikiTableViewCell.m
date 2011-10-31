//
//  ActivityWikiTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityWikiTableViewCell.h"
#import "SocialActivityStream.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"

@implementation ActivityWikiTableViewCell

- (void)setSocialActivityStream:(SocialActivityStream*)socialActivityStream{
    [super setSocialActivityStream:socialActivityStream];

    switch (socialActivityStream.activityType) {
        case ACTIVITY_WIKI_MODIFY_PAGE:
            htmlName.html = [NSString stringWithFormat:@"<a>%@</a> %@<a> %@</a>", socialActivityStream.posterUserProfile.fullName, Localize(@"EditWiki"), [socialActivityStream.templateParams valueForKey:@"page_name"]];
            break;
        case ACTIVITY_WIKI_ADD_PAGE:
            htmlName.html = [NSString stringWithFormat:@"<a>%@</a> %@<a> %@</a>", socialActivityStream.posterUserProfile.fullName, Localize(@"CreateWiki"), [socialActivityStream.templateParams valueForKey:@"page_name"]];
            break; 
        default:
            break;
    }
    
    _lbName.text = @"";
    _lbMessage.text = @"";
    htmlLabel.html = @"";
}

@end
