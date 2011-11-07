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
        UIImage *image = [UIImage imageNamed:@"NavBarIphone.png"];
        [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self setTintColor:[UIColor colorWithRed:122./255 
                                                                          green:122./255 
                                                                           blue:122./255 
                                                                          alpha:1.]];
}

/*
-(void)willMoveToWindow:(UIWindow *)newWindow{
	[super willMoveToWindow:newWindow];
	[self applyDefaultStyle];
}

- (void)applyDefaultStyle {	
	// add the drop shadow
    self.clipsToBounds = NO;
	self.layer.shadowColor = [[UIColor blackColor] CGColor];
	self.layer.shadowOffset = CGSizeMake(0.0, 3.0);
	self.layer.shadowOpacity = 0.25;
}
*/

@end
