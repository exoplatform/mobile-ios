//
//  OnPremiseViewController.h
//  eXo Platform
//
//  Created by vietnq on 6/17/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginProxy.h"
#import "SSHUDView.h"
#import "LanguageHelper.h"
@interface OnPremiseViewController : UIViewController <LoginProxyDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UITextField *serverUrlTf;
@property (nonatomic, retain) IBOutlet UITextField *usernameTf;
@property (nonatomic, retain) IBOutlet UITextField *passwordTf;
@property (nonatomic, retain) SSHUDView *hud;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) IBOutlet UIView *containerView;
- (IBAction)login:(id)sender;
@end
