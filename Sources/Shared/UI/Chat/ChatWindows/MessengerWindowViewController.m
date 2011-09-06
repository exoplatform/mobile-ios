//
//  eXoFilesView.m
//  eXoApp
//
//  Created by Tran Hoai Son on 7/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import "MessengerWindowViewController.h"
#import "MessageContentViewController.h"
#import "XMPPMessage.h"
#import "XMPPJID.h"

@implementation MessengerWindowViewController

@synthesize delegate = _delegate, user = _user, heightOfKeyboard = _heightOfKeyboard;

- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.title = @"Chat Windows";
    
    _scrMessageContent.contentSize = CGSizeZero;
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:self.view.window];
}


-(void)viewDidDisappear:(BOOL)animated
{
     if (![self.navigationController.viewControllers containsObject:self])
     {
//         [_xmppClient disconnect];
	}	
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil]; 
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification 
                                                  object:nil]; 
}

- (void)moveViewAnimation:(int)offset
{
    // resize the scrollview
    CGRect scrViewFrame = _scrMessageContent.frame;
    scrViewFrame.size.height += offset;
    
    //Move typing message area
    CGRect imgViewBackgroundFrame = _imgViewMessengerBackground.frame;
    imgViewBackgroundFrame.origin.y += offset;
    
    CGRect imgViewNewMsgFrame = _imgViewNewMessage.frame;
    imgViewNewMsgFrame.origin.y += offset;
    
    CGRect txtViewMsgFrame = _txtViewMsg.frame;
    txtViewMsgFrame.origin.y += offset;
    
    CGRect btnSendMsgFrame = _btnSendMessage.frame;
    btnSendMsgFrame.origin.y += offset;
    
    //    Animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    
    [_scrMessageContent setFrame:scrViewFrame];
    [_imgViewMessengerBackground setFrame:imgViewBackgroundFrame];
    [_imgViewNewMessage setFrame:imgViewNewMsgFrame];
    [_txtViewMsg setFrame:txtViewMsgFrame];
    [_btnSendMessage setFrame:btnSendMsgFrame];
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
//    Move view down
    [self moveViewAnimation:_heightOfKeyboard];
    
//    Set ketboard flag
    _keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    
    if (_keyboardIsShown) {
        return;
    }
    
//    Move view up
    [self moveViewAnimation:-_heightOfKeyboard];

//    Set ketboard flag
    _keyboardIsShown = YES;
}

- (IBAction)onBtnSendMessage
{
    if([_txtViewMsg.text isEqualToString:@""])
		return;
	
    NSString* msgContentStr = [_txtViewMsg text];
    
    MessageContentViewController *msgContentView = [[MessageContentViewController alloc] initWithNibName:@"MessageContentViewController" bundle:nil];
    
    [_scrMessageContent addSubview:msgContentView.view];
    
    [msgContentView setContentView:self.view.frame.size.width avatar:[UIImage imageNamed:@"default-avatar"] message:msgContentStr left:NO];
    
    CGSize scrollContentSize = _scrMessageContent.contentSize;
    CGRect frame = msgContentView.view.frame;
    frame.origin.y = scrollContentSize.height;
    msgContentView.view.frame = frame;
    
    scrollContentSize.height += msgContentView.view.frame.size.height;
    _scrMessageContent.contentSize = scrollContentSize;

    
    [msgContentView release];
    
    [_txtViewMsg setText:@""];

    
    if([_delegate respondsToSelector:@selector(sendChatMessage: to:)])
    {
        [_delegate sendChatMessage:msgContentStr to:[[_user jid] full]];
    }
	
}

- (void)receivedChatMessage:(XMPPMessage *)xmppMsg
{
    MessageContentViewController *msgContentView = [[MessageContentViewController alloc] initWithNibName:@"MessageContentViewController" bundle:nil];
    
    [_scrMessageContent addSubview:msgContentView.view];
    
    [msgContentView setContentView:self.view.frame.size.width avatar:[UIImage imageNamed:@"default-avatar"] message:[xmppMsg stringValue] left:YES];
    
    CGSize scrollContentSize = _scrMessageContent.contentSize;
    CGRect frame = msgContentView.view.frame;
    frame.origin.y = scrollContentSize.height;
    msgContentView.view.frame = frame;
    
    scrollContentSize.height += msgContentView.view.frame.size.height;
    _scrMessageContent.contentSize = scrollContentSize;
    
    
    [msgContentView release];
    
    CGSize csz = _scrMessageContent.contentSize;
    CGSize bsz = _scrMessageContent.bounds.size;
    if (_scrMessageContent.contentOffset.y + bsz.height > csz.height) {
        [_scrMessageContent setContentOffset:CGPointMake(_scrMessageContent.contentOffset.x, csz.height - bsz.height) 
                    animated:YES];
    }
}

- (void)onBtnClearMessage
{
    
}

//TextViewDelegate Method
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
