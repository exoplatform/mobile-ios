//
//  MenuViewController.h
//  StackScrollView
//
//  Created by Reefaq on 2/24/11.
//  Copyright 2011 raw engineering . All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "FilesViewController.h"
#import "DashboardViewController_iPad.h"
#import "Connection.h"
#import "ChatWindowViewController.h"
#import "MessengerViewController.h"

@class MenuHeaderView;

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView*  _tableView;
	NSMutableArray* _cellContents;
	MenuHeaderView* _menuHeader;
    
    FilesViewController*            _filesViewController;
    
    
    DashboardViewController_iPad*   _dashboardViewController_iPad;
    
    Connection*                     _conn;
    
    MessengerViewController*        _messengerViewController;
    UINavigationController*         _nvMessengerViewController;
    ChatWindowViewController*       _chatWindowViewController;
    short							_currentViewIndex;
    UIImageView*					_imgViewNewMessage;
    NSMutableArray*					_liveChatArr;
    UIToolbar*						_toolBarChatsLive;


    
}
- (id)initWithFrame:(CGRect)frame;

@property(nonatomic, retain)UITableView* tableView;

@end
