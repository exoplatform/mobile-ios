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
#import "SocialUserProfileProxy.h"
#import "HTTPStubsHelper.h"
#import "SocialTestsHelper.h"

@interface SocialUserProfileProxyTestCase : AsyncProxyTestCase<SocialProxyDelegate> {
    SocialUserProfileProxy *proxy;
    SocialUserProfile *profile;
    HTTPStubsHelper *httpHelper;
}

@end

@implementation SocialUserProfileProxyTestCase

- (void)setUp
{
    [super setUp];
    proxy = [[SocialUserProfileProxy alloc] init];
    proxy.delegate = self;
    profile = [[SocialTestsHelper getInstance] createSocialUserProfile];
    httpHelper = [HTTPStubsHelper getInstance];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}


- (void)testGetUserProfileFromUsername
{
    [httpHelper HTTPStubForSocialUserProfileWithUsername:profile.remoteId];
    
    [proxy getUserProfileFromUsername:profile.remoteId];
    
    [self wait];
    
    XCTAssertEqualObjects(proxy.userProfile.identity, profile.identity, @"Failed to retrieve the correct user profile id");
    XCTAssertEqualObjects(proxy.userProfile.fullName, profile.fullName, @"Failed to retrieve the correct user full name");
    XCTAssertEqualObjects(proxy.userProfile.remoteId, profile.remoteId, @"Failed to retrieve the correct username");
    XCTAssertEqualObjects(proxy.userProfile.providerId, profile.providerId, @"Failed to retrieve the correct user profile provider");
    XCTAssertEqualObjects(proxy.userProfile.avatarUrl, profile.avatarUrl, @"Failed to retrieve the correct user profile avatar url");
}




@end
