//
//  AlreadyAccountViewController.h
//  eXo Platform
//
//  Created by vietnq on 6/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExoCloudProxy.h"
#import "SSHUDView.h"
#import "LoginProxy.h"
#import "LanguageHelper.h"
@interface AlreadyAccountViewController : UIViewController<ExoCloudProxyDelegate,LoginProxyDelegate, UIAlertViewDelegate, UITextFieldDelegate>
@property (nonatomic, retain) IBOutlet UITextField *emailTf;
@property (nonatomic, retain) IBOutlet UITextField *passwordTf;
@property (nonatomic, retain) IBOutlet UILabel *mailErrorLabel;
@property (nonatomic, retain) NSString *autoFilledEmail;
@property (nonatomic, retain) SSHUDView *hud;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) IBOutlet UIButton *onpremiseButton;
@property (nonatomic, retain) IBOutlet UIView *containerView;
@property (nonatomic, retain) IBOutlet UIImageView *warningIcon;
- (IBAction)cancel:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)connectToOnPremise:(id)sender;
@end
