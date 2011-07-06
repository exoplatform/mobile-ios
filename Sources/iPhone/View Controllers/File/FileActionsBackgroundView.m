//
//  FileActionsBackgroundView.m
//  eXoMobile
//
//  Created by Mai Thanh Xuyen on 8/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FileActionsBackgroundView.h"
#import <QuartzCore/QuartzCore.h>


@interface FileActionsBackgroundView (PrivateMethods) 
- (void)applyDefaultStyle;
- (void)applyShinyBackgroundWithColor:(UIColor *)color;

@end


@implementation FileActionsBackgroundView


-(id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        [self applyDefaultStyle];
        [self applyShinyBackgroundWithColor:[UIColor colorWithRed:255./255 green:255./255 blue:255./255 alpha:1.]];
        
    }
    return self;
}


- (void)applyDefaultStyle {
    // curve the corners
    self.layer.cornerRadius = 4;
    
    // apply the border
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    // add the drop shadow
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    self.layer.shadowOpacity = 0.25;
}


- (void)applyShinyBackgroundWithColor:(UIColor *)color {
    
    // create a CAGradientLayer to draw the gradient on
    CAGradientLayer *layer = [CAGradientLayer layer];
    
    // get the RGB components of the color
    const CGFloat *cs = CGColorGetComponents(color.CGColor);
    
    // create the colors for our gradient based on the color passed in
    layer.colors = [NSArray arrayWithObjects:
                    (id)[color CGColor],
                    (id)[[UIColor colorWithRed:0.98f*cs[0] 
                                         green:0.98f*cs[1] 
                                          blue:0.98f*cs[2] 
                                         alpha:1] CGColor],
                    (id)[[UIColor colorWithRed:0.95f*cs[0] 
                                         green:0.95f*cs[1] 
                                          blue:0.95f*cs[2] 
                                         alpha:1] CGColor],
                    (id)[[UIColor colorWithRed:0.93f*cs[0] 
                                         green:0.93f*cs[1] 
                                          blue:0.93f*cs[2] 
                                         alpha:1] CGColor],
                    nil];
    
    // create the color stops for our gradient
    layer.locations = [NSArray arrayWithObjects:
                       [NSNumber numberWithFloat:0.0f],
                       [NSNumber numberWithFloat:0.49f],
                       [NSNumber numberWithFloat:0.51f],
                       [NSNumber numberWithFloat:1.0f],
                       nil];
    
    layer.frame = self.bounds;
    [self.layer insertSublayer:layer atIndex:0];
}



@end
