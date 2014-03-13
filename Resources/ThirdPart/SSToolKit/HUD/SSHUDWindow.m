//
//  SSHUDWindow.m
//  SSToolkit
//
//  Created by Sam Soffes on 3/17/11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "SSHUDWindow.h"
#import "UIImage+SSToolkitAdditions.h"
#import "SSDrawingUtilities.h"
static SSHUDWindow *kHUDWindow = nil;

@implementation SSHUDWindow

@synthesize hidesVignette = _hidesVignette;

#pragma mark Class Methods

+ (SSHUDWindow *)defaultWindow {
	if (!kHUDWindow) {
		kHUDWindow = [[SSHUDWindow alloc] init];
	}
	return kHUDWindow;
}


#pragma mark NSObject

- (id)init {
	if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]])) {
		self.backgroundColor = [UIColor clearColor];
		self.windowLevel = UIWindowLevelStatusBar + 1.0f;
	}
	return self;
}


#pragma mark UIView

- (void)drawRect:(CGRect)rect {
	if (_hidesVignette) {
		return;
	}
    //apply https://github.com/soffes/sstoolkit/commit/4554f2c65af117402d3d326322389072f1304f47
    //to Draw SSHUDView's vingette with CoreGraphics
    //it will fix problem with iPhone 5 which is described at https://github.com/soffes/sstoolkit/issues/145
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGGradientRef gradient = SSGradientWithColors([UIColor colorWithWhite:0.0f alpha:0.1f], [UIColor colorWithWhite:0.0f alpha:0.5f]);
    CGPoint centerPoint  = CGPointMake(self.bounds.size.width / 2.0 , self.bounds.size.height / 2.0);
    CGContextDrawRadialGradient(context, gradient, centerPoint, 0.0f, centerPoint, fmaxf(self.bounds.size.width, self.bounds.size.height) / 2.0f, kCGGradientDrawsAfterEndLocation);
}


#pragma mark Setters

- (void)setHidesVignette:(BOOL)hide {
	_hidesVignette = hide;
	self.userInteractionEnabled = !hide;
	[self setNeedsDisplay];
}

@end
