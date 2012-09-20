//
//  ServerEditingViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/29/11.
//  Copyright 2011 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "eXoTableViewController.h"

@class ServerObj;

@interface ServerEditingViewController : eXoTableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    
    id<ServerManagerProtocol>           _delegate;
    
    ServerObj*                          _serverObj;
    
    UITextField*                        _txtfServerName;
    UITextField*                        _txtfServerUrl;  
    
    NSString*                           _strServerName;
    NSString*                           _strServerUrl; 
    UIBarButtonItem*                    _bbtnEdit;

    int                                 _intIndex;
    UIButton*                           _btnDelete;
}

@property (nonatomic, retain) UITextField* _txtfServerName;
@property (nonatomic, retain) UITextField* _txtfServerUrl;

- (void)setDelegate:(id<ServerManagerProtocol>)delegate;
- (void)setServerObj:(ServerObj*)serverObj andIndex:(int)index;


@end

