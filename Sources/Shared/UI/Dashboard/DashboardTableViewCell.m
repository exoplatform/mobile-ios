//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import "DashboardTableViewCell.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>


@implementation DashboardTableViewCell

@synthesize _lbName, _lbDescription, _imgvIcon;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)dealloc
{
    _lbName = nil;
    
    _lbDescription = nil;

    _imgvIcon = nil;
    
    
    [super dealloc];
}


#pragma mark - Activity Cell methods 

- (void)customizeAvatarDecorations {
    //Add the CornerRadius
    [[_imgvIcon layer] setCornerRadius:6.0];
    [[_imgvIcon layer] setMasksToBounds:YES];
    
    //Add the border
    [[_imgvIcon layer] setBorderColor:[UIColor colorWithRed:113./255 green:113./255 blue:113./255 alpha:1.].CGColor];
    CGFloat borderWidth = 1.0;
    [[_imgvIcon layer] setBorderWidth:borderWidth];
}

- (void)configureCell:(NSString*)name description:(NSString*)description icon:(NSString*)iconURL {
    
    [self customizeAvatarDecorations];
    
    _lbDescription.backgroundColor = [UIColor clearColor];
    
    _lbName.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    _lbName.textColor = [UIColor colorWithRed:106.0/255 green:109.0/255 blue:112.0/255 alpha:1];
    _lbName.backgroundColor = [UIColor clearColor];
    
    
    _lbDescription.text =description?description:@"";
    _lbName.text = name;
    _imgvIcon.placeholderImage = [UIImage imageNamed:@"gadgetPlaceHolder"];
    _imgvIcon.imageURL = [NSURL URLWithString:iconURL];
    
}


@end
