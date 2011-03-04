//
//  GadgetButton.m
//  HKAF
//
//  Created by Tran Hoai Son on 3/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GadgetButtonView_iPhone.h"
#import "GadgetViewController_iPhone.h"

@implementation GadgetButtonView_iPhone

- (id)initWithFrame:(CGRect)rect
{
	self = [super initWithFrame:rect];
	if(self)
	{
		_btnGadget = [[UIButton alloc] initWithFrame:CGRectMake(18, 5, 63, 63)];
		[_btnGadget addTarget:self action:@selector(onBtnGadget:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_btnGadget];
		_lbName = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 90, 28)];
		[_lbName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
		[_lbName setNumberOfLines:2];
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

- (void)onBtnGadget:(id)sender
{
	[_delegate onGadgetButton:_url];	
}
@end
