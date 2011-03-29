//
//  ServerEditingViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/29/11.
//  Copyright 2011 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServerObj;

@interface ServerEditingViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    
    id                                  _delegate;
    
    ServerObj*                          _serverObj;
    
    UITextField*                        _txtfServerName;
    UITextField*                        _txtfServerUrl;  
    
    NSString*                           _strServerName;
    NSString*                           _strServerUrl; 
    UIBarButtonItem*                    _bbtnEdit;
}

@property (nonatomic, retain) UITextField* _txtfServerName;
@property (nonatomic, retain) UITextField* _txtfServerUrl;

- (void)setDelegate:(id)delegate;
- (void)setServerObj:(ServerObj*)serverObj;
- (UITableViewCell*)containerCellWithLabel:(UILabel*)label view:(UIView*)view;
- (UITableViewCell*)textCellWithLabel:(UILabel*)label;

@end

