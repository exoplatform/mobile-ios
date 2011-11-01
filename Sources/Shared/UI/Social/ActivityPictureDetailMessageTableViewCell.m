//
//  ActivityPictureTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityPictureDetailMessageTableViewCell.h"
#import "SocialActivityStream.h"
#import "EGOImageView.h"
#import "defines.h"

@implementation ActivityPictureDetailMessageTableViewCell

- (void)setLinkForImageAttach:(NSString *)URL{
    _imgvAttach.placeholderImage = [UIImage imageNamed:@"DocumentIconForUnknown.png"];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _imgvAttach.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [userDefault valueForKey:EXO_PREFERENCE_DOMAIN], URL]];
}

- (void)setSocialActivityDetail:(SocialActivityDetails*)socialActivityDetail{
    [super setSocialActivityDetail:socialActivityDetail];
    _imgvAttach.placeholderImage = [UIImage imageNamed:@"DocumentIconForUnknown.png"];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _imgvAttach.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [userDefault valueForKey:EXO_PREFERENCE_DOMAIN], [_templateParams valueForKey:@"DOCLINK"]]];
}

@end
