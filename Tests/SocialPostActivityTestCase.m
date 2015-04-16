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
#import "AsyncProxyTestCase.h"
#import "SocialPostActivity.h"
#import "SocialActivity.h"
#import "HTTPStubsHelper.h"
#import "ApplicationPreferencesManager.h"


@interface SocialPostActivityTestCase : AsyncProxyTestCase<SocialProxyDelegate> {
    SocialPostActivity *actProxy;
    BOOL hasError;
    HTTPStubsHelper *httpHelper;
}

@end

@implementation SocialPostActivityTestCase

- (void)setUp
{
    [super setUp];
    actProxy = [[SocialPostActivity alloc] init];
    actProxy.delegate = self;
    httpHelper = [HTTPStubsHelper getInstance];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testCreatePath
{
    NSString *path = [actProxy createPath];
    NSString *expectedPath = @"private/api/social/v1-alpha3/portal/activity.json";
    
    XCTAssertEqualObjects(path, expectedPath, @"URL to post activity is not correct");
}

- (void)testPostActivityWithMessage
{
    [httpHelper HTTPStubForPostActivity];
    [httpHelper logWhichStubsAreRegistered];
    
    NSString *message = @"A cool activity";
    hasError = YES;
    
    [actProxy postActivity:message fileURL:nil fileName:nil toSpace:nil];
    
    [self wait];
    
    XCTAssertTrue(responseArrived, @"Server did not respond to POST activity request");
    XCTAssertFalse(hasError, @"Incorrect response to POST activity request");
}

- (void)testPostActivityWithFile
{
    ApplicationPreferencesManager *appPM = [ApplicationPreferencesManager sharedInstance];
    [appPM setJcrRepositoryName:@"repository" defaultWorkspace:@"collaboration" userHomePath:@"Users/johndoe"];
    [httpHelper HTTPStubForPostActivity];
    [httpHelper logWhichStubsAreRegistered];
    hasError = YES;
    
    [actProxy postActivity:@""
                fileURL:[NSString stringWithFormat:@"%@/%@", TEST_SERVER_URL, @"rest/private/jcr/repository/collaboration/Users/johndoe/Public/file.txt"]
                  fileName:@"My Document" toSpace:nil];
    
    [self wait];
    
    XCTAssertTrue(responseArrived, @"Server did not respond to POST activity request");
    XCTAssertFalse(hasError, @"Incorrect response to POST activity request");
}

#pragma mark Proxy delegate methods

- (void)proxy:(SocialProxy *)proxy didFailWithError:(NSError *)error
{
    [super proxy:proxy didFailWithError:error];
    hasError = YES;
}

- (void)proxyDidFinishLoading:(SocialProxy *)proxy
{
    [super proxyDidFinishLoading:proxy];
    hasError = NO;
}

@end
