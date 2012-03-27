//
//  eXoOnChatList.h
//  eXoApp
//
//  Created by exo on 1/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chatItem : NSObject {
	NSString *userName;
	int numOfMsg;
}

@property (nonatomic, retain) NSString *userName;
@property int numOfMsg;

@end

@interface eXoOnChatList : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *onChatList;
	UITableView *tblView;
	UIButton *btnDisplayOnChatList;
	BOOL isDisplayOnChatList;
}

@property (nonatomic, retain) NSMutableArray *onChatList;
@property (nonatomic, retain) UITableView *tblView;
@property (nonatomic, retain) UIButton *btnDisplayOnChatList;
@property BOOL isDisplayOnChatList;

@end
