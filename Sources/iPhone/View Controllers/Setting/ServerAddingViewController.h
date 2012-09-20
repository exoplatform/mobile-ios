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

- (void)setDelegate:(id<ServerManagerProtocol>)delegate;
+ (UITextField*)textInputFieldForCellWithSecure:(BOOL)secure;

@end

