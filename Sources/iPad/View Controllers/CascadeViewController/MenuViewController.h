//
//  MenuViewController.h
//  StackScrollView
//
//  Created by Reefaq on 2/24/11.
//  Copyright 2011 raw engineering . All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "SettingsViewController_iPad.h"
#import "eXoNavigationController.h"
#import "AccountSwitcherViewController.h"

#define EXO_ACTIVITY_STREAM_ROW 0
#define EXO_DOCUMENTS_ROW 1
#define EXO_DASHBOARD_ROW 2

@class UserProfileViewController;

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,
                                                  SettingsDelegateProcotol, AccountSwitcherDelegate> {
                                                      
    
	UITableView*  _tableView;
	NSMutableArray* _cellContents;
    
	int									_intSelectedLanguage;

    int                             _intIndex;
    
    BOOL                            _isCompatibleWithSocial;
    
}
@property (nonatomic, retain) UITableView* tableView;
@property BOOL isCompatibleWithSocial;
@property (nonatomic, retain) UserProfileViewController *userProfileViewController;

- (instancetype)initWithFrame:(CGRect)frame isCompatibleWithSocial:(BOOL)compatibleWithSocial;
- (void) updateLabelsWithNewLanguage;

@end
