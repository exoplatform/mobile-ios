//
//  UINavigationBar+eXoCustomIphone.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 12/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UINavigationBar+eXoCustomIphone.h"
#import <QuartzCore/QuartzCore.h>


@implementation UINavigationBar (eXoCustomIphone) 

- (void) drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"NavbarBg.png"];
    [image drawAsPatternInRect:rect];
    [self setTintColor:[UIColor colorWithRed:40./255 green:90./255 blue:132./255 alpha:1.]];
}


-(void)willMoveToWindow:(UIWindow *)newWindow{
	[super willMoveToWindow:newWindow];
	[self applyDefaultStyle];
}

- (void)applyDefaultStyle {	
	// add the drop shadow
    self.clipsToBounds = NO;
	self.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
	self.layer.shadowOffset = CGSizeMake(0.0, 1.0);
	self.layer.shadowOpacity = 0.50;
}


@end
