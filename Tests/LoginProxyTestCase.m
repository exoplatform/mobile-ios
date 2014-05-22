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
#import "LoginProxy.h"
#import <OHHTTPStubs.h>
#import "ExoTestCase.h"
#import "HTTPStubsHelper.h"


@interface LoginProxyTestCase : ExoTestCase <LoginProxyDelegate> {
    LoginProxy *proxy;
    BOOL platformInfoRetrieved;
    BOOL responseArrived;
    HTTPStubsHelper *httpHelper;
}

@end

@implementation LoginProxyTestCase

- (void)setUp
{
    [super setUp];
    proxy = [[LoginProxy alloc] initWithDelegate:self username:TEST_USER_NAME password:TEST_USER_PASS serverUrl:TEST_SERVER_URL];
    httpHelper = [HTTPStubsHelper getInstance];

    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)wait
{
    // Wait for the asynchronous code to finish
    responseArrived = NO;
    while (!responseArrived)
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, YES);
}

- (void)testAuthenticateAndGetPlatformInfo
{
    [httpHelper HTTPStubForAuthenticationWithSuccess:YES];
    [httpHelper HTTPStubForPlatformInfoAuthenticated:YES];
    
    platformInfoRetrieved = NO;
    [proxy authenticate];
    
    [self wait];
    
    XCTAssertTrue(platformInfoRetrieved, @"Could not authenticate and retrieve Platform info");
}

- (void)testAuthenticationFailure
{
    [httpHelper HTTPStubForAuthenticationWithSuccess:NO];
    
    platformInfoRetrieved = NO;
    [proxy authenticate];
    
    [self wait];
    
    XCTAssertFalse(platformInfoRetrieved, @"Authenticate should have failed");
}

- (void)testRetrievePlatformInfo
{
    [httpHelper HTTPStubForPlatformInfoAuthenticated:NO];
    
    platformInfoRetrieved = NO;
    [proxy retrievePlatformInformations];
    
    [self wait];
    
    XCTAssertTrue(platformInfoRetrieved, @"Could not retrieve public Platform info");
}

#pragma mark Proxy delegate methods

- (void) loginProxy:(LoginProxy *)proxy authenticateFailedWithError:(NSError *)error
{
    responseArrived = YES;
    platformInfoRetrieved = NO;
    NSLog(@"Could not authenticate because: %@", [error description]);
}

- (void) loginProxy:(LoginProxy *)proxy platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion
{
    responseArrived = YES;
    platformInfoRetrieved = YES;
}


@end
