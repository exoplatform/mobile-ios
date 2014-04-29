//
//  UserPreferencesTestCase.m
//  eXo Platform
//
//  Created by exoplatform on 4/29/14.
//  Copyright (c) 2014 eXoPlatform. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SettingUnitest.h"

@interface UserPreferencesTestCase : XCTestCase

@end

@implementation UserPreferencesTestCase

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
    NSString *expectedUrl = @"http://demo.platform.exo.org";
    
    XCTAssertTrue([[settingU parseURL:@"demo.platform.exo.org/portal"] isEqualToString:expectedUrl], @"Failed");
    XCTAssertTrue([[settingU parseURL:@"http://demo.platform.exo.org"] isEqualToString:expectedUrl], @"Failed");
    XCTAssertTrue([[settingU parseURL:@"demo.platform.exo.org/"] isEqualToString:expectedUrl], @"Failed");
    XCTAssertTrue([[settingU parseURL:@"http://demo.platform.exo.org/portal"] isEqualToString:expectedUrl], @"Failed");
    
    //     Get server list
    NSArray *serverList = [settingU getServerList];
    //    XCTAssertTrue([serverList count] > 0, @"Failed");
    XCTAssertEqual([serverList count], 1, @"Failed");
    
    
    //    Add new server
    XCTAssertTrue([settingU addNewServer:@"" URL:@""], @"Failed");
    
    //    Edit server
    XCTAssertTrue([settingU editServer:@"" urlNew:@""], @"Failed");
    
    //    Delete server
    XCTAssertTrue([settingU deleteServer], @"Failed");
    
}




@end
