//
//  AlreadyAccountViewController.h
//  eXo Platform
//
//  Created by vietnq on 6/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExoCloudProxy.h"
#import "LoginProxy.h"
@interface AlreadyAccountViewController : UIViewController<ExoCloudProxyDelegate,LoginProxyDelegate>
@property (nonatomic, retain) IBOutlet UITextField *emailTf;
@property (nonatomic, retain) IBOutlet UITextField *passwordTf;
@property (nonatomic, retain) IBOutlet UILabel *errorLabel;
@property (nonatomic, retain) NSString *autoFilledEmail;
- (IBAction)cancel:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)connectToOnPremise:(id)sender;
@end
