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
    _imgvAttach.placeholderImage = [UIImage imageNamed:@"ActivityTypeDocument.png"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *strURL = [NSString stringWithFormat:@"%@%@", [userDefaults valueForKey:EXO_PREFERENCE_DOMAIN], [socialActivityStream.templateParams valueForKey:@"DOCLINK"]];
    
    _imgvAttach.imageURL = [NSURL URLWithString:strURL]; 
    _lbMessage.text = [[socialActivityStream.templateParams valueForKey:@"MESSAGE"] copy];
     htmlLabel.html = @"";
}

-(void)setPicture {
    
}

- (void)dealloc
{
    
    [super dealloc];
}

@end
