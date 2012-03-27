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

@interface ChatWindowViewController : UIViewController <UIScrollViewDelegate, UIWebViewDelegate> {
	id										_delegate;
	NSDictionary*							_dictLocalize;
	int										_intSelectedLanguage;
	
	XMPPClient*								_xmppClient;
	MessengerUser*							_messengerUser;

	int										_intBShowKeyboard;
	BOOL									_bLandscape;
	
	UIWebView*								_wvChatContentDisplay;
	UIWebView*								_wvChatContentDisplayUp;
	
	IBOutlet UIView*						_vTextInputArea;
	IBOutlet UIImageView*					_imgvNewMsgArea;
	IBOutlet UITextView*					_tvTextInput;
	IBOutlet UIButton*						_btnSend;
	UIBarButtonItem*						_bbtnClear;
	UIBarButtonItem*						_bbtnClose;
	
	NSMutableString*						_strHtml;
	UIInterfaceOrientation					_interfaceOrientation;
}

@property int _intBShowKeyboard;
@property BOOL _bLandscape;
@property (nonatomic, retain) UIWebView* _wvChatContentDisplay;
@property (nonatomic, retain) UIView* _imgvNewMsgArea;
@property (nonatomic, retain) UIView* _vTextInputArea;
@property (nonatomic, retain) UITextView* _tvTextInput;
@property (nonatomic, retain) UIButton* _btnSend;
@property (nonatomic, retain) MessengerUser* _messengerUser;

- (void)setDelegate:(id)delegate;
- (void)localize;
- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)initChatWindowWithUser:(MessengerUser*)messengerUser andXMPPClient:(XMPPClient*)xmppClient;
- (void)setHiddenForNewMessageImage:(BOOL)isHidden;
- (void)setBLandscape:(BOOL)bLandscape;
- (void)addNotification;
- (void)removeNotification;
- (IBAction)sendMessage:(id)sender;
- (void)createChatContent:(NSString *)content;
- (void)receivedChatMsg;
- (void)moveFrameUp:(BOOL)bUp;
@end
