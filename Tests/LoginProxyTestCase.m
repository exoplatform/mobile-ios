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
#import "OHHTTPStubs.h"
#import "AsyncProxyTestCase.h"
#import "HTTPStubsHelper.h"
#import "AlreadyAccountViewController.h"
#import "OnPremiseViewController.h"
#import "ApplicationPreferencesManager.h"


@interface LoginProxyTestCase : AsyncProxyTestCase <LoginProxyDelegate> {
    LoginProxy *loginProxy;
    PlatformServerVersion *platformInfo;
    BOOL isCompatibleWithSocial;
    HTTPStubsHelper *httpHelper;
}

@end

@implementation LoginProxyTestCase

- (void)setUp
{
    [super setUp];
    loginProxy = [[LoginProxy alloc] initWithDelegate:self username:TEST_USER_NAME password:TEST_USER_PASS serverUrl:TEST_SERVER_URL];
    httpHelper = [HTTPStubsHelper getInstance];
    [httpHelper logStubbedHTTPRequests];
    isCompatibleWithSocial = NO;
    platformInfo = nil;

    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (BOOL)platformInfoIsCorrect
{
    return ([platformInfo.platformVersion isEqualToString:@"4.0.4"] &&
            [platformInfo.platformRevision isEqualToString:@"f36545a96e407e0d58d685f79d818612356e49dd"] &&
            [platformInfo.platformBuildNumber isEqualToString:@"20131225"] &&
            [platformInfo.isMobileCompliant isEqualToString:@"true"] &&
            [platformInfo.platformEdition isEqualToString:@"ENTERPRISE"]);
}

- (void)testAuthenticateAndGetPlatformInfo
{
    [httpHelper HTTPStubForAuthenticationWithSuccess:YES];
    [httpHelper HTTPStubForPlatformInfoAuthenticated:YES];
    [httpHelper logWhichStubsAreRegistered];
    
    [loginProxy authenticate];
    
    [self wait];
    
    XCTAssertTrue(isCompatibleWithSocial, @"Authenticate and retrieve Platform info failed: not compatible with Social");
    XCTAssertTrue([self platformInfoIsCorrect], @"Authenticate and retrieve Platform info failed: incorrect Platform info");
}

- (void)testAuthenticationFailure
{
    [httpHelper HTTPStubForAuthenticationWithSuccess:NO];
    [httpHelper logWhichStubsAreRegistered];
    
    [loginProxy authenticate];
    
    [self wait];
    
    XCTAssertFalse(isCompatibleWithSocial, @"Authenticate should have failed");
    XCTAssertNil(platformInfo, @"Authenticate should have failed");
}

- (void)testRetrievePlatformInfo
{
    [httpHelper HTTPStubForPlatformInfoAuthenticated:NO];
    [httpHelper logWhichStubsAreRegistered];
    
    [loginProxy retrievePlatformInformations];
    
    [self wait];
    
    XCTAssertTrue(isCompatibleWithSocial, @"Retrieve public Platform info failed: not compatible with Social");
    XCTAssertTrue([self platformInfoIsCorrect], @"Retrieve public Platform info failed: incorrect Platform info");
}

//- (void)testAccountIsCreated_WithCloudURL
//{
//    [httpHelper HTTPStubForAuthenticationWithSuccess:YES];
//    [httpHelper HTTPStubForPlatformInfoAuthenticated:YES];
//    [httpHelper logWhichStubsAreRegistered];
//    
//    loginProxy.serverUrl = TEST_CLOUD_URL;
//    AlreadyAccountViewController* del = [[AlreadyAccountViewController alloc]init];
//    //loginProxy.delegate = del;
//    
//    [loginProxy authenticate];
//    
//    [self wait];
//    
//    ApplicationPreferencesManager* serverManager = [ApplicationPreferencesManager sharedInstance];
//    
//    ServerObj* account = [serverManager getSelectedAccount];
//    
//    XCTAssertNotNil(account, @"Account should have been created and automatically selected");
//    
//}

#pragma mark Proxy delegate methods

- (void) loginProxy:(LoginProxy *)proxy authenticateFailedWithError:(NSError *)error
{
    [super loginProxy:proxy authenticateFailedWithError:error];
    isCompatibleWithSocial = NO;
    platformInfo = nil;
    NSLog(@"ERROR: %@", [error description]);
}

- (void) loginProxy:(LoginProxy *)proxy platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion
{
    [super loginProxy:proxy platformVersionCompatibleWithSocialFeatures:compatibleWithSocial withServerInformation:platformServerVersion];

    isCompatibleWithSocial = compatibleWithSocial;
    platformInfo = platformServerVersion;
}

@end
