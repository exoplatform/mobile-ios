//
//  eXoFilesView.m
//  eXoApp
//
//  Created by Tran Hoai Son on 7/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import "MessengerWindowViewController.h"
#import "MessageContentViewController.h"
#import "MessengerViewController.h"

@implementation MessengerWindowViewController

@synthesize delegate = _delegate, user = _user, heightOfKeyboard = _heightOfKeyboard;

-(void)dealloc {
    [super dealloc];
    [_user release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.title = [_user nickname];
    _txtViewMsg.backgroundColor = [UIColor clearColor];
    
    _scrMessageContent.contentSize = CGSizeMake(self.view.frame.size.width, 20);
    
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
    
    _scrMessageContent.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
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

- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
}

-(void) createChatMessageContentView:(BOOL)isMe message:(NSString*)msg{
    
    UILabel *lbMessageContent = [[UILabel alloc] initWithFrame:CGRectMake(25, _scrMessageContent.contentSize.height, self.view.frame.size.width - 40, 0)];
    lbMessageContent.font = [UIFont systemFontOfSize:13];
    
    lbMessageContent.text = msg;
    lbMessageContent.backgroundColor = [UIColor clearColor];
    lbMessageContent.lineBreakMode = UILineBreakModeWordWrap;
    lbMessageContent.numberOfLines = 0;
    [lbMessageContent sizeToFit];
    
    UIImageView *imgViewMsgContent = nil;
    
    if(isMe) {
        
        //Add images for Background Message
        UIImage* strechBg = [[UIImage imageNamed:@"ChatDiscussionUserMessageBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:22];
        
        CGRect frameForMsgBgContent = CGRectMake(0, lbMessageContent.frame.origin.y - 5, lbMessageContent.frame.size.width + 30, lbMessageContent.frame.size.height + 15);
        
        imgViewMsgContent = [[UIImageView alloc] initWithFrame:frameForMsgBgContent];
        imgViewMsgContent.image = strechBg;
        
        [_scrMessageContent addSubview:imgViewMsgContent];
        [_scrMessageContent addSubview:lbMessageContent];
        
    }
    else {
     
        CGRect frame = lbMessageContent.frame;
        frame.origin.x = self.view.frame.size.width - frame.size.width - 25;
        lbMessageContent.frame = frame;
        //Add images for Background Message
        UIImage* strechBg = [[UIImage imageNamed:@"ChatDiscussionBuddyMessageBg"] stretchableImageWithLeftCapWidth:20 topCapHeight:22];
        
        CGRect frameForMsgBgContent = CGRectMake(frame.origin.x - 5, lbMessageContent.frame.origin.y - 5, self.view.frame.size.width - frame.origin.x + 10, lbMessageContent.frame.size.height + 15);
        
        UIImageView *imgViewMsgContent = [[UIImageView alloc] initWithFrame:frameForMsgBgContent];
        imgViewMsgContent.image = strechBg;
        
        [_scrMessageContent addSubview:imgViewMsgContent];
        [_scrMessageContent addSubview:lbMessageContent];
        
    }
    
    CGSize scrollContentSize = _scrMessageContent.contentSize;
    
    scrollContentSize.height += lbMessageContent.frame.size.height + 20;
    _scrMessageContent.contentSize = scrollContentSize;

//    CGPoint bottomOffset = CGPointMake(0, [_scrMessageContent contentSize].height);
//    [_scrMessageContent setContentOffset: bottomOffset animated: YES];

    
    [imgViewMsgContent release];
    [lbMessageContent release];
}


- (IBAction)onBtnSendMessage
{
    if([_txtViewMsg.text isEqualToString:@""])
		return;
	
    NSString* msgContentStr = [_txtViewMsg text];
    
    [self createChatMessageContentView:YES message:msgContentStr];
    
    [_txtViewMsg setText:@""];
    
    
    if([_delegate respondsToSelector:@selector(sendChatMessage: to:)])
    {
        [_delegate sendChatMessage:msgContentStr to:[[_user jid] full]];
    }

}

- (void)receivedChatMessage:(XMPPMessage *)xmppMsg
{
    [self createChatMessageContentView:NO message:[xmppMsg stringValue]];
    
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
