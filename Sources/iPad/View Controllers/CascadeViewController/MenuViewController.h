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
#import "ActivityStreamBrowseViewController_iPad.h"

@class MenuHeaderView;

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	
    id                              _delegate;
    
	UITableView*  _tableView;
	NSMutableArray* _cellContents;
	MenuHeaderView* _menuHeader;
    
    FilesViewController*            _filesViewController;
    
    
    DashboardViewController_iPad*   _dashboardViewController_iPad;
    
    ActivityStreamBrowseViewController_iPad* _activityViewController;
    
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
    BOOL                            _isCompatibleWithSocial;
    
}

+ (void)setCompatibleWithSocial:(BOOL)compatible;
- (id)initWithFrame:(CGRect)frame isCompatibleWithSocial:(BOOL)isCompatibleWithSocial;

@property(nonatomic, retain)UITableView* tableView;
@property BOOL isCompatibleWithSocial;

- (id)initWithFrame:(CGRect)frame;

- (void)setDelegate:(id)delegate;

- (void)setPositionsForOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end
