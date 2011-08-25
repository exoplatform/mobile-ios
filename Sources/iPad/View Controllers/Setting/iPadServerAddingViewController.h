//
//  iPadServerAddingViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/28/11.
//  Copyright 2011 home. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface iPadServerAddingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    
    id                                  _delegate;
    
    IBOutlet UITableView*               _tblvServerInfo;
    
    UITextField*                        _txtfServerName;
    UITextField*                        _txtfServerUrl;  
    
    NSString*                           _strServerName;
    NSString*                           _strServerUrl; 

    UIBarButtonItem*                    _bbtnDone; 
    int                                 _interfaceOrientation;
}

@property (nonatomic, retain) UITextField* _txtfServerName;
@property (nonatomic, retain) UITextField* _txtfServerUrl;
@property (nonatomic, retain) UITableView* _tblvServerInfo;

- (void)setDelegate:(id)delegate;
- (void)localize;
- (UITableViewCell*)containerCellWithLabel:(UILabel*)label view:(UIView*)view;
- (UITableViewCell*)textCellWithLabel:(UILabel*)label;
+ (UITextField*)textInputFieldForCellWithSecure:(BOOL)secure;
- (void)setDelegate:(id)delegate;
- (IBAction)onBtnBack:(id)sender;
- (void)setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation;
@end
