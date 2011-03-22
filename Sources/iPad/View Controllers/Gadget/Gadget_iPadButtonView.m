//
//  GadgetButton.m
//  HKAF
//
//  Created by Tran Hoai Son on 3/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Gadget_iPadButtonView.h"
#import "GadgetViewController.h"
#import "Gadget_iPad.h"

@implementation Gadget_iPadButtonView

- (id)initWithFrame:(CGRect)rect
{
	self = [super initWithFrame:rect];
	if(self)
	{
		_btnGadget = [[UIButton alloc] initWithFrame:CGRectMake(11, 5, 50, 50)];
		[_btnGadget addTarget:self action:@selector(onBtnGadget:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_btnGadget];
		_gadget = [[Gadget_iPad alloc] init];
		_lbName = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 72, 42)];
		[_lbName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
		[_lbName setNumberOfLines:3];
		[_lbName setTextAlignment:UITextAlignmentCenter];
		[_lbName setBackgroundColor:[UIColor clearColor]];
		[self addSubview:_lbName];
	}
	return self;
}

- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
}

- (void)setGadget:(Gadget_iPad*)gadget
{
	_gadget = gadget;
}

- (Gadget_iPad*)getGadget
{
	return _gadget;
}

- (void)setName:(NSString*)name
{
	_lbName.text = name;
}

- (void)setIcon:(UIImage*)icon
{
	_imgIcon = icon;
	[_btnGadget setBackgroundImage:_imgIcon forState:UIControlStateNormal];
}

- (void)setUrl:(NSURL*)url
{
	_url = url;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)onBtnGadget:(id)sender
{
	[_delegate onGadgetButton:self];	
}
@end
