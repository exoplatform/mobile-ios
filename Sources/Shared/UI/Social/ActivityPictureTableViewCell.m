//
//  ActivityPictureTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityPictureTableViewCell.h"
#import "SocialActivityStream.h"
#import "EGOImageView.h"
#import "defines.h"

@implementation ActivityPictureTableViewCell

@synthesize imgvAttach = _imgvAttach;

- (void)setSocialActivityStream:(SocialActivityStream*)socialActivityStream{
    [super setSocialActivityStream:socialActivityStream];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *strURL = [NSString stringWithFormat:@"%@%@", [userDefaults valueForKey:EXO_PREFERENCE_DOMAIN], socialActivityStream.posterPicture.docLink];
    NSLog(@"%@", strURL);
    _imgvAttach.imageURL = [NSURL URLWithString:strURL]; 
    _lbMessage.text = [socialActivityStream.posterPicture.message copy];
}

-(void)setPicture {
    
}

- (void)dealloc
{
    [super dealloc];
}

@end
