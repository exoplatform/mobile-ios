//
//  CloudViewUtils.h
//  eXo Platform
//
//  Created by vietnq on 7/2/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudViewUtils : NSObject
+ (void)configureTextField:(UITextField *)tf withIcon:(NSString *)iconName;
+ (void)configureButton:(UIButton *)button withBackground:(NSString *)bgName;
+ (void)configure:(UIButton *)button withTitle:(NSString *)title andSubtitle:(NSString *)subtitle;
+ (void)setTitleForButton:(UIButton *)button with1stLine:(NSString *)line1 and2ndLine:(NSString *)line2;
//add the rounded corner and shadow for the form container
+ (void)adaptCloudForm:(UIView *)view;
@end
