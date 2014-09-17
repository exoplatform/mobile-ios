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
    BOOL                                _canEdit;
}

@property (nonatomic, retain) UITextField* _txtfServerName;
@property (nonatomic, retain) UITextField* _txtfServerUrl;
@property (nonatomic, retain) UITextField *usernameTf;
@property (nonatomic, retain) UITextField *passwordTf;

- (void)setDelegate:(id<ServerManagerProtocol>)delegate;
- (void)setServerObj:(ServerObj*)serverObj andIndex:(int)index;


@end

