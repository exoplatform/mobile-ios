//
//  PeopleViewController.h
//  eXo Platform
//
//  Created by vietnq on 10/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "eXoViewController.h"

@interface PeopleViewController : eXoViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) NSMutableArray *people;
@property (nonatomic, retain) IBOutlet UITableView *tableView;


@end
