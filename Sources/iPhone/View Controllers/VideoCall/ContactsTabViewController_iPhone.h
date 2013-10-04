//
//  ContactsTabViewController_iPhone.h
//  eXo Platform
//
//  Created by vietnq on 10/1/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eXoViewController.h"

@interface ContactsTabViewController_iPhone : eXoViewController
@property (nonatomic, retain) IBOutlet UILabel *uidLabel;
@property (nonatomic, retain) IBOutlet UILabel *callStatusLabel;
@property (nonatomic, retain) IBOutlet UITextField *calledIdTf;

- (IBAction)call:(id)sender;
@end
