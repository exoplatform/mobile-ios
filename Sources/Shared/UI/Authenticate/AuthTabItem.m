//
//  AuthTabItem.m
//  eXo Platform
//
//  Created by exoplatform on 7/23/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
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


-(void) dealloc {
    [_alternateIcon release];
    [super dealloc];
}

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
    AuthTabItem * tabItem = [[[AuthTabItem alloc] initWithTitle:title icon:icon] autorelease];
    tabItem.alternateIcon = alternativeIcon;
    return tabItem;
}

@end
