//
//  HomeSidebarViewController_iPhone.h
//  eXo Platform
//
//  Created by Stévan on 15/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

typedef enum {
    eXoActivityStream = 0,
    eXoDocuments = 1,
    eXoDashboard = 2,
    eXoSettings = 3,
} JTTableRowTypes;

@class JTRevealSidebarView;
@class JTTableViewDatasource;

@interface HomeSidebarViewController_iPhone : UIViewController <SettingsDelegateProcotol> {
    JTRevealSidebarView *_revealView;
    JTTableViewDatasource *_datasource;
    JTTableRowTypes rowType;
}

@property (retain, nonatomic) JTRevealSidebarView* revealView;

@end
