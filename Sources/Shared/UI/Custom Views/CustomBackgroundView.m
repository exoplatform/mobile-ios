//
//  CustomBackgroundView.m
//  eXo Platform
//
//  Created by exoplatform on 6/6/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import "CustomBackgroundView.h"

@implementation CustomBackgroundView

const float kPatternWidth = 150.;
const float kPatternHeight = 120.;

void DrawPatternCellCallback(void *info, CGContextRef context)
{
    UIImage *image = [UIImage imageNamed:@"HomeMenuBg.png"];
    CGContextDrawImage(context, CGRectMake(0, 0, kPatternWidth, kPatternHeight), image.CGImage);
    
}

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
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);
    const CGRect patternBounds = CGRectMake(0, 0, kPatternWidth, kPatternHeight);
    const CGPatternCallbacks kPatternCallbacks = {0, &DrawPatternCellCallback, NULL};
    CGPatternRef pattern = CGPatternCreate(NULL, patternBounds, CGAffineTransformIdentity, kPatternWidth, kPatternHeight, kCGPatternTilingConstantSpacing, true, &kPatternCallbacks);
    CGFloat alpha = 1.0;
    CGContextSetFillPattern(context, pattern, &alpha);
    CGPatternRelease(pattern);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
}

@end