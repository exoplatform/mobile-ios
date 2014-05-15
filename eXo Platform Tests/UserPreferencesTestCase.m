//
//  UserPreferencesTestCase.m
//  eXo Platform
//
//  Created by exoplatform on 4/29/14.
//  Copyright (c) 2014 eXoPlatform. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SettingUnitest.h"

@interface ApplicationPreferencesTestCase : XCTestCase

@end

@implementation ApplicationPreferencesTestCase

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSetting {
    
    SettingUnitest *settingU = [[SettingUnitest alloc] init];
    
    //    Parse given url
    NSString *SERVER_URL =     @"http://demo.platform.exo.org";
    NSString *SERVER_URL_NEW = @"http://new.platform.exo.org";
    NSString *SERVER_NAME =     @"Test Server";
    NSString *SERVER_NAME_NEW = @"Test Server New";
    
    XCTAssertEqualObjects([settingU parseURL:@"demo.platform.exo.org/portal"], SERVER_URL, @"Failed to parse URL");
    XCTAssertEqualObjects([settingU parseURL:@"http://demo.platform.exo.org"], SERVER_URL, @"Failed to parse URL");
    XCTAssertEqualObjects([settingU parseURL:@"demo.platform.exo.org/"], SERVER_URL, @"Failed to parse URL");
    XCTAssertEqualObjects([settingU parseURL:@"http://demo.platform.exo.org/portal"], SERVER_URL, @"Failed to parse URL");
    
    //     Get server list - should be empty
    XCTAssertTrue([[settingU getServerList] count] == 0, @"Number of servers should be 0");
    
    //    Add new server
    [settingU addNewServer:SERVER_NAME URL:SERVER_URL];
    XCTAssertTrue([[settingU getServerList] count] == 1, @"Number of servers should be 1");
    
    //    Edit server
    [settingU editServer:SERVER_NAME_NEW urlNew:SERVER_URL_NEW];
    ServerObj *srv = [[settingU getServerList] objectAtIndex:0];
    XCTAssertNotNil(srv, @"Server should not be null");
    XCTAssertEqualObjects([srv _strServerName], SERVER_NAME_NEW, @"New server name should be %@", SERVER_NAME_NEW);
    XCTAssertEqualObjects([srv _strServerUrl], SERVER_URL_NEW, @"New server URL should be %@", SERVER_URL_NEW);
    
    //    Delete server
    [settingU deleteServer];
    XCTAssertTrue([[settingU getServerList] count] == 0, @"Number of servers should be 0");
}




@end
