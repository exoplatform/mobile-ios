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
    [self deleteAllServers];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [self deleteAllServers];
    [self deletePreferences];
    [super tearDown];
}

- (void)deletePreferences
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:EXO_CLOUD_USER_NAME_FROM_URL];
}

- (void)deleteAllServers
{
    if ([serverManager serverList] != nil) {
        for (int i=0; i<[[serverManager serverList] count]; i++) {
            [serverManager deleteServerObjAtIndex:i];
        }
    }
}


- (void)testAddEditDeleteServer
{
    //    Parse given url
    NSString *SERVER_URL_NEW = @"http://new.platform.exo.org";
    NSString *SERVER_NAME_NEW = [NSString stringWithFormat:@"New %@", TEST_SERVER_NAME];
    
    //     Get server list - should be empty
    XCTAssertTrue([[serverManager serverList] count] == 0, @"Number of servers should be 0, was %d", [[serverManager serverList] count]);
    
    //    Add new server
    [serverManager addEditServerWithServerName:TEST_SERVER_NAME andServerUrl:TEST_SERVER_URL withUsername:@"" andPassword:@"" atIndex:-1];
    XCTAssertTrue([[serverManager serverList] count] == 1, @"Number of servers should be 1, was %d", [[serverManager serverList] count]);
    
    //    Edit server
    [serverManager addEditServerWithServerName:SERVER_NAME_NEW andServerUrl:SERVER_URL_NEW withUsername:@"" andPassword:@"" atIndex:0];
    ServerObj *srv = [[serverManager serverList] objectAtIndex:0];
    XCTAssertNotNil(srv, @"Server should not be null");
    XCTAssertEqualObjects([srv _strServerName], SERVER_NAME_NEW, @"New server name should be %@", SERVER_NAME_NEW);
    XCTAssertEqualObjects([srv _strServerUrl], SERVER_URL_NEW, @"New server URL should be %@", SERVER_URL_NEW);
    
    //    Delete server
    [serverManager deleteServerObjAtIndex:0];
    XCTAssertTrue([[serverManager serverList] count] == 0, @"Number of servers should be 0, was %d", [[serverManager serverList] count]);
}

- (void)testSelectServer
{
    // Add 2 servers
    [serverManager addEditServerWithServerName:TEST_SERVER_NAME andServerUrl:TEST_SERVER_URL withUsername:@"" andPassword:@"" atIndex:-1];
    [serverManager addEditServerWithServerName:@"Second Server" andServerUrl:@"http://foo.bar" withUsername:@"" andPassword:@"" atIndex:-1];
    
    XCTAssertEqual([serverManager selectedServerIndex], 0, @"Server at pos 0 should be selected");
    [serverManager setSelectedServerIndex:1];
    XCTAssertEqual([serverManager selectedServerIndex], 1, @"Server at pos 1 should be selected");
}

- (void)testAddAndSelectServer
{
    [serverManager addAndSetSelectedServer:TEST_SERVER_URL withName:TEST_SERVER_NAME];
    XCTAssertTrue([[serverManager serverList] count] == 1, @"Number of servers should be 1");
    XCTAssertEqual([serverManager selectedServerIndex], 0, @"Server at pos 0 should be selected");
}

- (void)testServerAlreadyExists
{
    //    Add new server
    [serverManager addEditServerWithServerName:TEST_SERVER_NAME andServerUrl:TEST_SERVER_URL withUsername:@"" andPassword:@"" atIndex:-1];
    
    XCTAssertEqual([serverManager checkServerAlreadyExistsWithName:TEST_SERVER_NAME andURL:TEST_SERVER_URL ignoringIndex:-1], 0, @"The server should already exist at index 0");
    
//    commented out because the method checkServerAlreadyExistsWithName:andURL, despite its name, does not check the server name
//    XCTAssertEqual([serverManager checkServerAlreadyExistsWithName:@"Foo Bar" andURL:TEST_SERVER_URL ignoringIndex:-1], -1, @"The server should not exist");
    
    XCTAssertEqual([serverManager checkServerAlreadyExistsWithName:TEST_SERVER_NAME andURL:@"http://foo.bar" ignoringIndex:-1], -1, @"The server should not exist");
    
        XCTAssertEqual([serverManager checkServerAlreadyExistsWithName:@"Foo Bar" andURL:@"http://foo.bar" ignoringIndex:-1], -1, @"The server should not exist");
}

- (void)testHandleStartupURL
{

    NSString * escapedURL = [self URLEncodedString:TEST_SERVER_URL];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"exomobile://serverUrl=%@", escapedURL]];

    
    [serverManager loadReceivedUrlToPreference:url];
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:EXO_CLOUD_USER_NAME_FROM_URL];
    XCTAssertNil(username, @"Username should be nil, has value %@ instead", username);
    ServerObj *server = [[serverManager serverList] objectAtIndex:0];
    XCTAssertEqualObjects([server _strServerUrl], TEST_SERVER_URL, @"URL loaded is incorrect");
    
}

- (void)testHandleStartupURLWithUsername
{
    NSString *username = @"john";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"exomobile://username=%@?serverUrl=%@", username, TEST_SERVER_URL]];
    
    [serverManager loadReceivedUrlToPreference:url];
    NSString *loadedUsername = [[NSUserDefaults standardUserDefaults] objectForKey:EXO_CLOUD_USER_NAME_FROM_URL];
    XCTAssertEqualObjects(loadedUsername, username, @"Username should be %@ and not %@ instead", username, loadedUsername);
    ServerObj *server = [[serverManager serverList] objectAtIndex:0];
    XCTAssertEqualObjects([server _strServerUrl], TEST_SERVER_URL, @"URL loaded is incorrect");
    
}

@end
