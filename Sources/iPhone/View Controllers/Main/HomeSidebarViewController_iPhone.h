//
//  HomeSidebarViewController_iPhone.h
//  eXo Platform
//
//  Created by Stévan on 15/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

@class JTRevealSidebarView;
@class JTTableViewDatasource;

@interface HomeSidebarViewController_iPhone : UIViewController <SettingsDelegateProcotol> {
    JTRevealSidebarView *_revealView;
    JTTableViewDatasource *_datasource;
}

@property (retain, nonatomic) JTRevealSidebarView* revealView;

@end
