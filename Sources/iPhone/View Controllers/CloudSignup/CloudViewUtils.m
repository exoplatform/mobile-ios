//
//  CloudViewUtils.m
//  eXo Platform
//
//  Created by vietnq on 7/2/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "CloudViewUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "defines.h"
@implementation CloudViewUtils

// insert an icon to left of the text field
+ (void)configureTextField:(UITextField *)tf withIcon:(NSString *)iconName
{
    
    [tf setBackgroundColor:[UIColor whiteColor]];
    CGColorRef colorRef = UIColorFromRGB(0xCCCCCC).CGColor;
    [tf.layer setBorderColor:colorRef];
    [tf.layer setBorderWidth:1.0];
    [tf.layer setCornerRadius:5.0f];
    //always show the left view
    tf.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    paddingView.backgroundColor = UIColorFromRGB(0xEEEEEE);
    
    UIImage *image = [UIImage imageNamed:iconName];
    CGRect paddingFrame = CGRectMake((30 - image.size.width)/2, (30 - image.size.height)/2, image.size.width, image.size.height);
    //center the image in the padding view
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:paddingFrame];
    imageView.image = image;
    
    [paddingView addSubview:imageView];
    tf.leftView = paddingView;
    
    [imageView release];
    [paddingView release];
    
}

// configure background for a button
+ (void)configureButton:(UIButton *)button withBackground:(NSString *)bgName
{
    UIImage *image = [UIImage imageNamed:bgName];
    float leftCapWidth = 5;
    UIImage *stretchableImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:0];
    [button setBackgroundImage:stretchableImage forState:UIControlStateNormal];
}
@end
