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
#import "UserPreferencesManager.h"
#import "ApplicationPreferencesManager.h"
#import "defines.h"

@interface UserPreferencesTestCase : ExoTestCase {
    UserPreferencesManager *manager;
}
@end

@implementation UserPreferencesTestCase

- (void)setUp
{
    [super setUp];
    manager = [UserPreferencesManager sharedInstance];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [self deletePreferences];
    [super tearDown];
}

- (void)deletePreferences
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:EXO_PREFERENCE_USERNAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:EXO_PREFERENCE_PASSWORD];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:EXO_LAST_LOGGED_USER];
}

// TODO fix this test by simulating a connected user, i.e. a stored username and selected domain
//- (void)testRememberSelectedStream
//{
//    const int SELECTED_STREAM = 1;
//    
//    [manager setSelectedSocialStream:SELECTED_STREAM];
//    [manager setRememberSelectedSocialStream:YES];
//    XCTAssertEqual(manager.selectedSocialStream, SELECTED_STREAM, @"Selected stream is remembered and should be 1");
//    
//    [manager setRememberSelectedSocialStream:NO];
//    XCTAssertEqual(manager.selectedSocialStream, 0, @"Selected stream is not remembered so it should be 0");
//    
//}

- (void)testPersistUsernamePassword
{
    manager.username = TEST_USER_NAME;
    manager.password = TEST_USER_PASS;
    [manager persistUsernameAndPasswod];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *savedName = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
    NSString *savedPass = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
    XCTAssertEqualObjects(savedName, TEST_USER_NAME, @"Username not correctly persisted in preferences");
    XCTAssertEqualObjects(savedPass, TEST_USER_PASS, @"Password not correctly persisted in preferences");
}

- (void)testReloadUsernamePassword
{
    manager.username = TEST_USER_NAME;
    manager.password = TEST_USER_PASS;
    [manager persistUsernameAndPasswod];
    
    manager.username = @"";
    manager.password = @"";
    
    [manager reloadUsernamePassword];
    
    XCTAssertEqualObjects(manager.username, TEST_USER_NAME, @"Username not correctly loaded from preferences");
    XCTAssertEqualObjects(manager.password, TEST_USER_PASS, @"Password not correctly loaded from preferences");
}

@end
