//
//  MessengerViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/15/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatWindowViewController.h"

//========================================================================================

@class XMPPJID;
@class XMPPClient;
@class XMPPUser;
@class AppContainerViewController;
@class MainViewController;

//User messenger
@interface MessengerUser : NSObject 
{
	int					_intMessageCount; //Number of message user has received
	XMPPUser*			_xmppUser;	//XMPP user, connect to XMPPClient
	NSMutableString*	_mstrHtmlPortrait;	//Message content for portait mode
	NSMutableString*	_mstrHtmlLanscape;	//Message content for lanscape mode
	
}

@property int _intMessageCount;
@property(nonatomic, retain) XMPPUser* _xmppUser;
@property(nonatomic, retain) NSMutableString* _mstrHtmlPortrait;
@property(nonatomic, retain) NSMutableString* _mstrHtmlLanscape;

- (void)creatHTMLstring; //Create chat content

@end



//========================================================================================

//List of chat users
@interface MessengerViewController : UIViewController <UITableViewDelegate, 
UITableViewDataSource> /*<UINavigationControllerDelegate, 
														UITableViewDelegate, 
														UITableViewDataSource, 
														UIPopoverControllerDelegate>*/
{
	//MainViewController*						_delegate; // Point to MainViewController
    id                                      _delegate;
	NSDictionary*							_dictLocalize;	//Language dictionary
	int										_intSelectedLanguage;	//index of language
	
	IBOutlet UITableView*					_tblvUsers;
	//UITableView*							_tblvUsers;	//show contact list
	
	NSMutableArray*							arrChatUsers;	//list of contacr
	int										currentChatUserIndex;	//index of current chat user
	
	//String 64 for chat icons
	NSString*								iconChatMe;	
	NSString*								iconChatFriend;
	NSString*								timeBg;
	
	NSString*								topLeftStr;
	NSString*								topRightStr;
	NSString*								bottomLeftStr;
	NSString*								bottomRightStr;
	NSString *								topHorizontalStr;
	NSString *								bottomHorizontalStr;
    
    ChatWindowViewController*               _chatWindowViewController;
}

@property int currentChatUserIndex;
@property(nonatomic, retain)UITableView* _tblvUsers;

- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation;

- (int)getCurrentChatUserIndex;	//Get current chat user index in the list
- (void)setCurrentChatUserIndex:(int)index;	//Set current chat user index in the list
- (NSArray *)getArrChatUsers;	//Get chat user list
- (void)setDelegate:(id)delegate;	//Set the delegate
- (int)getSelectedLanguage;	//Get current language index
- (NSDictionary*)getLocalization;	//Get current language dictionary
//- (void)localize;
- (void)initMessengerParameters;	//Creat parametters for new chat 
- (NSString *)createChatContentFor:(NSString *)chatName content:(NSString *)content isMe:(BOOL)isMe portrait:(BOOL)portrait;	//Format the chat content
- (void)updateAccountInfo; //Get contact info
- (void)receivedChatMsg;
+ (XMPPClient *)getXmppClient;	//Get chat socket
@end
