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

#define EXO_TEXT_FIELD_PADDING_WIDTH 30
@interface CloudViewUtils()
+(UILabel *)labelWithText:(NSString *)text andFont:(UIFont *)font andTextColor:(UIColor *)color;
@end

@implementation CloudViewUtils


// insert an icon to the left of the text field
+ (void)configureTextField:(UITextField *)tf withIcon:(NSString *)iconName
{
    
    [tf setBackgroundColor:[UIColor whiteColor]];
    CGColorRef colorRef = UIColorFromRGB(0xCCCCCC).CGColor;
    [tf.layer setBorderColor:colorRef];
    [tf.layer setBorderWidth:1.0];
    [tf.layer setCornerRadius:4];
    //always show the left view
    tf.leftViewMode = UITextFieldViewModeAlways;
    
    //the view for the left of text field
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, EXO_TEXT_FIELD_PADDING_WIDTH, EXO_TEXT_FIELD_PADDING_WIDTH)];
    
    paddingView.backgroundColor = UIColorFromRGB(0xEEEEEE);
    
    UIImage *image = [UIImage imageNamed:iconName];
    CGRect paddingFrame = CGRectMake((EXO_TEXT_FIELD_PADDING_WIDTH - image.size.width)/2, (EXO_TEXT_FIELD_PADDING_WIDTH - image.size.height)/2, image.size.width, image.size.height);
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
    UIImage *stretchableImage = [image stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [button setBackgroundImage:stretchableImage forState:UIControlStateNormal];
}

+ (void)configure:(UIButton *)button withTitle:(NSString *)title andSubtitle:(NSString *)subtitle
{
    
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    UIFont *subTitleFont = [UIFont fontWithName:@"Helvetica-Bold" size:8];
    
    UILabel *titleLabel = [CloudViewUtils labelWithText:title andFont:titleFont andTextColor:[UIColor whiteColor]];
        
    float titleWidth = [[titleLabel text] sizeWithFont:titleFont].width;
    float titleX = (button.frame.size.width - titleWidth) / 2;
    [titleLabel setFrame:CGRectMake(titleX, -12, button.frame.size.width, button.frame.size.height)];
    
    [button addSubview:titleLabel];
    
    UILabel *subtitleLabel = [CloudViewUtils labelWithText:subtitle andFont:subTitleFont andTextColor:[UIColor whiteColor]];
    
    
    float subtitleWidth = [[subtitleLabel text] sizeWithFont:subTitleFont].width;
    float subtitleX = (button.frame.size.width - subtitleWidth) / 2;
    [subtitleLabel setFrame:CGRectMake(subtitleX, 0, button.frame.size.width, button.frame.size.height)];
    
    [button addSubview:subtitleLabel];
    
    [titleLabel  release];
    [subtitleLabel release];
}


//set title in 2 lines for a button
+ (void)setTitleForButton:(UIButton *)button with1stLine:(NSString *)line1 and2ndLine:(NSString *)line2
{
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica" size:9];
    
    UILabel *label1 = [CloudViewUtils labelWithText:line1 andFont:titleFont andTextColor:UIColorFromRGB(0x333333)];
    UILabel *label2 = [CloudViewUtils labelWithText:line2 andFont:titleFont andTextColor:UIColorFromRGB(0x333333)];
    
    float width1 = [label1.text sizeWithFont:titleFont].width;
    float height1 = [label1.text sizeWithFont:titleFont].width;
    
    float width2 = [label2.text sizeWithFont:titleFont].width;
    float height2 = [label2.text sizeWithFont:titleFont].width;
    
    float buttonWidth = button.frame.size.width;
    
    CGRect frame1 = CGRectMake((buttonWidth - width1)/2, -18, width1, height1);
    CGRect frame2 = CGRectMake((buttonWidth - width2)/2, -23, width2, height2);
    
    label1.frame = frame1;
    label2.frame = frame2;
    
    [button addSubview:label1];
    [button addSubview:label2];
}

+ (UILabel *)labelWithText:(NSString *)text andFont:(UIFont *)font andTextColor:(UIColor *)color
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.text = text;
    label.font = font;
    return  label;
}

+ (void)adaptCloudForm:(UIView *)view
{
    view.layer.masksToBounds = NO;
    view.layer.cornerRadius = 8;
    view.backgroundColor = UIColorFromRGB(0xF0F0F0);
    CGSize viewSize = view.bounds.size;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPath];
    [shadowPath moveToPoint:CGPointMake(5, viewSize.height - 5)];
    [shadowPath addLineToPoint:CGPointMake(viewSize.width - 5, viewSize.height - 5)];
    [shadowPath addLineToPoint:CGPointMake(viewSize.width - 5, viewSize.height + 10)];
    [shadowPath addLineToPoint:CGPointMake(viewSize.width / 2, viewSize.height - 3)];
    [shadowPath addLineToPoint:CGPointMake(5, viewSize.height + 10)];
    [shadowPath closePath];
    
    view.layer.shadowPath = shadowPath.CGPath;
    view.layer.shadowOffset = CGSizeMake(0,0);
    view.layer.shadowRadius = 4.0f;
    view.layer.shadowOpacity = 0.8f;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
}
@end
