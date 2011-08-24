//
//  TouchView.m
//  FindMe
//
//  Created by Tran Hoai Son on 11/1/08.
//  Copyright 2008 home. All rights reserved.
//

#import "TouchView.h"
#import "LoginViewController.h"


@implementation TouchView


- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// Initialization code
	}
	return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event   // recursively calls -pointInside:withEvent:. point is in frame coordinates
{
	UIView* hitView = [super hitTest: point withEvent: event];
	if(delegate && [delegate respondsToSelector:@selector(hitAtView: )])
	{
		[delegate hitAtView: hitView];
	}
	
	return hitView;
}


- (void)dealloc {
	[super dealloc];
}


@end
