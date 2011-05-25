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
#import "iPadSettingViewController.h"

@class MenuHeaderView;

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	
    id                              _delegate;
    
	UITableView*  _tableView;
	NSMutableArray* _cellContents;
	MenuHeaderView* _menuHeader;
    
    FilesViewController*            _filesViewController;
    
    
    DashboardViewController_iPad*   _dashboardViewController_iPad;
    
    Connection*                     _conn;
    
    MessengerViewController*        _messengerViewController;
    UINavigationController*         _nvMessengerViewController;
    ChatWindowViewController*       _chatWindowViewController;
    iPadSettingViewController*      _iPadSettingViewController;
    
    UINavigationController*         _modalNavigationSettingViewController;
    
    NSDictionary*						_dictLocalize;
	int									_intSelectedLanguage;

    short							_currentViewIndex;
    UIImageView*					_imgViewNewMessage;
    NSMutableArray*					_liveChatArr;
    UIToolbar*						_toolBarChatsLive;

    int                             _intIndex;
    
    UIView*                         _footer; 
    
}
- (id)initWithFrame:(CGRect)frame;

@property(nonatomic, retain)UITableView* tableView;

- (void)setDelegate:(id)delegate;

- (void)setPositionsForOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end
