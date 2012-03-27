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
@class XMPPClientDlg;

@interface eXoChatView : UIView {
	IBOutlet UITableView*	_tblvUsersList;
	eXoApplicationsViewController* _delegate;
	XMPPClientDlg*			_xmppClientDlg;
	XMPPClient*	_xmppClient;
	
	NSArray*				_arrUsers;
	NSMutableArray*			_msgCount;
	NSMutableDictionary*	_msgDict;

}

- (void)initForChatWithDelegate:(eXoApplicationsViewController *)delegate;
- (void)updateAccountInfo;
-(void) checkMsg;

+(BOOL)isFirstTimeLogIn;

@end
