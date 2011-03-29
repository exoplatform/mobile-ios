//
//  ServerAddingViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/28/11.
//  Copyright 2011 home. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *ServerObjCellIdentifier = @"ServerObj";

@interface ServerAddingViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    
    id                                  _delegate;
    
    UITextField*                        _txtfServerName;
    UITextField*                        _txtfServerUrl;  
    
    NSString*                           _strServerName;
    NSString*                           _strServerUrl; 
    UIBarButtonItem*                    _bbtnDone;
}

@property (nonatomic, retain) UITextField* _txtfServerName;
@property (nonatomic, retain) UITextField* _txtfServerUrl;

- (void)setDelegate:(id)delegate;
- (UITableViewCell*)containerCellWithLabel:(UILabel*)label view:(UIView*)view;
- (UITableViewCell*)textCellWithLabel:(UILabel*)label;
+ (UITextField*)textInputFieldForCellWithSecure:(BOOL)secure;

@end


//--------------------------------------------
@interface ContainerCell : UITableViewCell
{
	UIView*	_vContainer;
}
- (void)attachContainer:(UIView*)view;
@end