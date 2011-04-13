//
//  iPadServerEditingViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/29/11.
//  Copyright 2011 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServerObj;

@interface iPadServerEditingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    
    id                                  _delegate;
    
    IBOutlet UITableView*               _tblvServerInfo;
    
    ServerObj*                          _serverObj;
    
    UITextField*                        _txtfServerName;
    UITextField*                        _txtfServerUrl;  
    
    NSString*                           _strServerName;
    NSString*                           _strServerUrl; 
    UIBarButtonItem*                    _bbtnEdit;
    BOOL                                _bEdit;
    int                                 _intIndex;
    NSDictionary*                       _dictLocalize;
    
    UIButton*                           _btnEdit;
    int                                 _interfaceOrientation;
}

@property (nonatomic, retain) UITextField* _txtfServerName;
@property (nonatomic, retain) UITextField* _txtfServerUrl;

- (void)setDelegate:(id)delegate;
- (void)setServerObj:(ServerObj*)serverObj andIndex:(int)index;
- (UITableViewCell*)containerCellWithLabel:(UILabel*)label view:(UIView*)view;
- (UITableViewCell*)textCellWithLabel:(UILabel*)label;
- (void)setDelegate:(id)delegate;
- (IBAction)onBtnBack:(id)sender;
- (void)setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation;
@end

