//
//  MailInputViewController.h
//  eXo Platform
//
//  Created by vietnq on 6/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExoCloudProxy.h"
#import "SSHUDView.h"
@class SignUpViewController;
@interface MailInputViewController : UIViewController<ExoCloudProxyDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UITextField *mailTf;
@property (nonatomic, retain) IBOutlet UILabel *errorLabel;
@property (nonatomic, retain) SSHUDView *hud;
- (IBAction)createAccount:(id)sender;
@end
