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
#import <OHHTTPStubs.h>
#import "ExoTestCase.h"
#import "AuthenticateProxy.h"
#import "HTTPStubsHelper.h"

@interface AuthenticateProxyTestCase : ExoTestCase {
    AuthenticateProxy *proxy;
    HTTPStubsHelper *httpHelper;
}

@end

@implementation AuthenticateProxyTestCase

- (void)setUp
{
    [super setUp];
    proxy = [AuthenticateProxy sharedInstance];
    httpHelper = [HTTPStubsHelper getInstance];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [OHHTTPStubs removeAllStubs];
    [super tearDown];
}

- (void)testCheckReachabilitySuccessful
{
    [httpHelper HTTPStubForReachabilityRequestWithSuccess:YES];

    BOOL isReachable = [proxy isReachabilityURL:TEST_SERVER_URL userName:TEST_USER_NAME password:TEST_USER_PASS];
    
    XCTAssertTrue(isReachable, @"Request to test reachability failed");
}

- (void)testCheckReachabilityFailedWithError
{
    [httpHelper HTTPStubForReachabilityRequestWithSuccess:NO];

    BOOL isReachable = [proxy isReachabilityURL:TEST_SERVER_URL userName:TEST_USER_NAME password:TEST_USER_PASS];
    
    XCTAssertFalse(isReachable, @"Request to test reachability should have failed");
}

- (void)testCheckReachabilityFailedWithBadResponses
{
    NSArray *respCodes = [NSArray arrayWithObjects:
                          [NSNumber numberWithInt:100],
                          [NSNumber numberWithInt:301], [NSNumber numberWithInt:304],
                          [NSNumber numberWithInt:400], [NSNumber numberWithInt:401], [NSNumber numberWithInt:403],
                                [NSNumber numberWithInt:404], [NSNumber numberWithInt:408],
                          [NSNumber numberWithInt:500], [NSNumber numberWithInt:502], [NSNumber numberWithInt:503], nil];
    
    for (NSNumber *n in respCodes) {
        [httpHelper HTTPStubForReachabilityRequestWithResponseCode:[n intValue]];
        BOOL isReachable = [proxy isReachabilityURL:TEST_SERVER_URL userName:@"" password:@""];
        XCTAssertFalse(isReachable, @"Request to test reachability should have failed with response %d", [n intValue]);
    }
}



@end
