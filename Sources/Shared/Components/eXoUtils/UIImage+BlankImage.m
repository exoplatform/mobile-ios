//
//  UIImage+BlankImage.m
//  UITransition
//  Add new function create blank image with color and size parameter
//
//  Created by Ta Minh Quan on 12/9/13.
//  Copyright (c) 2013 CapTech. All rights reserved.
//

#import "UIImage+BlankImage.h"

@implementation UIImage (Blank)
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size

{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}
@end
