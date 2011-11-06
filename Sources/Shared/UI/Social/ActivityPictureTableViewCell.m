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

@synthesize imgvAttach = _imgvAttach, lbFileName = _lbFileName;
@synthesize lbMessage = _lbMessage;


- (void)configureFonts:(BOOL)highlighted {
    
    if (!highlighted) {
        _lbFileName.textColor = [UIColor grayColor];
        _lbFileName.backgroundColor = [UIColor whiteColor];
        
        _lbMessage.textColor = [UIColor grayColor];
        _lbMessage.backgroundColor = [UIColor whiteColor];
    } else {
        _lbFileName.textColor = [UIColor darkGrayColor];
        _lbFileName.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
        
        _lbMessage.textColor = [UIColor darkGrayColor];
        _lbMessage.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
    }
    
    [super configureFonts:highlighted];
}


- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth {
}


- (void)setSocialActivityStreamForSpecificContent:(SocialActivityStream *)socialActivityStream {
    
    //Set the UserName of the activity
    _lbName.text = [socialActivityStream.posterUserProfile.fullName copy];

    
    _imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForUnreadableFile.png"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *strURL = [NSString stringWithFormat:@"%@%@", [userDefaults valueForKey:EXO_PREFERENCE_DOMAIN], [socialActivityStream.templateParams valueForKey:@"DOCLINK"]];
    
    _imgvAttach.imageURL = [NSURL URLWithString:strURL];
    _lbMessage.text = [[socialActivityStream.templateParams valueForKey:@"MESSAGE"] copy];
    _lbFileName.text = [socialActivityStream.templateParams valueForKey:@"DOCNAME"];
    
}


- (void)dealloc
{
    
    [super dealloc];
}

@end
