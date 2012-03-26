//
//  MessengerViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/15/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>


//========================================================================================

@class XMPPJID;
@class XMPPClient;
@class XMPPUser;
@class AppContainerViewController;
@class MainViewController;

@interface MessengerUser : NSObject 
{
	int					_intMessageCount;
	XMPPUser*			_xmppUser;
	NSMutableString*	_mstrHtmlPortrait;
	NSMutableString*	_mstrHtmlLanscape;
	
}

@property int _intMessageCount;
@property(nonatomic, retain) XMPPUser* _xmppUser;
@property(nonatomic, retain) NSMutableString* _mstrHtmlPortrait;
@property(nonatomic, retain) NSMutableString* _mstrHtmlLanscape;

- (void)creatHTMLstring;

@end



//========================================================================================
@interface MessengerViewController : UIViewController <UINavigationControllerDelegate, 
														UITableViewDelegate, 
														UITableViewDataSource, 
														UIPopoverControllerDelegate>
{
	MainViewController*						_delegate;
	NSDictionary*							_dictLocalize;
	int										_intSelectedLanguage;
	
	//IBOutlet UITableView*					_tblvUsers;
	UITableView*							_tblvUsers;
	
	NSMutableArray*							arrChatUsers;
	int										currentChatUserIndex;
	
	NSString*								iconChatMe;
	NSString*								iconChatFriend;
	NSString*								timeBg;
	
	NSString*								topLeftStr;
	NSString*								topRightStr;
	NSString*								bottomLeftStr;
	NSString*								bottomRightStr;
	NSString *								topHorizontalStr;
	NSString *								bottomHorizontalStr;
}

@property(nonatomic, retain)UITableView* _tblvUsers;

- (int)getCurrentChatUserIndex;
- (void)setCurrentChatUserIndex:(int)index;
- (NSArray *)getArrChatUsers;
- (void)setDelegate:(id)delegate;
- (int)getSelectedLanguage;
- (NSDictionary*)getLocalization;
//- (void)localize;
- (void)initMessengerParameters;
- (NSString *)createChatContentFor:(NSString *)chatName content:(NSString *)content isMe:(BOOL)isMe portrait:(BOOL)portrait;
- (void)updateAccountInfo;

+ (XMPPClient *)getXmppClient;
@end
