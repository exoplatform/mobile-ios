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

#import "AuthTabItem.h"
#import "defines.h"
#import "JMTabConstants.h"

// Tabs dimensions of iPad (80x73) and iPhone (53x48)
#define iPadCellWidth 80.
#define iPadCellHeight 73.
#define iPhoneCellWidth 53.
#define iPhoneCellHeight 48.

@implementation AuthTabItem

@synthesize alternateIcon = _alternateIcon;


// Set the dimension of the tabs for the iPhone (50x48) and the iPad (80x73)
- (CGSize)sizeThatFits:(CGSize)size {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? CGSizeMake(iPadCellWidth, iPadCellHeight) : CGSizeMake(iPhoneCellWidth, iPhoneCellHeight);
}

- (void)drawRect:(CGRect)rect {
    if (self.icon && self.alternateIcon)
    {
        UIImage * iconImage = (self.highlighted || [self isSelectedTabItem]) ? self.alternateIcon : self.icon;
        // Position the image at the center
        CGFloat xOffset = (rect.size.width-iconImage.size.width)/2;
        CGFloat yOffset = (rect.size.height-iconImage.size.height)/2;
        [iconImage drawAtPoint:CGPointMake(xOffset, yOffset)];
    }
}

+ (AuthTabItem *)tabItemWithTitle:(NSString *)title icon:(UIImage *)icon alternateIcon:(UIImage *)alternativeIcon;
{
    AuthTabItem * tabItem = [[AuthTabItem alloc] initWithTitle:title icon:icon];
    tabItem.alternateIcon = alternativeIcon;
    return tabItem;
}

@end
