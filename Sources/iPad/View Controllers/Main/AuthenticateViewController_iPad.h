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

#import <Foundation/Foundation.h>
#import "SSHUDView.h"
#import "SettingsViewController_iPad.h"
#import "AuthenticateViewController.h"
#import "eXoNavigationController.h"
@class ServerObj;

//Login page
@interface AuthenticateViewController_iPad : AuthenticateViewController <SettingsDelegateProcotol>
{
	id							     _delegate;
    eXoNavigationController*          _modalNavigationSettingViewController;
    SettingsViewController_iPad*     _iPadSettingViewController;
    UIInterfaceOrientation           _interfaceOrientation;
}

- (void)setDelegate:(id)delegate;	//Set delegate
- (void)setPreferenceValues;	//Set prefrrences
- (void)localize;	//Set language dictionary
- (int)getSelectedLanguage;	//Get current language
- (NSDictionary*)getLocalization;	//Get language dictionary
- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation;	//Change device orientation
- (IBAction)onSettingBtn:(id)sender;	//Setting action
@end
