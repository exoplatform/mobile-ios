//
//  MenuWatermarkFooter.m
//  StackScrollView
//
//  Created by Aaron Brethorst on 5/15/11.
//  Copyright 2011 Structlab LLC. All rights reserved.
//

#import "MenuWatermarkFooter.h"

@implementation MenuWatermarkFooter

@synthesize buttonForSettings=_buttonForSettings;


- (id)initWithFrame:(CGRect)aRect
{
	if ((self = [super initWithFrame:aRect]))
	{
		UIView* topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 1)];
		topLine.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.25];
		[self addSubview:topLine];
		[topLine release];
		
		
        //create the button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        //the button should be as big as a table view cell
        [button setFrame:CGRectMake(10, 10, 200, 44)];
        
        //set title, font size and font color
        [button setTitle:@"Settings" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
		button.titleLabel.shadowOffset = CGSizeMake(0, 2);
		button.titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.25];        
        
        //set the button to setting to this new one.
        _buttonForSettings = button;
        
        //add the button to the view
        [self addSubview:button];
        
	}
	return self;
}

@end
