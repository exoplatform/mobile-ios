//
//  ActivityDetailAdvancedInfoCell.m
//  eXo Platform
//
//  Created by exoplatform on 6/5/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import "ActivityDetailAdvancedInfoCell_iPad.h"

@interface ActivityDetailAdvancedInfoCell_iPad () 

- (void)doInit;

@end

@implementation ActivityDetailAdvancedInfoCell_iPad

- (void)doInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self doInit];
    }
    return self;
}

- (void)layoutSubviews {
    
}

@end
