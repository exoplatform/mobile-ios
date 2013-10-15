//
//  RecentsTabViewController.h
//  eXo Platform
//
//  Created by vietnq on 10/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eXoViewController.h"
@interface RecentsTabViewController : eXoViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *history;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;


@end
