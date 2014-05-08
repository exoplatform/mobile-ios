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

#import "RoundRectView.h"
#import <QuartzCore/QuartzCore.h>

#define kRoundRectViewCornerRadius 6.0

@implementation RoundRectViewMask

@synthesize squareCorners = _squareCorners;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
		self.squareCorners = YES;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat minx = CGRectGetMinX(rect);
    CGFloat midx = CGRectGetMidX(rect);
    CGFloat maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect);
    CGFloat midy = CGRectGetMidY(rect);
    CGFloat maxy = CGRectGetMaxY(rect);
	
	CGContextMoveToPoint(context, minx, midy);
	
	if (self.squareCorners) {
		CGContextAddLineToPoint(context, minx, miny);							// move to bottom-left
		CGContextAddLineToPoint(context, midx, miny);							// move to botttom-mid
		CGContextAddArcToPoint(context, maxx, miny, maxx, midy, kRoundRectViewCornerRadius); // add an arc in the bottom right corner
		CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, kRoundRectViewCornerRadius); // add an arc in the top right corner
		CGContextAddLineToPoint(context, minx, maxy);							// move to top-left
	} else {		
		CGContextAddArcToPoint(context, minx, miny, midx, miny, kRoundRectViewCornerRadius);
		CGContextAddArcToPoint(context, maxx, miny, maxx, midy, kRoundRectViewCornerRadius);
		CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, kRoundRectViewCornerRadius);
		CGContextAddArcToPoint(context, minx, maxy, minx, midy, kRoundRectViewCornerRadius);		
	}
	
    CGContextClosePath(context);
    CGContextFillPath(context);
}


@end

@implementation RoundRectView

@synthesize squareCorners;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self adjustMask];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self adjustMask];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self adjustMask];
}

- (void)adjustMask {
	if (nil == mask) {
		mask = [[RoundRectViewMask alloc] initWithFrame:CGRectZero];
		mask.squareCorners = self.squareCorners;
		self.layer.mask = mask.layer;
	}
	
    mask.frame = self.bounds;
	
    [mask setNeedsDisplay];
    [self setNeedsDisplay];
}

- (void)setSquareCorners:(BOOL)aSquareCorners {
    mask.squareCorners = aSquareCorners;
}

- (BOOL)squareCorners {
    return mask.squareCorners;
}

- (void)dealloc {
    [mask release];
    [super dealloc];
}


@end
