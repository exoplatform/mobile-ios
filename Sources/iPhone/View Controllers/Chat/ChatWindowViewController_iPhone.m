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


/*
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event 
{
	UIView* hitView = [super hitTest: point withEvent: event];
	[self hitAtView:hitView point:point];
	return hitView;
}

- (void)hitAtView:(UIView*)view point:(CGPoint)point
{
	CGRect textFieldRect = [_txtViewMsg frame];
	if(point.x >= textFieldRect.origin.x && point.x <= textFieldRect.origin.x + textFieldRect.size.width && 
		point.y >= textFieldRect.origin.y && point.y <= textFieldRect.origin.y + textFieldRect.size.height)
	{
		if(!_bShowInputMsgKeyboard) {
			[self moveFrameUp:YES];
			[_txtViewMsg becomeFirstResponder];
		}
		
	}
	if(point.y < textFieldRect.origin.y)
		if(_bShowInputMsgKeyboard)
		{
			[self moveFrameUp:NO];
			[_txtViewMsg resignFirstResponder];
		}
		
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self moveFrameUp:YES];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	[self moveFrameUp:NO];
	return YES;
}

-(void)backToChatList
{
    /*
	_delegate._currentChatUser = @"";
	_delegate.navigationItem.title = @"Chat";
    
//	[_txtViewMsg resignFirstResponder];
	//self.frame = CGRectMake(0, 0, 320, 460);
//    self.view.frame = CGRectMake(0, 0, 320, 460);
}

- (void)moveFrameUp:(BOOL)bUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
	
    // Make changes to the view's frame inside the animation block. They will be animated instead
    // of taking place immediately.
    //CGRect rect = self.frame;
    CGRect rect = self.view.frame;
	
    if (bUp)
	{
		if(!_bShowInputMsgKeyboard) {
			_bShowInputMsgKeyboard = YES;
		}
		
		rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;	
		
	}		
	else
	{
		
		if(_bShowInputMsgKeyboard) {
			_bShowInputMsgKeyboard = NO;
		}
		
		rect.origin.y += kOFFSET_FOR_KEYBOARD;
		rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
	
    //self.frame = rect;
    self.view.frame = rect;
	[_chatWebView loadHTMLString:_chatHtmlStr baseURL:nil];
	[UIView commitAnimations];	
}
 */
 
@end
