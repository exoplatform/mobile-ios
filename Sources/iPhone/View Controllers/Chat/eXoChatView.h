//
//  eXoFilesView.h
//  eXoApp
//
//  Created by Tran Hoai Son on 7/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class eXoApplicationsViewController;
@class XMPPJID;
@class XMPPClient;

//Chat list view
@interface eXoChatView : UIView {
	IBOutlet UITableView*	_tblvUsersList;	//Chat list
	eXoApplicationsViewController* _delegate;	//Point to eXo main app view controller
	XMPPClient*	_xmppClient;	//Chat socket
	
	NSArray*				_arrUsers;	//Contact list
	NSMutableArray*			_msgCount;	//count for each of chat
	NSMutableDictionary*	_msgDict;	//Chat content of each chat

}

- (void)initForChatWithDelegate:(eXoApplicationsViewController *)delegate;	//Constructor
- (void)updateAccountInfo;	//Get user infor to chat with
-(void) checkMsg;	//Check if it has new message

+(BOOL)isFirstTimeLogIn;	//Check if it is the first time login

@end
