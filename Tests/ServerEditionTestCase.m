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


#import <XCTest/XCTest.h>
#import "ExoTestCase.h"
#import "ServerEditingViewController.h"
#import "ServerManagerHelper.h"
#import "UserPreferencesManager.h"

@interface ServerEditionTestCase : ExoTestCase {

    ServerManagerHelper* serverManager;
    ServerEditingViewController* controller;
    
}
@end

@implementation ServerEditionTestCase

- (void)setUp
{
    [super setUp];
    serverManager = [ServerManagerHelper getInstance];
    [serverManager deleteAllAccounts];
}

- (void)tearDown
{
    [serverManager deleteAllAccounts];
    [super tearDown];
}

- (void)testLayoutIsCorrect_Offline
{
    ServerObj* account = [serverManager addDefaultAccount];
    [UserPreferencesManager sharedInstance].isUserLogged = NO;
    controller = [[ServerEditingViewController alloc] init];
    [controller setServerObj:account andIndex:0];
    
    XCTAssertNotEqualObjects(controller.title, TEST_SERVER_NAME, @"Screen title should be the account name");
    
    XCTAssertEqualObjects(controller._txtfServerName.text, TEST_SERVER_NAME, @"Incorrect account name");
    XCTAssertEqualObjects(controller._txtfServerUrl.text, TEST_SERVER_URL, @"Incorrect account server URL");
    XCTAssertEqualObjects(controller.usernameTf.text, TEST_USER_NAME, @"Incorrect account username");
    XCTAssertEqualObjects(controller.passwordTf.text, TEST_USER_PASS, @"Incorrect account password");
    
}

- (void)testTextFieldsAreEditableWhenUserIsOffline
{
    // add default account
    ServerObj* account = [serverManager addDefaultAccount];
    // user is offline
    [UserPreferencesManager sharedInstance].isUserLogged = NO;
    // load the view controller
    controller = [[ServerEditingViewController alloc] initWithNibName:@"ServerEditingViewController" bundle:nil];
    [controller setServerObj:account andIndex:0];
    [controller viewDidLoad];
    [controller viewWillAppear:NO];
    // layoutSubviews will force the call to cellForRowAtIndexPath which sets each textfield enabled or disabled
    [controller.tableView layoutSubviews];
    
    XCTAssertTrue(controller._txtfServerName.isEnabled, @"Account name textfield should allow edition");
    XCTAssertTrue(controller._txtfServerUrl.isEnabled, @"Account URL textfield should allow edition");
    XCTAssertTrue(controller.usernameTf.isEnabled, @"Account username textfield should allow edition");
    XCTAssertTrue(controller.passwordTf.isEnabled, @"Account password textfield should allow edition");
}

- (void)testTextFieldsAreNotEditableWhenUserIsConnected
{
    // add default account
    ServerObj* account = [serverManager addDefaultAccount];
    // user is connected
    [UserPreferencesManager sharedInstance].isUserLogged = YES;
    // load the view controller
    controller = [[ServerEditingViewController alloc] initWithNibName:@"ServerEditingViewController" bundle:nil];
    [controller setServerObj:account andIndex:0];
    [controller viewDidLoad];
    [controller viewWillAppear:NO];
    [controller.tableView layoutSubviews];
    
    XCTAssertTrue(controller._txtfServerName.isEnabled, @"Account name textfield should allow edition");
    XCTAssertFalse(controller._txtfServerUrl.isEnabled, @"Account URL textfield should NOT allow edition");
    XCTAssertFalse(controller.usernameTf.isEnabled, @"Account username textfield should NOT allow edition");
    XCTAssertFalse(controller.passwordTf.isEnabled, @"Account password textfield should NOT allow edition");
}

- (void)testTextFieldsAreEditableWhenUserIsConnectedWithOtherAccount
{
    // add default account
    [serverManager addDefaultAccount];
    [serverManager selectAccountAtIndex:0];
    // add a second account
    ServerObj* account = [[ServerObj alloc] init];
    account.accountName = @"My Second Account";
    account.serverUrl = TEST_SERVER_URL;
    account.username = TEST_USER_NAME;
    account.password = TEST_USER_PASS;
    [serverManager addAccount:account];
    // user is connected
    [UserPreferencesManager sharedInstance].isUserLogged = YES;
    // load the view controller
    controller = [[ServerEditingViewController alloc] initWithNibName:@"ServerEditingViewController" bundle:nil];
    [controller setServerObj:account andIndex:1];
    [controller viewDidLoad];
    [controller viewWillAppear:NO];
    [controller.tableView layoutSubviews];
    
    XCTAssertTrue(controller._txtfServerName.isEnabled, @"Account name textfield should allow edition");
    XCTAssertTrue(controller._txtfServerUrl.isEnabled, @"Account URL textfield should allow edition");
    XCTAssertTrue(controller.usernameTf.isEnabled, @"Account username textfield should allow edition");
    XCTAssertTrue(controller.passwordTf.isEnabled, @"Account password textfield should allow edition");
}


@end
