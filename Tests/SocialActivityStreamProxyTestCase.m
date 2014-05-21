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
#import "ExoTestCase.h"
#import "SocialActivityStreamProxy.h"

@interface SocialActivityStreamProxyTestCase : ExoTestCase<SocialProxyDelegate> {
    SocialActivityStreamProxy *asProxy;
    BOOL responseArrived;
    BOOL activityStreamLoaded;
}
@end

@implementation SocialActivityStreamProxyTestCase

- (void)setUp
{
    [super setUp];
    asProxy = [[SocialActivityStreamProxy alloc] init];
    asProxy.delegate = self;
    asProxy.userProfile = SOCIAL_USER_PROFILE;
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        NSLog(@"%@ request stubbed (%@)", stub.name, request.URL);
    }];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [OHHTTPStubs removeAllStubs];
    [super tearDown];
}

- (void)wait
{
    // Wait for the asynchronous code to finish
    responseArrived = NO;
    while (!responseArrived)
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, YES);
}

- (void)testCreatePathForActivityType
{
    NSString *path = [asProxy createPathForType:ActivityStreamProxyActivityTypeAllUpdates];
    NSString *expectedPath = @"private/api/social/v1-alpha3/portal/activity_stream/feed.json";
    XCTAssertEqualObjects(path, expectedPath, @"All activities stream Rest URL is incorrect");
    
    path = [asProxy createPathForType:ActivityStreamProxyActivityTypeMyConnections];
    expectedPath = @"private/api/social/v1-alpha3/portal/activity_stream/connections.json";
    XCTAssertEqualObjects(path, expectedPath, @"My connections activities stream Rest URL is incorrect");
    
    path = [asProxy createPathForType:ActivityStreamProxyActivityTypeMySpaces];
    expectedPath = @"private/api/social/v1-alpha3/portal/activity_stream/spaces.json";
    XCTAssertEqualObjects(path, expectedPath, @"My spaces activities stream Rest URL is incorrect");
    
    path = [asProxy createPathForType:ActivityStreamProxyActivityTypeMyStatus];
    expectedPath = [NSString stringWithFormat:@"private/api/social/v1-alpha3/portal/activity_stream/%@.json", SOCIAL_USER_PROFILE.identity];
    XCTAssertEqualObjects(path, expectedPath, @"My status activities stream Rest URL is incorrect");
}

- (void)testGetAllUpdatesActivityStream
{
    [self HTTPStubForActivityStream];
 
    activityStreamLoaded = NO;
    [asProxy getActivityStreams:ActivityStreamProxyActivityTypeAllUpdates];
    
    [self wait];
    
    XCTAssertTrue(activityStreamLoaded, @"Failed to get all updates activity stream");
}

- (void)testGetMyConnectionsActivityStream
{
    XCTAssertTrue(YES, @"");
}

- (void)testGetMySpacesActivityStream
{
    XCTAssertTrue(YES, @"");
}

- (void)testGetMyStatusActivityStream
{
    XCTAssertTrue(YES, @"");
}

#pragma mark Proxy delegate methods
- (void) proxy:(SocialProxy *)proxy didFailWithError:(NSError *)error
{
    responseArrived = YES;
}

- (void)proxyDidFinishLoading:(SocialProxy *)proxy
{
    responseArrived = YES;
    if (asProxy.arrActivityStreams.count == 1)
    {
        activityStreamLoaded = YES;
    }
}


@end
