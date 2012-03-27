//
//  Checkbox.m
//  RestaurantMng
//
//  Created by Tran Hoai Son on 3/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Checkbox.h"


@implementation Checkbox

- (id)initWithFrame:(CGRect)rect andState:(BOOL)bTouch
{
	self = [super initWithFrame:rect];
	if(self)
	{
		_bTouched = bTouch;
		if(_bTouched)
		{
			[self setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
		}
		else
		{
			[self setBackgroundImage:[UIImage imageNamed:@"notchecked.png"] forState:UIControlStateNormal];
		}
	}
	return self;
}

- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
}

- (void)setStatus:(BOOL)status
{
	_bTouched = status;
	if(_bTouched)
	{
		[self setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
	}
	else
	{
		[self setBackgroundImage:[UIImage imageNamed:@"notchecked.png"] forState:UIControlStateNormal];
	}
}

- (BOOL)getStatus
{
	return _bTouched;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	//AudioServicesPlaySystemSound(1000);
	//AudioServicesPlaySystemSound(1105);
	
	if(_bTouched)
	{
		_bTouched = NO;
		[self setBackgroundImage:[UIImage imageNamed:@"notchecked.png"] forState:UIControlStateNormal];
	}
	else
	{
		_bTouched = YES;
		[self setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
	}
	
	//[_delegate onCheckBoxBtn:self];
}
@end
