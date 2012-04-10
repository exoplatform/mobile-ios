//
//  UIToolbar+eXoCustomIphone.m
//  eXo Platform
//
//  Created by exo on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIToolbar+eXoCustomIphone.h"

@implementation UIToolbar (eXoCustomIphone)

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"NavBarIphone.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self setTintColor:[UIColor colorWithRed:112./255 green:112./255 blue:112./255 alpha:1.]];
}

@end
