//
//  eXoApplicationsViewController.h
//  eXoApp
//
//  Created by Tran Hoai Son on 7/1/09.
//  Copyright 2009 home. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class eXoFilesView;
@class eXoChatView;
@class eXoChatWindow;
@class XMPPUser;
@class XMPPClient;
@class XMPPStream;
@class XMPPJID;
@class XMPPMessage;
@class eXoFile_iPhone;
@class eXoFileActionViewController;
@class Connection;

//==============================================================
//Chat user controller
@interface eXoChatUser : NSObject 
{
	XMPPUser*			_xmppUser;	//XMPP user controller
	NSMutableArray*		_arrMessages;	//Message list for users
	NSString*			_htmlStr;	//Message content in HTML format
}
//Constructor
- (void)setObjectWithXMPPUser:(XMPPUser*)xmppUser andArrMsg:(NSMutableArray*)arrMessages andHtmlstr:(NSString*)htmlStr;
//Gettors
- (XMPPUser*)getXmppUser;
- (NSString*)getChatUserId;
- (NSMutableArray*)getArrMessages;
- (void)setArrMessages:(NSMutableArray*)arrMessages;
- (NSString*)getHtmlStr;
- (void)setHtmlStr:(NSString*)htmlStr;

@end


//==============================================================
//Main app view controller view, inclunding: File, Chat, Gadget
@interface eXoApplicationsViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIWebViewDelegate, UIActionSheetDelegate> {
	
	id						_delegate;	//The delegate
	IBOutlet UITableView*	_tblvGadgetsGrp;	//Apps list view
	
	//eXoFilesView*		_filesView;	//Files view
	UIView*				_newsView;	
	eXoChatView*		_chatView;	//Chats view
	eXoChatWindow*		_chatWindow;	//Chat windows
	eXoFileActionViewController*		_fileAction;		//File action view controller
	NSString*			_currentChatUser;	//Current chat namr
	BOOL				_isNewMsg;	//Is new message
	UIView*				_tempView;	//Top view of chat app
	
	UIButton *_btnNotificationRecievedMessage;	//New message notification
	int _countNotificationRecievedMessage;	//New message count
	
	UIBarButtonItem*	_btnClose;	//Close button
	UIBarButtonItem*	_btnBack;	//Back button
	UIBarButtonItem*	_btnFileAcion;	//File actions button
	UIBarButtonItem*	_btnChatViewBack;	//Back to chat list
	UIButton*			_btnChatSend;	//Send message button
	UIBarButtonItem*	_btnClearMsg;	//Clear  message button
	UIBarButtonItem*	_btnSignOut;	//Signout button
	
	
	NSMutableArray*		_arrDicts;		//File array
	//eXoFile_iPhone*		_currenteXoFile;	//Current file
	NSString*			_fileNameStackStr;	//File name tree
	//Chat, file socket
	XMPPClient*			_xmppClient;	
	XMPPStream*			_xmppStream;	
	Connection*			_conn;	
	
	NSMutableArray*		_arrChatUsers;	//Contact array
	
	
	NSMutableArray*		_arrGadgets;	//Gadget array 
	NSURL*				_tmpURL;
	BOOL				_bFilesChatEnterred;	//Go into chat from file view
	BOOL				_bBackFromGadgets;	//Back from gadget view
	
	UIImagePickerController* _thePicker;	//Image picker
	
	int					_selectedLanguage;	//Language index
	NSDictionary*		_dictLocalize;	//Language dictionary
	
	UIActivityIndicatorView* _indicator;	//Loading indicator
	
	
	NSThread *startThread;	//Thread for starting get data
	NSThread *endThread;	//Thread for ending get data
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
@property (nonatomic, retain) eXoFileActionViewController*	_fileAction;
@property (nonatomic, retain) NSString*			_currentChatUser;
@property BOOL				_isNewMsg;


@property (nonatomic, retain) XMPPStream* _xmppStream;
@property (nonatomic, retain) NSMutableArray* _arrDicts;
@property (nonatomic, retain) NSMutableArray* _arrChatUsers;
@property (nonatomic, retain) NSMutableArray* _arrGadgets;
//@property (nonatomic, retain) eXoFile_iPhone* _currenteXoFile;
@property (nonatomic, retain) NSString* _fileNameStackStr;
@property int				_selectedLanguage;
@property (nonatomic, retain) NSDictionary*		_dictLocalize;

@property BOOL					_bBackFromGadgets;


- (void)setDelegate:(id)delegate;	//Set delegate
- (void)addCloseBtn;	//Add close button to view
- (IBAction)onFilesBtn;	//Reload file view
//- (IBAction)onNewsBtn;	
- (IBAction)onChatBtn;	//Reload chat view
- (IBAction)onCloseBtn;	//Close view
- (IBAction)onChatViewBackBtn;	//Back to chat list
- (IBAction)onBackBtn;	//Up to parent directory
- (void)setChatClient:(XMPPClient*)xmppClient;	//Set XMPP client
- (void)setChatUsers:(NSArray*)arrUsers;	//Set chat array
- (void)showChatWindowWithXMPPUser:(XMPPUser*)xmppUser listMsg:(NSMutableDictionary *)listMsg;	//Start chat windows
- (void)updateForEachExoChatUser:(XMPPUser*)xmppUser withArrMsg:(NSMutableArray*)arrMsg withHtmlStr:(NSString*)htmlStr;	//Update chat message for users
- (void)receivedChatMsg:(XMPPMessage*)message listMsg:(NSMutableDictionary *)listMsg;	//Receive message

- (void)startInProgress;	//Start getting data thread
- (void)createFileView;	//File view
- (void)setSelectedLanguage:(int)sel;	//Set language

- (NSDictionary*)getDictLocalize;	//Get luanguage dictionary

- (NSMutableArray*)getPersonalDriveContent:(eXoFile_iPhone *)file;	//Get file, folder list

//File actions
-(void)fileAction:(NSString *)protocol source:(NSString *)source destination:(NSString *)destination data:(NSData *)data;	

@end
