//
//  ContactDetailViewController.h
//  eXo Platform
//
//  Created by vietnq on 10/24/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "eXoViewController.h"
#import "ExoWeemoHandler.h"
#import "ExoContact.h"

@interface ContactDetailViewController : eXoViewController <UITableViewDataSource, UITableViewDelegate, ExoWeemoHandlerDelegate>

@property (nonatomic, retain) IBOutlet UILabel *lb_full_name;
@property (nonatomic, retain) IBOutlet UILabel *lb_uid;
@property (nonatomic, retain) IBOutlet UIButton *bt_call;

@property (nonatomic, retain) IBOutlet UIImageView *avatar;
@property (nonatomic, retain) ExoContact *contact;
- (IBAction)call:(id)sender;
@end
