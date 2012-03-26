//
//  ContainerCell.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/31/11.
//  Copyright 2011 home. All rights reserved.
//

#import "ContainerCell.h"


@implementation ContainerCell

- (void)attachContainer:(UIView*)view 
{
	[_vContainer removeFromSuperview];
	[_vContainer release];
	_vContainer = [view retain];
	[self addSubview:view];
}

@end
