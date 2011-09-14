//
//  MenuViewController.h
//  StackScrollView
//
//  Created by Reefaq on 2/24/11.
//  Copyright 2011 raw engineering . All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "DocumentsViewController_iPad.h"
#import "DashboardViewController_iPad.h"
#import "DashboardProxy.h"
#import "ChatWindowViewController_iPad.h"
#import "MessengerViewController_iPad.h"
#import "SettingsViewController_iPad.h"
#import "ActivityStreamBrowseViewController_iPad.h"

@class MenuHeaderView;

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SettingsDelegateProcotol> {
	
    id                              _delegate;
    
	UITableView*  _tableView;
	NSMutableArray* _cellContents;
	MenuHeaderView* _menuHeader;
    
    DocumentsViewController_iPad*            _documentsViewController;
    
    
    DashboardViewController_iPad*   _dashboardViewController_iPad;
    
    ActivityStreamBrowseViewController_iPad* _activityViewController;
        
    MessengerViewController_iPad*        _messengerViewController;
    UINavigationController*         _nvMessengerViewController;
    ChatWindowViewController_iPad*  _chatWindowViewController;
    SettingsViewController_iPad*      _iPadSettingViewController;
    
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
- (id)initWithFrame:(CGRect)frame isCompatibleWithSocial:(BOOL)compatibleWithSocial;

@property(nonatomic, retain)UITableView* tableView;
@property BOOL isCompatibleWithSocial;

- (id)initWithFrame:(CGRect)frame;

- (void)setDelegate:(id)delegate;

- (void)setPositionsForOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end
