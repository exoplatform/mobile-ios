//
//  MenuWatermarkFooter.m
//  StackScrollView
//
//  Created by Aaron Brethorst on 5/15/11.
//  Copyright 2011 Structlab LLC. All rights reserved.
//

#import "MenuWatermarkFooter.h"

@implementation MenuWatermarkFooter

- (instancetype)initWithFrame:(CGRect)aRect
{
	if ((self = [super initWithFrame:aRect]))
	{
		UIView* topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 1)];
		topLine.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.25];
		[self addSubview:topLine];
		
		UIImageView *watermark = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 200, 79)];
		watermark.contentMode = UIViewContentModeCenter;
		watermark.image = [UIImage imageNamed:@"Ipad_exo_black.png"];
		[self addSubview:watermark];
	}
	return self;
}

@end

