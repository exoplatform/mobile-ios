//
//  eXoChatWindow.h
//  eXoApp
//
//  Created by exo on 9/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMPPClient;
@class XMPPUser;
@class XMPPMessage;
@class eXoChatUser;
@class eXoApplicationsViewController;
@class eXoOnChatList;

@interface eXoChatWindow : UIView <UITextViewDelegate> {
	
	eXoApplicationsViewController*						_delegate;
	XMPPClient*				_xmppClient;
	XMPPUser*				_xmppUser;	
	XMPPMessage*			_xmppMessage;
	
	NSMutableArray*			_arrMessages;
	NSString*				_strMessage;
	int						_intLatestRow;
	BOOL					_bShowInputMsgKeyboard;
	
	IBOutlet UIWebView*		_chatWebView;
	IBOutlet UITextView*	_txtViewMsg;
	IBOutlet UIImageView*	_newMsgImg;
	UITextField*			_txtInputMsg;
	NSMutableString*		_chatHtmlStr;
	
	NSMutableArray*			_arrChatUsers;
	

	NSString *iconChatMe;
	NSString *iconChatFriend;
	NSString *timeBg;
	
	NSString *topLeftStr;
	NSString *topRightStr;
	NSString *bottomLeftStr;
	NSString *bottomRightStr;
	NSString *topHorizontalStr;
	NSString *bottomHorizontalStr;
}

@property(nonatomic, retain) XMPPUser*				_xmppUser;
@property(nonatomic, retain) NSMutableArray*		_arrChatUsers;


- (void)initChatWindowWithDelegate:(eXoApplicationsViewController *)delegate andXMPPClient:(XMPPClient*)xmppClient 
					andExoChatUser:(eXoChatUser*)exoChatUser listMsg:(NSMutableDictionary *)listMsg;
- (eXoApplicationsViewController *)delegate;
- (void)onClearBtn;
- (void)onBtnSendMsg;
- (void)receivedChatMsg:(XMPPMessage*)message listMsg:(NSMutableDictionary *)listMsg;
- (void)hitAtView:(UIView*)view point:(CGPoint)point;
-(void)backToChatList;
- (void)moveFrameUp:(BOOL)bUp;

@end
