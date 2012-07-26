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

@implementation AuthTabItem

@synthesize alternateIcon = _alternateIcon;


-(void) dealloc {
    [_alternateIcon release];
    [super dealloc];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize newSize;
    if (_device == DeviceIpad)
        newSize = CGSizeMake(80, 76);
    else if (_device == DeviceIphone) {
        newSize = CGSizeMake(50, 48);
    }
    return newSize;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if (self.icon && self.alternateIcon)
    {
        UIImage * iconImage = (self.highlighted || [self isSelectedTabItem]) ? self.alternateIcon : self.icon;
        CGFloat xOffset = (rect.size.width-iconImage.size.width)/2;
        CGFloat yOffset = (rect.size.height-iconImage.size.height)/2;
        [iconImage drawAtPoint:CGPointMake(xOffset, yOffset)];
        //xOffset += [iconImage size].width + kTabItemIconMargin;
    }
    
    [kTabItemTextColor set];
    
    CGContextRestoreGState(context);
}

- (void)setDeviceType:(DeviceType) deviceType {
    _device = deviceType;
}

+ (AuthTabItem *)tabItemWithTitle:(NSString *)title icon:(UIImage *)icon alternateIcon:(UIImage *)alternativeIcon device:(DeviceType)deviceType;
{
    AuthTabItem * tabItem = [[[AuthTabItem alloc] initWithTitle:title icon:icon] autorelease];
    tabItem.alternateIcon = alternativeIcon;
    [tabItem setDeviceType:deviceType];
    return tabItem;
}

@end
