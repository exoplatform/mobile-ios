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
#import "SocialUserProfileCache.h"
#import "SocialTestsHelper.h"
#import "SocialUserProfile.h"

@interface SocialUserProfileCacheTestCase : ExoTestCase {
    SocialUserProfileCache *cache;
}

@end

@implementation SocialUserProfileCacheTestCase

- (void)setUp
{
    [super setUp];
    cache = [SocialUserProfileCache sharedInstance];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    cache = nil;
    [super tearDown];
}

- (void)testAddAndRetrieveProfileInCache
{
    SocialUserProfile *profile = [[SocialTestsHelper getInstance] createSocialUserProfile];
    
//    XCTAssertNil([cache cachedProfileForIdentity:profile.identity], @"The User Profile should not be in cache yet");
    
    [cache addInCache:profile forIdentity:profile.identity];
    
    XCTAssertEqualObjects([cache cachedProfileForIdentity:profile.identity], profile, @"The User Profile should be cached");
    
}

@end
