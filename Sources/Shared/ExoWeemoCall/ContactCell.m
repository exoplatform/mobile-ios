//
//  ContactCell.m
//  eXo Platform
//
//  Created by vietnq on 10/28/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "ContactCell.h"

@implementation ContactCell
@synthesize avatar = _avatar;
@synthesize lb_full_name = _lb_full_name;
@synthesize lb_username = _lb_username;

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
    
    _avatar = nil;
    _lb_full_name = nil;
    _lb_username = nil;
    
    [_avatar release];
    [_lb_username release];
    [_lb_full_name release];
}
@end
