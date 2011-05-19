//
//  MenuHeaderView.m
//  StackScrollView
//
//  Created by Aaron Brethorst on 5/15/11.
//  Copyright 2011 Structlab LLC. All rights reserved.
//

#import "MenuHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MenuHeaderView
@synthesize imageView, textLabel;

- (id)initWithFrame:(CGRect)aFrame
{
	if ((self = [super initWithFrame:aFrame]))
	{
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 48, 48)];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.layer.cornerRadius = 3.f;
		imageView.layer.masksToBounds = NO;
		imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
		imageView.layer.shadowOffset = CGSizeMake(0, 3);
		imageView.layer.shadowOpacity = 0.5f;
		imageView.layer.shadowRadius = 3.0f;
		imageView.layer.shouldRasterize = YES;
		[self addSubview:imageView];
		
		textLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 11, 119, 48)];
		textLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
		textLabel.textColor = [UIColor colorWithRed:(188.f/255.f) green:(188.f/255.f) blue:(188.f/255.f) alpha:1.f];
		textLabel.shadowOffset = CGSizeMake(0, 2);
		textLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.25];
		textLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:textLabel];
        
        self.backgroundColor = [UIColor blueColor];
	}
	return self;
}

- (void)dealloc
{
	self.textLabel = nil;
	self.imageView = nil;
	
	[super dealloc];
}

@end
