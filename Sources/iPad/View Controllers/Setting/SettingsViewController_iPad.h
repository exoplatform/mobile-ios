//
//  iPadSettingViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 5/31/10.
//  Copyright 2010 home. All rights reserved.
//

#import "SettingsViewController.h"
#import "iPadServerManagerViewController.h"

@interface SettingsViewController_iPad : SettingsViewController {
    
    iPadServerManagerViewController*    _iPadServerManagerViewController;
}

@property(nonatomic, retain) UITableView*	tblView;

@end

