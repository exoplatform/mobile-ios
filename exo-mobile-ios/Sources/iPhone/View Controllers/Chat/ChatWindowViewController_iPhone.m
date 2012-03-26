//
//  ChatWindowViewController_iPhone.m
//  eXoApp
//
//  Created by exo on 9/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ChatWindowViewController_iPhone.h"



// Implementation
@implementation ChatWindowViewController_iPhone


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


- (void)viewWillDisappear:(BOOL)animated {
//    [self backToChatList];
}


- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    CGRect rect = _txtViewMsg.frame;    
//    rect.origin.y -= 44;
//    _txtViewMsg.frame = rect;
    
    if((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        _heightOfKeyboard = HEIGHT_OF_KEYBOARD_IPHONE_PORTRAIT;
    }
    else
    {
        _heightOfKeyboard = HEIGHT_OF_KEYBOARD_IPHONE_LANDSCAPE;
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self changeOrientation:interfaceOrientation];
    return NO;
}

 
@end
