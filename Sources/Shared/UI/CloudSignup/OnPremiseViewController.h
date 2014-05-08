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
- (void)dismissKeyboards;
@end
