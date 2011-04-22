//
//  eXoFileActionView.m
//  eXoMobile
//
//  Created by Mai Thanh Xuyen on 8/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "eXoFileActionView.h"


@implementation eXoFileActionView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		tblFileAction = [[UITableView alloc] initWithFrame:frame];
		
		
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGContextRef myContext = UIGraphicsGetCurrentContext();
	UIImage *img = [UIImage imageNamed:@"contextMenu.png"];
	CGImageRef image = CGImageRetain(img.CGImage);
	CGRect imageRect;
	size_t h = CGImageGetHeight(image);
	size_t w = CGImageGetWidth(image);
	CGPoint point = CGPointMake(0, 0);
	imageRect.origin = CGPointMake(point.x, point.y);
	imageRect.size = CGSizeMake(w, h);
	CGContextDrawImage( myContext, CGRectMake( point.x, point.y, w, h),image );
}


- (void)dealloc {
    [tblFileAction release];	//Action list
    tblFileAction = nil;
    
    [super dealloc];
}


@end
