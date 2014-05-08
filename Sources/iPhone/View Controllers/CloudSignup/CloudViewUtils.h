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

#import <Foundation/Foundation.h>

@interface CloudViewUtils : NSObject
+ (void)configureTextField:(UITextField *)tf withIcon:(NSString *)iconName;
+ (void)configureButton:(UIButton *)button withBackground:(NSString *)bgName;
+ (void)configure:(UIButton *)button withTitle:(NSString *)title andSubtitle:(NSString *)subtitle;
+ (void)setTitleForButton:(UIButton *)button with1stLine:(NSString *)line1 and2ndLine:(NSString *)line2;
//add the rounded corner and shadow for the form container
+ (void)adaptCloudForm:(UIView *)view;

+ (UIView *)styledLabelWithOrder:(NSString *)order andTitle:(NSString *)title withWidth:(float)width;

+(UILabel *)labelWithText:(NSString *)text andFont:(UIFont *)font andTextColor:(UIColor *)color;

@end
