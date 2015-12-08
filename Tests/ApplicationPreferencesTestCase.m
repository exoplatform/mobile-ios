//
//  UserPreferencesTestCase.m
//  eXo Platform
//
//  Created by exoplatform on 4/29/14.
//  Copyright (c) 2014 eXoPlatform. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UserPreferencesManager.h"
#import "ApplicationPreferencesManager.h"
#import "URLAnalyzer.h"
#import "ExoTestCase.h"
#import "ServerManagerHelper.h"

@interface ApplicationPreferencesTestCase : ExoTestCase {
    ApplicationPreferencesManager *serverManager;
    ServerManagerHelper *serverHelper;
}

@end

@implementation ApplicationPreferencesTestCase

- (void)setUp
{
    [super setUp];
    serverManager = [ApplicationPreferencesManager sharedInstance];
    serverHelper = [ServerManagerHelper getInstance];
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
    [serverHelper deleteAllAccounts];
}


- (void)testAddEditDeleteServer
{
    //    Parse given url
    NSString *SERVER_URL_NEW = @"http://new.platform.exo.org";
    NSString *SERVER_NAME_NEW = [NSString stringWithFormat:@"New %@", TEST_SERVER_NAME];
    
    //     Get server list - should be empty
    XCTAssertTrue([[serverManager serverList] count] == 0, @"Number of servers should be 0, was %ld",(unsigned long)[[serverManager serverList] count]);
    
    //    Add new server
    [serverManager addEditServerWithServerName:TEST_SERVER_NAME andServerUrl:TEST_SERVER_URL withUsername:@"" andPassword:@"" atIndex:-1];
    XCTAssertTrue([[serverManager serverList] count] == 1, @"Number of servers should be 1, was %ld", (unsigned long)[[serverManager serverList] count]);
    
    //    Edit server
    [serverManager addEditServerWithServerName:SERVER_NAME_NEW andServerUrl:SERVER_URL_NEW withUsername:@"" andPassword:@"" atIndex:0];
    ServerObj *srv = [[serverManager serverList] objectAtIndex:0];
    XCTAssertNotNil(srv, @"Server should not be null");
    XCTAssertEqualObjects(srv.accountName, SERVER_NAME_NEW, @"New server name should be %@", SERVER_NAME_NEW);
    XCTAssertEqualObjects(srv.serverUrl, SERVER_URL_NEW, @"New server URL should be %@", SERVER_URL_NEW);
    
    //    Delete server
    [serverManager deleteServerObjAtIndex:0];
    XCTAssertTrue([[serverManager serverList] count] == 0, @"Number of servers should be 0, was %ld", (unsigned long)[[serverManager serverList] count]);
}

- (void)testSelectServer
{
    // Add 2 servers
    [serverHelper addNAccounts:2];
    
    XCTAssertEqual([serverManager selectedServerIndex], 0, @"Server at pos 0 should be selected");
    [serverManager setSelectedServerIndex:1];
    XCTAssertEqual([serverManager selectedServerIndex], 1, @"Server at pos 1 should be selected");
}

- (void)testAddAndSelectServer
{
    ServerObj * account = [[ServerObj alloc] init];
    account.accountName = TEST_SERVER_NAME;
    account.serverUrl = TEST_SERVER_URL;
    [serverManager addAndSelectServer:account];
    XCTAssertTrue([[serverManager serverList] count] == 1, @"Number of servers should be 1");
    XCTAssertEqual([serverManager selectedServerIndex], 0, @"Server at pos 0 should be selected");
}

- (void)testServerAlreadyExists
{
    //    Add new server
    [serverHelper addDefaultAccount];
    
    // Should return the existing server at index 0
    XCTAssertEqual([serverManager checkServerAlreadyExistsWithName:TEST_SERVER_NAME andURL:TEST_SERVER_URL andUsername:TEST_USER_NAME ignoringIndex:-1], 0, @"The server should already exist at index 0");
    
    // Should return -1 because the account name is different
    XCTAssertEqual([serverManager checkServerAlreadyExistsWithName:@"Foo Bar" andURL:TEST_SERVER_URL andUsername:TEST_USER_NAME ignoringIndex:-1], -1, @"The server should not exist");
    
    // Should return -1 because the account server URL is different
    XCTAssertEqual([serverManager checkServerAlreadyExistsWithName:TEST_SERVER_NAME andURL:@"http://foo.bar" andUsername:TEST_USER_NAME ignoringIndex:-1], -1, @"The server should not exist");
    
    // Should return -1 because the account username is different
    XCTAssertEqual([serverManager checkServerAlreadyExistsWithName:TEST_SERVER_NAME andURL:TEST_SERVER_URL andUsername:@"someuser" ignoringIndex:-1], -1, @"The server should not exist");
    
    // Should return -1 because the account username is empty
    XCTAssertEqual([serverManager checkServerAlreadyExistsWithName:TEST_SERVER_NAME andURL:TEST_SERVER_URL andUsername:@"" ignoringIndex:-1], -1, @"The server should not exist");
    
    // Should return -1 because all parameters are different
    XCTAssertEqual([serverManager checkServerAlreadyExistsWithName:@"Foo Bar" andURL:@"http://foo.bar" andUsername:@"someuser" ignoringIndex:-1], -1, @"The server should not exist");
}

- (void)testHandleStartupURL_WithoutUsername
{

    NSString * escapedURL = [self URLEncodedString:TEST_SERVER_URL];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"exomobile://serverUrl=%@", escapedURL]];

    
    [serverManager loadReceivedUrlToPreference:url];
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:EXO_CLOUD_USER_NAME_FROM_URL];
    XCTAssertNil(username, @"Username should be nil, has value %@ instead", username);
    ServerObj *server = [[serverManager serverList] objectAtIndex:0];
    XCTAssertEqualObjects(server.serverUrl, TEST_SERVER_URL, @"URL loaded is incorrect");
}

- (void)testHandleStartupURL_WithCloudURL
{
    
    NSString * escapedURL = [self URLEncodedString:TEST_CLOUD_URL];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"exomobile://serverUrl=%@", escapedURL]];
    
    
    [serverManager loadReceivedUrlToPreference:url];

    ServerObj *server = [[serverManager serverList] objectAtIndex:0];
    XCTAssertEqualObjects(server.serverUrl, TEST_CLOUD_URL, @"URL loaded is incorrect");
    NSString *expectedServerName = @"Mytenant";
    XCTAssertEqualObjects(expectedServerName, server.accountName, @"Generated server name is incorrect");
}

- (void)testHandleStartupURL_WithUsername
{
    NSString *username = @"john";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"exomobile://username=%@?serverUrl=%@", username, TEST_SERVER_URL]];
    
    [serverManager loadReceivedUrlToPreference:url];
    NSString *loadedUsername = [[NSUserDefaults standardUserDefaults] objectForKey:EXO_CLOUD_USER_NAME_FROM_URL];
    XCTAssertEqualObjects(loadedUsername, username, @"Username from UserDefaults should be %@ and not %@", username, loadedUsername);
    loadedUsername = nil;
    loadedUsername = [UserPreferencesManager sharedInstance].username;
    XCTAssertEqualObjects(loadedUsername, username, @"Username from PrefManager should be %@ and not %@", username, loadedUsername);
    ServerObj *server = [[serverManager serverList] objectAtIndex:0];
    XCTAssertEqualObjects(server.serverUrl, TEST_SERVER_URL, @"URL loaded is incorrect");
    
}


@end
