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

#import "CloudViewUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "defines.h"

#define EXO_TEXT_FIELD_PADDING_WIDTH 30
@interface CloudViewUtils()
+(CGRect)frameForLabel:(UILabel *)label inRect:(CGRect)rect;
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
    float titleFontSize = 16;
    float titleXMinus = 7;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        titleFontSize = 25;
        titleXMinus = 12;
    }
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize ];
    UILabel *titleLabel = [CloudViewUtils labelWithText:title andFont:titleFont andTextColor:[UIColor whiteColor]];
        
    float titleWidth = [[titleLabel text] sizeWithAttributes:@{NSFontAttributeName: titleFont}].width;
    float titleX = (button.frame.size.width - titleWidth) / 2;
    [titleLabel setFrame:CGRectMake(titleX, -titleXMinus, button.frame.size.width, button.frame.size.height)];
    
    [button addSubview:titleLabel];
    
    /*
    UIFont *subTitleFont = [UIFont fontWithName:@"Helvetica-Bold" size:8];
    UILabel *subtitleLabel = [CloudViewUtils labelWithText:subtitle andFont:subTitleFont andTextColor:[UIColor whiteColor]];
    
    float subtitleWidth = [[subtitleLabel text] sizeWithFont:subTitleFont].width;
    float subtitleX = (button.frame.size.width - subtitleWidth) / 2;
    [subtitleLabel setFrame:CGRectMake(subtitleX, 0, button.frame.size.width, button.frame.size.height)];
    
    [button addSubview:subtitleLabel];
    [subtitleLabel release];
     */
}


//set title in 2 lines for a button
+ (void)setTitleForButton:(UIButton *)button with1stLine:(NSString *)line1 and2ndLine:(NSString *)line2
{
    UIFont *titleFont = [UIFont systemFontOfSize:11];
    
    UILabel *label1 = [CloudViewUtils labelWithText:line1 andFont:titleFont andTextColor:[UIColor darkGrayColor]];
    UILabel *label2 = [CloudViewUtils labelWithText:line2 andFont:titleFont andTextColor:[UIColor darkGrayColor]];
    
    float width1 = [label1.text sizeWithAttributes:@{NSFontAttributeName: titleFont}].width;
    float height1 = [label1.text sizeWithAttributes:@{NSFontAttributeName: titleFont}].width;
    
    float width2 = [label2.text sizeWithAttributes:@{NSFontAttributeName: titleFont}].width;
    float height2 = [label2.text sizeWithAttributes:@{NSFontAttributeName: titleFont}].width;
    
    float buttonWidth = button.frame.size.width;
    
    CGRect frame1 = CGRectMake((buttonWidth - width1)/2, -25, width1, height1);
    CGRect frame2 = CGRectMake((buttonWidth - width2)/2, -35, width2, height2);
    
    label1.frame = CGRectIntegral(frame1);
    label2.frame = CGRectIntegral(frame2);
    
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

//adds the rounded corner and shadow for the form container
+ (void)adaptCloudForm:(UIView *)view
{
    view.layer.masksToBounds = NO;
    view.layer.cornerRadius = 8;
    view.backgroundColor = UIColorFromRGB(0xF0F0F0);
    CGSize viewSize = view.bounds.size;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPath];
    [shadowPath moveToPoint:CGPointMake(5, viewSize.height - 5)];
    [shadowPath addLineToPoint:CGPointMake(viewSize.width - 5, viewSize.height - 5)];
    [shadowPath addLineToPoint:CGPointMake(viewSize.width - 5, viewSize.height + 8)];
    [shadowPath addLineToPoint:CGPointMake(viewSize.width / 2, viewSize.height - 3)];
    [shadowPath addLineToPoint:CGPointMake(5, viewSize.height + 8)];
    [shadowPath closePath];
    
    view.layer.shadowPath = shadowPath.CGPath;
    view.layer.shadowOffset = CGSizeMake(0,0);
    view.layer.shadowRadius = 5.0f;
    view.layer.shadowOpacity = 0.8f;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
}


//returns a frame that is in center of a view for a label
+(CGRect)frameForLabel:(UILabel *)label inRect:(CGRect)rect
{
    CGRect frame;
    frame.origin.x = (rect.size.width - [label.text sizeWithAttributes:@{NSFontAttributeName: label.font}].width) / 2;
    frame.origin.y = (rect.size.height - [label.text sizeWithAttributes:@{NSFontAttributeName: label.font}].height) / 2;
    frame.size = CGSizeMake([label.text sizeWithAttributes:@{NSFontAttributeName: label.font}].width,
                            [label.text sizeWithAttributes:@{NSFontAttributeName: label.font}].height);
    return frame;
}


+ (UIView *)styledLabelWithOrder:(NSString *)order andTitle:(NSString *)title withWidth:(float)width
{
    UIImage *orderImage = [UIImage imageNamed:@"number_bg"];
    UIImage *bgImage = [UIImage imageNamed:@"label"];
    UIImage *strechtBg = [bgImage stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    
    float viewWidth = width;
    float viewHeight = orderImage.size.height;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
   
    //the order view: circle with the number inside
    UIImageView *orderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, orderImage.size.width, orderImage.size.height)];
    orderView.image = orderImage;
    
    UIFont *orderFont = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    UILabel *orderLabel = [self labelWithText:order andFont:orderFont andTextColor:[UIColor whiteColor]];
    orderLabel.frame = [self frameForLabel:orderLabel inRect:orderView.frame];
    
    [orderView addSubview:orderLabel];
    
    float bgY = (viewHeight - bgImage.size.height) / 2;
    
    //the background image is overlapped by the circle and it is in the center of the view
    //its origin x is half of the circle width
    //its width + its origin x is equals the view's width
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(orderImage.size.width / 2, bgY, viewWidth - orderImage.size.width / 2, bgImage.size.height) ];
    bgView.image = strechtBg;
    
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    UILabel *titleLabel = [self labelWithText:title andFont:titleFont andTextColor:[UIColor darkGrayColor]];
    
    titleLabel.frame = [self frameForLabel:titleLabel inRect:view.frame];
    CGRect tmpFrame = titleLabel.frame;
    tmpFrame.origin.x = orderImage.size.width + 10;
    titleLabel.frame = tmpFrame;
    
    [view addSubview:bgView];
    [view addSubview:orderView];
    [view addSubview:titleLabel];
    
    return view;
}


@end
