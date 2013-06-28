//
//  ServerAddingViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/28/11.
//  Copyright 2011 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eXoTableViewController.h"
#import "SettingsViewController.h"

@interface ServerAddingViewController : eXoTableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    
    id<ServerManagerProtocol>     _delegate;
    
    UITextField*                        _txtfServerName;
    UITextField*                        _txtfServerUrl;  
    
    NSString*                           _strServerName;
    NSString*                           _strServerUrl; 
    UIBarButtonItem*                    _bbtnDone;
}

@property (nonatomic, retain) UITextField* _txtfServerName;
@property (nonatomic, retain) UITextField* _txtfServerUrl;
//cloud sign up - link credentials to server
@property (nonatomic, retain) UITextField *usernameTf;
@property (nonatomic, retain) UITextField *passwordTf;

- (void)setDelegate:(id<ServerManagerProtocol>)delegate;
+ (UITextField*)textInputFieldForCellWithSecure:(BOOL)secure andRequired:(BOOL)isRequired;

@end

