//
//  ActivityBasicTableViewCell.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityBasicTableViewCell.h"
#import "EGOImageView.h"
#import "MockSocial_Activity.h"
#import <QuartzCore/QuartzCore.h>


@implementation ActivityBasicTableViewCell

@synthesize lbMessage=_lbMessage, lbDate=_lbDate , imgvAvatar=_imgvAvatar;
@synthesize btnLike = _btnLike, btnComment = _btnComment, imgvMessageBg=_imgvMessageBg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}


#pragma mark - Activity Cell methods 

- (void)setActivity:(Activity*)activity
{
    _imgvAvatar.imageURL = [NSURL URLWithString:activity.avatarUrl];
    [[_imgvAvatar layer] setCornerRadius:10.0];
    [[_imgvAvatar layer] setMasksToBounds:YES];
    [[_imgvAvatar layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[_imgvAvatar layer] setBorderWidth:2.0];
    
    _lbMessage.text = [activity.title copy];
}


@end
