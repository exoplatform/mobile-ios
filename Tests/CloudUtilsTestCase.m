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
#import "CloudUtils.h"
#import "ExoTestCase.h"

@interface CloudUtilsTestCase : ExoTestCase

@end

@implementation CloudUtilsTestCase

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEmailFormat
{
    
    for (NSString *email in TEST_EMAILS_OK) {
        XCTAssertTrue([CloudUtils checkEmailFormat:email], @"Email %@ should be correct", email);
    }
    
    for (NSString *email in TEST_EMAILS_INCORRECT) {
        XCTAssertFalse([CloudUtils checkEmailFormat:email], @"Email %@ should be incorrect", email);
    }
}

- (void)testGetUsernameFromEmail
{
    NSString *email = @"test@example.com";
    XCTAssertEqualObjects([CloudUtils usernameByEmail:email], @"test", @"Username should be test");
}

- (void)testGetServerURLFromTenantName
{
    NSString *tenant = @"mytenant";
    NSString *expectedUrl = @"https://mytenant.exoplatform.net";
    XCTAssertEqualObjects([CloudUtils serverUrlByTenant:tenant], expectedUrl , @"URL from %@ should be %@", tenant, expectedUrl);
    
}

- (void)testGetTenantNameFromServerURL
{
    NSString *expectedTenant = @"mytenant";
    NSArray *URLs = [NSArray arrayWithObjects:
                     @"http://mytenant.exoplatform.net",
                     @"https://mytenant.exoplatform.net",
                     //@"mytenant.exoplatform.net",
                     nil];
    
    for (NSString *url in URLs) {
            XCTAssertEqualObjects([CloudUtils tenantFromServerUrl:url], expectedTenant, @"Tenant name from %@ should be %@", url, expectedTenant);
    }
    
}


@end
