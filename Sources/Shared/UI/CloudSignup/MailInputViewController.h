//
//  MailInputViewController.h
//  eXo Platform
//
//  Created by vietnq on 6/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailInputViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *mailTf;
@property (nonatomic, retain) IBOutlet UILabel *errorLabel;

- (IBAction)createAccount:(id)sender;
@end
