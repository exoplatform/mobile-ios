//
//  CredentialsViewController.h
//  eXo Platform
//
//  Created by exoplatform on 7/18/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

@class AuthenticateViewController;

@interface CredentialsViewController : UIViewController <UITextFieldDelegate>
{
    BOOL                         _bRememberMe;	// Remember
}

@property (nonatomic, retain) AuthenticateViewController * authViewController;
@property (nonatomic) BOOL     bAutoLogin;	// Autologin
@property (nonatomic, retain) IBOutlet UIButton*  btnLogin;      // Login button
@property (nonatomic, assign) UITextField *activeField;
@property (nonatomic, retain) IBOutlet UITextField *txtfUsername;// Username textfield
@property (nonatomic, retain) IBOutlet UITextField *txtfPassword;// Password textfield

- (IBAction)onSignInBtn:(id)sender;	//Login action

@end
