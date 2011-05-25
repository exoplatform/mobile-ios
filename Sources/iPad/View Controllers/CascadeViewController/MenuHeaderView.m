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

-(id)initWithFrame:(CGRect)frame andTitleImage:(UIImage *)image;
{
	if ((self = [super initWithFrame:frame]))
	{
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 18, image.size.width, image.size.height)];
		//imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.layer.cornerRadius = 3.f;
		imageView.layer.masksToBounds = NO;
		imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
		imageView.layer.shadowOffset = CGSizeMake(0, 3);
		imageView.layer.shadowOpacity = 0.5f;
		imageView.layer.shadowRadius = 3.0f;
		imageView.layer.shouldRasterize = YES;
		[self addSubview:imageView];
		
		textLabel = [[UILabel alloc] initWithFrame:CGRectMake(79, 11, 110, 48)];
		textLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        textLabel.adjustsFontSizeToFitWidth = YES;
		textLabel.textColor = [UIColor colorWithRed:(255.f/255.f) green:(255.f/255.f) blue:(255.f/255.f) alpha:1.f];
		textLabel.shadowOffset = CGSizeMake(0, 2);
		textLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.25];
		textLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:textLabel];
        
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
