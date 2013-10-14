//
//  DialViewController.h
//  eXo Platform
//
//  Created by vietnq on 10/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "eXoViewController.h"

@interface DialViewController : eXoViewController
@property (nonatomic, retain) IBOutlet UILabel *uidLabel;
@property (nonatomic, retain) IBOutlet UITextField *calledIdTf;
@property (nonatomic, retain) IBOutlet UIButton *callButton;

- (IBAction)call:(id)sender;
- (void)updateViewWithConnectionStatus:(BOOL)isConnected;

@end
