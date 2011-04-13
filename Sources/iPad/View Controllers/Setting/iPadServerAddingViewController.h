//
//  iPadServerAddingViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/28/11.
//  Copyright 2011 home. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *ServerObjCellIdentifier = @"ServerObj";

@interface iPadServerAddingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    
    id                                  _delegate;
    
    IBOutlet UITableView*               _tblvServerInfo;
    
    UITextField*                        _txtfServerName;
    UITextField*                        _txtfServerUrl;  
    
    NSString*                           _strServerName;
    NSString*                           _strServerUrl; 

    NSDictionary*                       _dictLocalize;
    UIButton*                           _btnDone;
}

@property (nonatomic, retain) UITextField* _txtfServerName;
@property (nonatomic, retain) UITextField* _txtfServerUrl;

- (void)setDelegate:(id)delegate;
- (UITableViewCell*)containerCellWithLabel:(UILabel*)label view:(UIView*)view;
- (UITableViewCell*)textCellWithLabel:(UILabel*)label;
+ (UITextField*)textInputFieldForCellWithSecure:(BOOL)secure;
- (void)setDelegate:(id)delegate;
- (IBAction)onBtnBack:(id)sender;
- (void)setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation;
@end
