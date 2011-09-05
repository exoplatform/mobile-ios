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


@implementation MessengerWindowViewController

@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.title = @"Chat Windows";
    
    _scrMessageContent.contentSize = CGSizeZero;
    
    _txtViewMsg.delegate = self;
}


-(void)viewDidDisappear:(BOOL)animated
{
     if (![self.navigationController.viewControllers containsObject:self])
     {
//         [_xmppClient disconnect];
	}	
}

- (IBAction)onBtnSendMessage
{
    if([_txtViewMsg.text isEqualToString:@""])
		return;
	
    NSString* msgContentStr = [_txtViewMsg text];
    
    MessageContentViewController *msgContentView = [[MessageContentViewController alloc] initWithNibName:@"MessageContentViewController" bundle:nil];
    [msgContentView setContentView:self.view.frame avatar:[UIImage imageNamed:@""] message:msgContentStr left:YES];
    
    CGSize scrollContentSize = _scrMessageContent.contentSize;
    CGRect frame = msgContentView.view.frame;
    frame.origin.y = scrollContentSize.height;
    msgContentView.view.frame = frame;
    
    scrollContentSize.height += msgContentView.view.frame.size.height;
    _scrMessageContent.contentSize = scrollContentSize;
    [_scrMessageContent addSubview:msgContentView.view];
    
    [msgContentView release];
    
    [_txtViewMsg setText:@""];

    
    if([_delegate respondsToSelector:@selector(sendChatMessage:)])
    {
        [_delegate sendChatMessage:msgContentStr];
    }
	
}

- (void)receivedChatMessage:(XMPPMessage *)xmppMsg
{
    MessageContentViewController *msgContentView = [[MessageContentViewController alloc] initWithNibName:@"MessageContentViewController" bundle:nil];
    [msgContentView setContentView:self.view.frame avatar:[UIImage imageNamed:@"default-avatar"] message:[xmppMsg stringValue] left:YES];
    
    CGSize scrollContentSize = _scrMessageContent.contentSize;
    CGRect frame = msgContentView.view.frame;
    frame.origin.y = scrollContentSize.height;
    msgContentView.view.frame = frame;
    
    scrollContentSize.height += msgContentView.view.frame.size.height;
    _scrMessageContent.contentSize = scrollContentSize;
    [_scrMessageContent addSubview:msgContentView.view];
    
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



@end
