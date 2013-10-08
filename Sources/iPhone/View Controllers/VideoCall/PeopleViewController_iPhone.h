//
//  PeopleViewController_iPhone.h
//  eXo Platform
//
//  Created by vietnq on 10/8/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "CallViewController.h"
#import "eXoViewController.h"
@interface PeopleViewController_iPhone : eXoViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) NSMutableArray *people;
@end
