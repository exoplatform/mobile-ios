//
//  ChatWindowViewController_iPhone.m
//  eXoApp
//
//  Created by exo on 9/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ChatWindowViewController_iPad.h"


// Implementation
@implementation ChatWindowViewController_iPad


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		// Custom initialization
        
	}
	return self;
}


- (void)dealloc {
    
    [_delegate release];
    
    [super dealloc];
}

- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    if((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        self.view.frame = CGRectMake(0, 0, 600, 1004);
    }
    else
    {
        self.view.frame = CGRectMake(500, 0, 600, 748);
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self changeOrientation:interfaceOrientation];
    return YES;
}



@end
