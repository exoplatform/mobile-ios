//
//  UserPreferencesTestCase.m
//  eXo Platform
//
//  Created by exoplatform on 4/29/14.
//  Copyright (c) 2014 eXoPlatform. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ApplicationPreferencesManager.h"
#import "URLAnalyzer.h"
#import "ExoTestCase.h"

@interface ApplicationPreferencesTestCase : ExoTestCase {
    ApplicationPreferencesManager *serverManager;
}

@end

@implementation ApplicationPreferencesTestCase

- (void)setUp
{
    [super setUp];
    serverManager = [ApplicationPreferencesManager sharedInstance];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (NSString*)parseURL:(NSString*)url {
    
    return [URLAnalyzer parserURL:[url stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}


- (void)testSetting {
    
    //    Parse given url
    NSString *SERVER_URL_NEW = @"http://new.platform.exo.org";
    NSString *SERVER_NAME_NEW = [NSString stringWithFormat:@"New %@", TEST_SERVER_NAME];
    
    //     Get server list - should be empty
    XCTAssertTrue([[serverManager serverList] count] == 0, @"Number of servers should be 0");
    
    //    Add new server
    [serverManager addEditServerWithServerName:TEST_SERVER_NAME andServerUrl:TEST_SERVER_URL withUsername:@"" andPassword:@"" atIndex:-1];
    XCTAssertTrue([[serverManager serverList] count] == 1, @"Number of servers should be 1");
    
    //    Edit server
    [serverManager addEditServerWithServerName:SERVER_NAME_NEW andServerUrl:SERVER_URL_NEW withUsername:@"" andPassword:@"" atIndex:0];
    ServerObj *srv = [[serverManager serverList] objectAtIndex:0];
    XCTAssertNotNil(srv, @"Server should not be null");
    XCTAssertEqualObjects([srv _strServerName], SERVER_NAME_NEW, @"New server name should be %@", SERVER_NAME_NEW);
    XCTAssertEqualObjects([srv _strServerUrl], SERVER_URL_NEW, @"New server URL should be %@", SERVER_URL_NEW);
    
    //    Delete server
    [serverManager deleteServerObjAtIndex:0];
    XCTAssertTrue([[serverManager serverList] count] == 0, @"Number of servers should be 0");
}




@end
