//
//  eXoApplicationsViewController.h
//  eXoApp
//
//  Created by Tran Hoai Son on 7/1/09.
//  Copyright 2009 home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class eXoFilesView;
@class eXoChatView;
@class eXoChatWindow;
@class XMPPUser;
@class XMPPClient;
@class XMPPStream;
@class XMPPJID;
@class XMPPMessage;
@class eXoFile_iPhone;
@class eXoFileAction;
@class Connection;

//==============================================================
@interface eXoChatUser : NSObject 
{
	XMPPUser*			_xmppUser;
	NSMutableArray*		_arrMessages;
	NSString*			_htmlStr;
}
- (void)setObjectWithXMPPUser:(XMPPUser*)xmppUser andArrMsg:(NSMutableArray*)arrMessages andHtmlstr:(NSString*)htmlStr;
- (XMPPUser*)getXmppUser;
- (NSString*)getChatUserId;
- (NSMutableArray*)getArrMessages;
- (void)setArrMessages:(NSMutableArray*)arrMessages;
- (NSString*)getHtmlStr;
- (void)setHtmlStr:(NSString*)htmlStr;

@end


//==============================================================
@interface eXoApplicationsViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIWebViewDelegate, UIActionSheetDelegate> {
	
	id						_delegate;
	IBOutlet UITableView*	_tblvGadgetsGrp;
	
	eXoFilesView*		_filesView;
	UIView*				_newsView;
	eXoChatView*		_chatView;
	eXoChatWindow*		_chatWindow;
	eXoFileAction*		_fileAction;
	NSString*			_currentChatUser;
	BOOL				_isNewMsg;
	UIView*				_tempView;
	
	UIButton *_btnNotificationRecievedMessage;
	int _countNotificationRecievedMessage;
	
	UIBarButtonItem*	_btnClose;	
	UIBarButtonItem*	_btnBack;
	UIBarButtonItem*	_btnFileAcion;
	UIBarButtonItem*	_btnChatViewBack;
	UIButton*			_btnChatSend;
	UIBarButtonItem*	_btnClearMsg;
	UIBarButtonItem*	_btnSignOut;
	
	
	NSMutableArray*		_arrDicts;
	eXoFile_iPhone*		_currenteXoFile;
	NSString*			_fileNameStackStr;
	
	XMPPClient*			_xmppClient;
	XMPPStream*			_xmppStream;
	Connection*			_conn;
	
	NSMutableArray*		_arrChatUsers;
	
	
	NSMutableArray*		_arrGadgets;
	NSURL*				_tmpURL;
	BOOL				_bFilesChatEnterred;
	BOOL				_bBackFromGadgets;
	
	UIImagePickerController* _thePicker;
	
	int					_selectedLanguage;
	NSDictionary*		_dictLocalize;
	
	UIActivityIndicatorView* _indicator;
	
	
	NSThread *startThread;
	NSThread *endThread;
}

@property (nonatomic, retain) UIBarButtonItem*	_btnSignOut;
@property (nonatomic, retain) IBOutlet UIBarButtonItem*	_btnBack;
@property (nonatomic, retain) UIBarButtonItem*	_btnFileAcion;
@property (nonatomic, retain) IBOutlet UIBarButtonItem*	_btnChatViewBack;
@property (nonatomic, retain) UIButton*	_btnChatSend;
@property (nonatomic, retain) IBOutlet UIBarButtonItem*	_btnClearMsg;
@property (nonatomic, retain) UIActivityIndicatorView* _indicator;
@property (nonatomic, retain) UIButton *_btnNotificationRecievedMessage;

@property (nonatomic, retain) IBOutlet UIView* _filesView;
@property (nonatomic, retain) IBOutlet UIView* _newsView;
@property (nonatomic, retain) IBOutlet UIView* _chatView;
@property (nonatomic, retain) IBOutlet UIView* _chatWindow;
@property (nonatomic, retain) eXoFileAction*	_fileAction;
@property (nonatomic, retain) NSString*			_currentChatUser;
@property BOOL				_isNewMsg;


@property (nonatomic, retain) XMPPStream* _xmppStream;
@property (nonatomic, retain) NSMutableArray* _arrDicts;
@property (nonatomic, retain) NSMutableArray* _arrChatUsers;
@property (nonatomic, retain) NSMutableArray* _arrGadgets;
@property (nonatomic, retain) eXoFile_iPhone* _currenteXoFile;
@property (nonatomic, retain) NSString* _fileNameStackStr;
@property int				_selectedLanguage;
@property (nonatomic, retain) NSDictionary*		_dictLocalize;

@property BOOL					_bBackFromGadgets;


- (void)setDelegate:(id)delegate;
- (void)addCloseBtn;
- (IBAction)onFilesBtn;
- (IBAction)onNewsBtn;
- (IBAction)onChatBtn;
- (IBAction)onCloseBtn;
- (IBAction)onChatViewBackBtn;
- (IBAction)onBackBtn;
- (void)setChatClient:(XMPPClient*)xmppClient;
- (void)setChatUsers:(NSArray*)arrUsers;
- (void)showChatWindowWithXMPPUser:(XMPPUser*)xmppUser listMsg:(NSMutableDictionary *)listMsg;
- (void)updateForEachExoChatUser:(XMPPUser*)xmppUser withArrMsg:(NSMutableArray*)arrMsg withHtmlStr:(NSString*)htmlStr;
- (void)receivedChatMsg:(XMPPMessage*)message listMsg:(NSMutableDictionary *)listMsg;

-(void)startInProgress;
-(void)createFileView;
- (void)setSelectedLanguage:(int)sel;
- (void)startInProgress;
- (void)createFileView;
- (NSDictionary*)getDictLocalize;

- (NSMutableArray*)getPersonalDriveContent:(eXoFile_iPhone *)file;

-(void)fileAction:(NSString *)protocol source:(NSString *)source destination:(NSString *)destination data:(NSData *)data;

@end
