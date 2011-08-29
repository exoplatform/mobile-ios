//
//  eXoFilesView.h
//  eXoApp
//
//  Created by Tran Hoai Son on 7/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATMHud.h"
#import "ATMHudDelegate.h"

@class eXoApplicationsViewController;
@class XMPPJID;
@class XMPPClient;
@class XMPPUser;
@class ChatWindowViewController_iPhone;


//Chat list view
@interface MessengerViewController : UIViewController <ATMHudDelegate>
{
    id                              _delegate;
	IBOutlet UITableView*           _tblvUsersList;	//Chat list
	XMPPClient*                     _xmppClient;        //Chat socket
	
    NSMutableArray*                 _arrChatUsers;	//Contact array

    
	NSArray*                        _arrUsers;	//Contact list
	NSMutableArray*                 _msgCount;	//count for each of chat
	NSMutableDictionary*            _msgDict;	//Chat content of each chat

    ATMHud *_hudFolder;//Heads up display

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id)delegate;

- (void)initMessengerParametersWithDelegate:(id)delegate;	//Constructor
- (void)updateAccountInfo;	//Get user infor to chat with
- (void) checkMsg;	//Check if it has new message

+ (BOOL)isFirstTimeLogIn;	//Check if it is the first time login
- (void)setChatClient:(XMPPClient*)xmppClient;
- (void)setChatUsers:(NSArray*)arrUsers;
- (void)updateForEachExoChatUser:(XMPPUser*)xmppUser withArrMsg:(NSMutableArray*)arrMsg  withHtmlStr:(NSString*)htmlStr;
@end
