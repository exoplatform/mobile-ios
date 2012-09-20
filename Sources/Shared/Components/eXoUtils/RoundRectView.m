//
//  RoundRectView.m
//  eXo Platform
//
//  Created by exoplatform on 8/29/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
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
