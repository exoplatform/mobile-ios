//
//  ChatWindowViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 7/1/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MessengerUser;
@class XMPPClient;
@class XMPPUser;
@class XMPPMessage;

//Chat windows
@interface ChatWindowViewController : UIViewController <UIScrollViewDelegate, UIWebViewDelegate> {
	id										_delegate;	//The delegate, point to MainViewController
	NSDictionary*							_dictLocalize;	//dictionary
	int										_intSelectedLanguage;	//index of current language: 0-English, 1-French
	
	XMPPClient*								_xmppClient;	//Chat socket
	MessengerUser*							_messengerUser;	//Chat user

	int										_intBShowKeyboard;	//keyboard is showing or not
	BOOL									_bLandscape;	//Lanscape or portrait mode
	
	UIWebView*								_wvChatContentDisplay;	//Display chat content
	UIWebView*								_wvChatContentDisplayUp;
	
	IBOutlet UIView*						_vTextInputArea;
	IBOutlet UIImageView*					_imgvNewMsgArea;	//New message image
	IBOutlet UITextView*					_tvTextInput;	//Chat typing area
	IBOutlet UIButton*						_btnSend;	//Send button
	UIBarButtonItem*						_bbtnClear;	//Clear chat content
	UIBarButtonItem*						_bbtnClose;	//Close current chat
	
	NSMutableString*						_strHtml; //Chat content in HTML format
	UIInterfaceOrientation					_interfaceOrientation;	//keep track of device orientation
}

@property int _intBShowKeyboard;
@property BOOL _bLandscape;
@property (nonatomic, retain) UIWebView* _wvChatContentDisplay;
@property (nonatomic, retain) UIView* _imgvNewMsgArea;
@property (nonatomic, retain) UIView* _vTextInputArea;
@property (nonatomic, retain) UITextView* _tvTextInput;
@property (nonatomic, retain) UIButton* _btnSend;
@property (nonatomic, retain) MessengerUser* _messengerUser;

- (void)setDelegate:(id)delegate;	//Set the delegate
- (void)localize;	//Set language dictionary
- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation;	//Change orientation
- (void)initChatWindowWithUser:(MessengerUser*)messengerUser andXMPPClient:(XMPPClient*)xmppClient;	//Create new instane of the Class
- (void)setHiddenForNewMessageImage:(BOOL)isHidden;	//show new message alert
- (void)setBLandscape:(BOOL)bLandscape;	//Change orientation
- (void)addNotification;	//Notify new chat message
- (void)removeNotification;	//Remove new chat message notification
- (IBAction)sendMessage:(id)sender;	//Send message action
- (void)createChatContent:(NSString *)content;	//Create html chat content
- (void)receivedChatMsg;	//Receive chat message
- (void)moveFrameUp:(BOOL)bUp;	//Change UI when keyboard is shown or not

@end
