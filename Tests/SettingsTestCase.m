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

#import "ExoTestCase.h"
#import "ServerManagerHelper.h"
#import "SettingsViewController.h"
#import "UserPreferencesManager.h"
#import <XCTest/XCTest.h>

@interface SettingsTestCase : ExoTestCase {

    SettingsViewController* controller;
    ServerManagerHelper* serverManager;
}
@end

@implementation SettingsTestCase

- (void)setUp
{
    [super setUp];
    serverManager = [ServerManagerHelper getInstance];
    [serverManager deleteAllAccounts];
    
}

- (void)tearDown
{
    [serverManager deleteAllAccounts];
    [UserPreferencesManager sharedInstance].isUserLogged = NO;
    [super tearDown];
}

- (void) testLayoutIsCorrect_Disconnected
{
    [serverManager addDefaultAccount];
    [UserPreferencesManager sharedInstance].isUserLogged = NO;
    controller = [[SettingsViewController alloc] init];
    
    [controller viewDidLoad];
    [controller viewWillAppear:YES];
    
    XCTAssertEqualObjects(@"Settings", controller.title, @"Screen title should be: Settings, not %@", controller.title);
    
    int nb = controller.tableView.numberOfSections;
    XCTAssertEqual(3, nb, @"The Settings screen should contain 3 sections when NO user is connected, not %d", nb);
    
}

- (void) testLayoutIsCorrect_Connected
{
    [serverManager addDefaultAccount];
    [UserPreferencesManager sharedInstance].isUserLogged = YES;
    [ApplicationPreferencesManager sharedInstance].platformVersion = @"4.1";
    controller = [[SettingsViewController alloc] init];
    
    [controller viewDidLoad];
    [controller viewWillAppear:YES];
    
    XCTAssertEqualObjects(@"Settings", controller.title, @"Screen title should be Settings, not %@", controller.title);
    
    int nb = controller.tableView.numberOfSections;
    XCTAssertEqual(5, nb, @"The Settings screen should contain 5 sections when a user is connected, not %d", nb);
    
}

- (void) testDeleteAccountItem
{
    [serverManager addNAccounts:2];
    [UserPreferencesManager sharedInstance].isUserLogged = NO;
    ApplicationPreferencesManager *appPrefManager = [ApplicationPreferencesManager sharedInstance];
    controller = [[SettingsViewController alloc] init];
    
    [controller viewDidLoad];
    [controller viewWillAppear:YES];
    
    XCTAssertEqual(2, appPrefManager.serverList.count, @"There should be 2 accounts in the accounts list");

    [controller deleteServerObjAtIndex:0];
    
    XCTAssertEqual(1, appPrefManager.serverList.count, @"There should be 1 account left in the accounts list");
}



@end
