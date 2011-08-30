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
#import "ChatProxy.h"

//Chat list view
@interface MessengerViewController : UIViewController <ATMHudDelegate>
{
    id                              _delegate;
    ChatProxy*                      _chatProxy;
    
	IBOutlet UITableView*           _tblvUsersList;	//Chat list

	
    NSMutableArray*                 _arrChatUsers;	//Contact array

    
	NSArray*                        _arrUsers;	//Contact list
	NSMutableArray*                 _msgCount;	//count for each of chat
	NSMutableDictionary*            _msgDict;	//Chat content of each chat

    ATMHud *_hudChat; //Heads up display

}

- (void)startLoadingChat;
- (void)showChatLoader;
- (void)cannotConnectToChatServer;
- (void)updateChatClient:(NSArray *)arr;

@end
