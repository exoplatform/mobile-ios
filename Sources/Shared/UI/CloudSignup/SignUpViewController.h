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

@interface SignUpViewController : UIViewController {
    MailInputViewController *mailInputViewController;
    GreetingViewController *greetingViewController;
}
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
- (IBAction)cancel:(id)sender;
@end