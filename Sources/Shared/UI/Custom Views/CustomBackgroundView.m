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
