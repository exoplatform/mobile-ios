//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
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
//auto fill email if redirected from sign up screen
@property (nonatomic, retain) NSString *autoFilledEmail;
@property (nonatomic, retain) SSHUDView *hud;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) IBOutlet UIButton *onpremiseButton;
@property (nonatomic, retain) IBOutlet UIView *containerView;
@property (nonatomic, retain) IBOutlet UIImageView *warningIcon;
- (IBAction)cancel:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)connectToOnPremise:(id)sender;
- (void)dismissKeyboards;

@end
