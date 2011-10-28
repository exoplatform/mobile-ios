//
//  ActivityForumTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityForumTableViewCell.h"
#import "SocialActivityStream.h"

@implementation ActivityForumTableViewCell

- (void)setSocialActivityStream:(SocialActivityStream*)socialActivityStream{
    [super setSocialActivityStream:socialActivityStream];

    NSString* textStr;
    if([socialActivityStream.templateParams valueForKey:@"PostName"] != nil){
        textStr = [NSString stringWithFormat:@"%@ has added a new post: %@", socialActivityStream.posterUserProfile.fullName, [socialActivityStream.templateParams valueForKey:@"PostName"]];
        
    } else if([socialActivityStream.templateParams valueForKey:@"TopicName"] != nil) {
        textStr = [NSString stringWithFormat:@"%@ has posted a new topic: %@", socialActivityStream.posterUserProfile.fullName, [socialActivityStream.templateParams valueForKey:@"TopicName"]];
        
    }
    //htmlName.html = [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head><body><table><tr><td color: #0888D6>%@</td><td color: #0888D6>%@</td><td color: #0888D6>%@</td></tr></table></body></html>",socialActivityStream.posterUserProfile.fullName, @" has posted a new topic: ", [socialActivityStream.templateParams valueForKey:@"PostName"]];
    _lbName.text = textStr;
    _lbMessage.text = socialActivityStream.title;
    htmlLabel.html = @"";
}

@end
