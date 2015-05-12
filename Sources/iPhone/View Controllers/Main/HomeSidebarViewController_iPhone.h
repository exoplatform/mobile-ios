//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "JTNavigationBar.h"
#import "AccountSwitcherViewController.h"

typedef NS_ENUM(NSInteger, JTTableRowTypes) {
    eXoActivityStream = 0,
    eXoDocuments = 1,
    eXoDashboard = 2,
    eXoSettings = 3,
} ;

@class JTRevealSidebarView;
@class JTTableViewDatasource;
@class UserProfileViewController;

@interface HomeSidebarViewController_iPhone : UIViewController <JTNavigationBarDelegate, SettingsDelegateProcotol, AccountSwitcherDelegate>
{
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
