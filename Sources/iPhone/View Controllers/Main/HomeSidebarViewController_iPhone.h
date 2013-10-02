//
//  HomeSidebarViewController_iPhone.h
//  eXo Platform
//
//  Created by Stévan on 15/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "JTNavigationBar.h"

typedef enum {
    eXoActivityStream = 0,
    eXoDocuments = 1,
    eXoDashboard = 2,
    eXoSettings = 3,
    eXoWeemoCall = 4
} JTTableRowTypes;

@class JTRevealSidebarView;
@class JTTableViewDatasource;
@class UserProfileViewController;

@interface HomeSidebarViewController_iPhone : UIViewController <JTNavigationBarDelegate, SettingsDelegateProcotol> {
    JTRevealSidebarView *_revealView;
    JTTableViewDatasource *_datasource;
    JTTableRowTypes rowType;
    NSMutableArray *_viewControllers;
    UIButton *_disconnectLabel; //need a variable to update the label when the language changes
}

@property (nonatomic, readonly) UINavigationItem *contentNavigationItem;
@property (nonatomic, readonly) JTNavigationBar *contentNavigationBar;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, readonly) UserProfileViewController *userProfileViewController;

// Navigation management 
- (void)setContentNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (UIViewController *)popViewControllerAnimated:(BOOL)animated;
- (void)setRootViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)updateLabelsWithNewLanguage;

@end
