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

@implementation ActivityWikiTableViewCell

- (void)setSocialActivityStream:(SocialActivityStream*)socialActivityStream{
    [super setSocialActivityStream:socialActivityStream];
    
    NSString* textStr;
    if([[socialActivityStream.templateParams valueForKey:@"act_key"] rangeOfString:@"add_page"].length > 0){//
        textStr = [NSString stringWithFormat:@"%@ %@ %@", socialActivityStream.posterUserProfile.fullName, Localize(@"EditWiki"),[socialActivityStream.templateParams valueForKey:@"page_name"]];
    } else if([[socialActivityStream.templateParams valueForKey:@"act_key"] rangeOfString:@"update_page"].length > 0) {
        textStr = [NSString stringWithFormat:@"%@ %@ %@", socialActivityStream.posterUserProfile.fullName, Localize(@"CreateWiki"),[socialActivityStream.templateParams valueForKey:@"page_name"]];
    }
    _lbName.text = textStr;
    _lbMessage.text = @"";
    htmlLabel.html = @"";
}

@end
