//
//  GrayPageControl.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 10/21/10.
//  Copyright 2010 home. All rights reserved.
//

#import "GrayPageControl.h"


@implementation GrayPageControl

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
	
    activeImage = [[UIImage imageNamed:@"active_page_image.png"] retain];
    inactiveImage = [[UIImage imageNamed:@"inactive_page_image.png"] retain];
	
    return self;
}

-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage) dot.image = activeImage;
        else dot.image = inactiveImage;
    }
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

@end
