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
#import "AuthenticateViewController_iPhone.h"

@interface AuthenticateScreen_iPhone_TestCase : ExoTestCase {

    AuthenticateViewController_iPhone* controller;
    ServerManagerHelper* serverManager;
}
@end

@implementation AuthenticateScreen_iPhone_TestCase

- (void)deleteAllServers
{
    if ([serverManager serverList] != nil) {
        for (int i=0; i<[[serverManager serverList] count]; i++) {
            [serverManager deleteServerObjAtIndex:i];
        }
    }
}

- (void)setUp
{
    [super setUp];
    controller = [[AuthenticateViewController_iPhone alloc] init];
    serverManager = [ApplicationPreferencesManager sharedInstance];
    [self deleteAllServers];
}

- (void)tearDown
{
    [self deleteAllServers];
    [super tearDown];
}

- (void)testCredentialsPanelIsStartedFirst
{
    [controller viewDidLoad];
    XCTAssertFalse(controller.credentialsViewController.view.isHidden, @"Credentials view should be visible");
    XCTAssertTrue(controller.accountListViewController.view.isHidden, @"Account list view should be hidden");
    XCTAssertFalse(controller.tabView.switcherTabIsVisible, @"Property switcherTabIsVisible should be NO");
}

- (void)testAccountListTabDoesnotExistWithOneAccount
{
    //    Add 1 account
    [serverManager addDefaultAccount];
    [controller viewDidLoad];
    
    XCTAssertFalse(controller.tabView.switcherTabIsVisible, @"Property switcherTabIsVisible should be NO");
    XCTAssertEqual(controller.tabView.accountSwitcherTabIndex, -1, @"Index of account list tab should be -1");
    
}

- (void)testAccountListTabExistsWithTwoAccounts
{
    //    Add 2 accounts
    [serverManager addNAccounts:2];
    [controller viewDidLoad];
    
    XCTAssertTrue(controller.tabView.switcherTabIsVisible, @"Property switcherTabIsVisible should be YES");
    XCTAssertEqual(controller.tabView.accountSwitcherTabIndex, 1, @"Index of account list tab should be 1");

}

- (void)testOpenAccountListPanel
{
    //    Add 2 accounts
    [serverManager addNAccounts:2];

    // Load the view controller and open the account list panel
    [controller viewDidLoad];
    [controller.tabView setSelectedIndex:1];
    
    XCTAssertTrue(controller.tabView.switcherTabIsVisible, @"Property switcherTabIsVisible should be YES");
    XCTAssertTrue(controller.credentialsViewController.view.isHidden, @"Credentials view should be hidden");
    XCTAssertFalse(controller.accountListViewController.view.isHidden, @"Account list view should be visible");
}

- (void)testOpenCredentialsPanel
{
    //    Add 2 accounts
    [serverManager addNAccounts:2];

    // Load the view controller and open the account list panel
    [controller viewDidLoad];
    [controller.tabView setSelectedIndex:1];
    
    XCTAssertTrue(controller.credentialsViewController.view.isHidden, @"Credentials view should be hidden");
    XCTAssertFalse(controller.accountListViewController.view.isHidden, @"Account list view should be visible");
    
    // Now open the credentials panel
    [controller.tabView setSelectedIndex:0];
    
    XCTAssertFalse(controller.credentialsViewController.view.isHidden, @"Credentials view should be visible");
    XCTAssertTrue(controller.accountListViewController.view.isHidden, @"Account list view should be hidden");
}

- (void)testUsernamePasswordAccountNameAreSetWhenAccountIsSelected
{
    //    Add 2 accounts
    [serverManager addNAccounts:2];

    // Load the view controller
    [controller viewDidLoad];
    // Open the account list panel
    [controller.tabView setSelectedIndex:1];
    // Select the 1st account in the list
    [controller.accountListViewController.tbvlServerList selectRowAtIndexPath:0 animated:YES scrollPosition:0];
    // Open the credentials panel
    [controller.tabView setSelectedIndex:0];
    
    // TODO after refactoring the ServerObj model and the AutoLogin / RememberMe features
//    XCTAssertEqualObjects(TEST_USER_NAME, controller.credentialsViewController.txtfUsername.text, @"Username has not been set properly");
//    XCTAssertEqualObjects(TEST_USER_PASS, controller.credentialsViewController.txtfPassword.text, @"Password has not been set properly");
    NSString* btnLoginLabel = [NSString stringWithFormat:@"Connect to %@ 1", TEST_SERVER_NAME];
    XCTAssertEqualObjects(btnLoginLabel, controller.credentialsViewController.btnLogin.titleLabel.text, @"Login button label has not been set properly");
}

@end
