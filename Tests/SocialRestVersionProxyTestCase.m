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
#import "SocialRestProxy.h"
#import "HTTPStubsHelper.h"
#import "SocialRestConfiguration.h"
#import "SocialTestsHelper.h"

@interface SocialRestVersionProxyTestCase : AsyncProxyTestCase<SocialProxyDelegate> {
    SocialRestProxy *verProxy;
}

@end

@implementation SocialRestVersionProxyTestCase

- (void)setUp
{
    [super setUp];
    verProxy = [[SocialRestProxy alloc] init];
    verProxy.delegate = self;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testCreatePath
{
    NSString *path = [verProxy createPath];
    NSString *expectedPath = @"api/social/version/latest.json";
    
    XCTAssertEqualObjects(path, expectedPath, @"URL to get Rest version is incorrect");
}

- (void)testGetVersion
{
    [[HTTPStubsHelper getInstance] HTTPStubForGetLatestVersion];
    
    // reset the version stored in social rest configuration
    [[SocialTestsHelper getInstance] clearSocialRestConfiguration];
    
    [verProxy getVersion];
    
    [self wait];
    
    NSString *version = [SocialRestConfiguration sharedInstance].restVersion;
    NSString *expectedVersion = @"v1-alpha3";
    
    XCTAssertEqualObjects(version, expectedVersion, @"Latest version retrieved is incorrect");
    
    [[SocialTestsHelper getInstance] clearSocialRestConfiguration];
}


@end
