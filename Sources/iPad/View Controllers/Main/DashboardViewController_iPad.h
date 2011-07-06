//
//  DashboardViewController_iPad.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardViewController_iPad : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    id                      _delegate;
    IBOutlet UITableView*   _tblvDashboard;
    NSMutableArray*         _arrTabs;
}

@property(nonatomic, retain) NSMutableArray* _arrTabs;

- (void)setDelegate:(id)delegate;
@end
