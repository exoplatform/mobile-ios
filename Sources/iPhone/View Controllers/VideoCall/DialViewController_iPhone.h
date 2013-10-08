//
//  DialViewController_iPhone.h
//  eXo Platform
//
//  Created by vietnq on 10/1/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eXoViewController.h"

@interface DialViewController_iPhone : eXoViewController
@property (nonatomic, retain) IBOutlet UILabel *uidLabel;
@property (nonatomic, retain) IBOutlet UITextField *calledIdTf;
@property (nonatomic, retain) IBOutlet UIButton *connectButton;
@property (nonatomic, retain) IBOutlet UIButton *callButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

- (IBAction)call:(id)sender;
- (IBAction)connect:(id)sender;
- (void)updateViewWithConnectionStatus:(BOOL)isConnected;
@end
