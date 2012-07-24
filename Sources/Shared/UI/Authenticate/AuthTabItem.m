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

- (void)drawRect:(CGRect)rect {
    //  CGRect contentRect = rect;
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    UIColor * shadowColor = [UIColor blackColor];
    //    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 1.0f, [shadowColor CGColor]);
    CGContextSaveGState(context);   
    
    CGFloat xOffset = self.padding.width;
    
    if (self.icon && self.alternateIcon)
    {
        UIImage * iconImage = (self.highlighted || [self isSelectedTabItem]) ? self.alternateIcon : self.icon;
        [iconImage drawAtPoint:CGPointMake(xOffset, self.padding.height)];
        xOffset += [iconImage size].width + kTabItemIconMargin;
    }
    
    [kTabItemTextColor set];
    
    //    CGFloat heightTitle = [self.title sizeWithFont:kTabItemFont].height;
    //    CGFloat titleYOffset = (contentRect.size.height - heightTitle) / 2;
    //    [self.title drawAtPoint:CGPointMake(xOffset, titleYOffset) withFont:kTabItemFont];
    
    CGContextRestoreGState(context);
}

@end
