//
//  ContactDetailViewController.h
//  eXo Platform
//
//  Created by vietnq on 10/24/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "eXoViewController.h"
#import "ExoWeemoHandler.h"

@interface ContactDetailViewController : eXoViewController <UITableViewDataSource, UITableViewDelegate, ExoWeemoHandlerDelegate>

@property (nonatomic, retain) IBOutlet UILabel *lb_full_name;
@property (nonatomic, retain) IBOutlet UILabel *lb_uid;
@property (nonatomic, retain) IBOutlet UIButton *bt_call;

@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *uid;

- (IBAction)call:(id)sender;
@end
