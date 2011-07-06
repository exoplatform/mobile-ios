//
//  ChatWindowViewController_iPhone.h
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
@class MessengerViewController_iPhone;

//Chat windows
@interface ChatWindowViewController_iPhone : UIViewController <UITextViewDelegate> {
	
	//eXoApplicationsViewController*						_delegate;	//The delegate
    id                      _delegate;
	XMPPClient*				_xmppClient;	
	XMPPUser*				_xmppUser;	//Chat socket
	XMPPMessage*			_xmppMessage;	//Chat message
	
	NSMutableArray*			_arrMessages;	//Message list for each chat user
	NSString*				_strMessage;	//message content
	int						_intLatestRow;	//index to insert new message
	BOOL					_bShowInputMsgKeyboard;	//Show/hide keyboard
	
	IBOutlet UIWebView*		_chatWebView;	//Display chat content
	IBOutlet UITextView*	_txtViewMsg;	//Chat typing area
	IBOutlet UIImageView*	_newMsgImg;	//New message image
	UITextField*			_txtInputMsg;	//Chat typing area
	NSMutableString*		_chatHtmlStr;	//Chat content in HTML format
	
	NSMutableArray*			_arrChatUsers;	//Contact user
	
	//String 64 for chat icons
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

//Constructor
//- (void)initChatWindowWithDelegate:(eXoApplicationsViewController *)delegate andXMPPClient:(XMPPClient*)xmppClient andExoChatUser:(eXoChatUser*)exoChatUser listMsg:(NSMutableDictionary *)listMsg;
- (void)initChatWindowWithDelegate:(MessengerViewController_iPhone *)delegate andXMPPClient:(XMPPClient*)xmppClient 
					andExoChatUser:(eXoChatUser*)exoChatUser listMsg:(NSMutableDictionary *)listMsg;

- (eXoApplicationsViewController *)delegate;	//Get delegate
- (void)onClearBtn;	//Clear message content
//- (void)onBtnSendMsg;
- (IBAction)onBtnSendMsg:(id)sender;
- (void)receivedChatMsg:(XMPPMessage*)message listMsg:(NSMutableDictionary *)listMsg;	//Receive message
- (void)hitAtView:(UIView*)view point:(CGPoint)point;	//Detect touch
-(void)backToChatList;	//Back to contact list view
- (void)moveFrameUp:(BOOL)bUp;	//Change UI when keyboard is shown

@end
