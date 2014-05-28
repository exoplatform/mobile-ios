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
#import "AsyncProxyTestCase.h"
#import "HTTPStubsHelper.h"


@interface LoginProxyTestCase : AsyncProxyTestCase <LoginProxyDelegate> {
    LoginProxy *loginProxy;
    BOOL platformInfoRetrieved;
    HTTPStubsHelper *httpHelper;
}

@end

@implementation LoginProxyTestCase

- (void)setUp
{
    [super setUp];
    loginProxy = [[LoginProxy alloc] initWithDelegate:self username:TEST_USER_NAME password:TEST_USER_PASS serverUrl:TEST_SERVER_URL];
    httpHelper = [HTTPStubsHelper getInstance];

    // Put setup code here. This method is called before the invocation of each test method in the class.
}


- (void)testAuthenticateAndGetPlatformInfo
{
    [httpHelper HTTPStubForAuthenticationWithSuccess:YES];
    [httpHelper HTTPStubForPlatformInfoAuthenticated:YES];
    
    platformInfoRetrieved = NO;
    [loginProxy authenticate];
    
    [self wait];
    
    XCTAssertTrue(platformInfoRetrieved, @"Could not authenticate and retrieve Platform info");
}

- (void)testAuthenticationFailure
{
    [httpHelper HTTPStubForAuthenticationWithSuccess:NO];
    
    platformInfoRetrieved = NO;
    [loginProxy authenticate];
    
    [self wait];
    
    XCTAssertFalse(platformInfoRetrieved, @"Authenticate should have failed");
}

- (void)testRetrievePlatformInfo
{
    [httpHelper HTTPStubForPlatformInfoAuthenticated:NO];
    
    platformInfoRetrieved = NO;
    [loginProxy retrievePlatformInformations];
    
    [self wait];
    
    XCTAssertTrue(platformInfoRetrieved, @"Could not retrieve public Platform info");
}

#pragma mark Proxy delegate methods

- (void) loginProxy:(LoginProxy *)proxy authenticateFailedWithError:(NSError *)error
{
    [super loginProxy:proxy authenticateFailedWithError:error];
    platformInfoRetrieved = NO;
    NSLog(@"Could not authenticate because: %@", [error description]);
}

- (void) loginProxy:(LoginProxy *)proxy platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion
{
    [super loginProxy:proxy platformVersionCompatibleWithSocialFeatures:compatibleWithSocial withServerInformation:platformServerVersion];
    platformInfoRetrieved = YES;
}


@end
