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

@class AuthenticateViewController;

@interface CredentialsViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain)  IBOutlet UIImageView*       panelBackground; 
@property (nonatomic, retain) AuthenticateViewController * authViewController;
@property (nonatomic) BOOL     bAutoLogin;	// Autologin
@property (nonatomic) BOOL     bRememberMe;
@property (nonatomic, retain) IBOutlet UIButton*  btnLogin;      // Login button
@property (nonatomic, assign) UITextField *activeField;
@property (nonatomic, retain) IBOutlet UITextField *txtfUsername;// Username textfield
@property (nonatomic, retain) IBOutlet UITextField *txtfPassword;// Password textfield

- (IBAction)onSignInBtn:(id)sender;	//Login action
- (void) dismissKeyboard;
- (void)signInAnimation:(int)animationMode;
- (void)setLoginButtonLabel;

@end
