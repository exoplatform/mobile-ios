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
 
    CGRect rectTextField = _txtViewMsg.frame;
    CGRect rectSendBtn = _btnSendMessage.frame;
    
    if((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        self.view.frame = CGRectMake(0, 0, 600, 1004);
        _heightOfKeyboard = HEIGHT_OF_KEYBOARD_IPAD_PORTRAIT;
        
        rectTextField = CGRectMake(20, 936, 430, 58);
        rectSendBtn = CGRectMake(470, 962, 120, 36);
    }
    else
    {
        self.view.frame = CGRectMake(500, 0, 600, 748);
        _heightOfKeyboard = HEIGHT_OF_KEYBOARD_IPAD_LANDSCAPE;
        
        rectTextField = CGRectMake(20, 680, 436, 58);
        rectSendBtn = CGRectMake(470, 706, 120, 36);
    }
    
    _txtViewMsg.frame = rectTextField;
    _btnSendMessage.frame = rectSendBtn;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self changeOrientation:interfaceOrientation];
    return YES;
}



@end
