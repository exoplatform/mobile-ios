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
#import "SocialLikeActivityProxy.h"
#import "HTTPStubsHelper.h"

@interface SocialLikeActivityProxyTestCase : AsyncProxyTestCase<SocialProxyDelegate> {
    BOOL hasError;
    SocialLikeActivityProxy *likeProxy;
}

@end

@implementation SocialLikeActivityProxyTestCase

- (void)setUp
{
    [super setUp];
    likeProxy = [[SocialLikeActivityProxy alloc] init];
    likeProxy.delegate = self;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testPostLikeActivity
{
    [[HTTPStubsHelper getInstance] HTTPStubForLikeActivityWithBoolean:YES];
    
    hasError = YES;
    [likeProxy likeActivity:@"1e20cf09c06313bc0a9d372ecd6bd2a7"];
    
    [self wait];
    
    XCTAssertTrue(responseArrived, @"Server did not respond to POST like request");
    XCTAssertFalse(hasError, @"Incorrect response to POST like request");
}

- (void)testDeleteLikeActivity
{
    [[HTTPStubsHelper getInstance] HTTPStubForLikeActivityWithBoolean:NO];
    
    hasError = YES;
    [likeProxy dislikeActivity:@"1e20cf09c06313bc0a9d372ecd6bd2a7"];
    
    [self wait];
    
    XCTAssertTrue(responseArrived, @"Server did not respond to DELETE like request");
    XCTAssertFalse(hasError, @"Incorrect response to DELETE like request");

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
