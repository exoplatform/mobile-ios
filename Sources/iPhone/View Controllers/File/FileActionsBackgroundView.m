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
