//
//  CustomBackgroundView.m
//  eXo Platform
//
//  Created by exoplatform on 6/6/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import "CustomBackgroundView.h"

@implementation CustomBackgroundView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGRect bounds = rect;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:bounds];
    CGContextAddPath(context, [path CGPath]);
    CGContextClip(context);
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    UIImage * bgPattern = [UIImage imageNamed:@"activity-detail-background-pattern"];
    [bgPattern drawAsPatternInRect:bounds];
    CGContextRestoreGState(context);
    [super drawRect:rect];
}

@end
