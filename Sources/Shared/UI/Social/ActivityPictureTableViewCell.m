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


- (void)configureFonts:(BOOL)highlighted {
    
    if (!highlighted) {
        _lbFileName.textColor = [UIColor grayColor];
        _lbFileName.backgroundColor = [UIColor whiteColor];
        
    } else {
        _lbFileName.textColor = [UIColor darkGrayColor];
        _lbFileName.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
        
    }
    
    [super configureFonts:highlighted];
}



- (void)setSocialActivityStreamForSpecificContent:(SocialActivityStream *)socialActivityStream {
    
    //Set the UserName of the activity
    _lbName.text = [socialActivityStream.posterUserProfile.fullName copy];

    
    _imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForUnreadableFile.png"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *strURL = [NSString stringWithFormat:@"%@%@", [userDefaults valueForKey:EXO_PREFERENCE_DOMAIN], [socialActivityStream.templateParams valueForKey:@"DOCLINK"]];
    
    _imgvAttach.imageURL = [NSURL URLWithString:strURL];
    _htmlMessage.html = [socialActivityStream.templateParams valueForKey:@"MESSAGE"];
    _lbFileName.text = [socialActivityStream.templateParams valueForKey:@"DOCNAME"];
}


- (void)dealloc
{
    
    [super dealloc];
}

@end
