//
//  SignUpViewController.h
//  eXo Platform
//
//  Created by vietnq on 6/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailInputViewController.h"
#import "GreetingViewController.h"

@interface SignUpViewController : UIViewController
@property (nonatomic, retain) IBOutlet UIView *banner;
- (IBAction)cancel:(id)sender;
- (void)insertBodyPanel;
@end
