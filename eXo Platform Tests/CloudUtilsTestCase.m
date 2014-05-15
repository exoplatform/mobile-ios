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

@interface CloudUtilsTestCase : XCTestCase {
    NSArray *EMAILS_OK;
    NSArray *EMAILS_INCORRECT;
    NSArray *URLS_OK;
    NSArray *URLS_INCORRECT;
}

@end

@implementation CloudUtilsTestCase

- (void)setUp
{
    [super setUp];
    EMAILS_OK = [NSArray arrayWithObjects:
                 @"test@example.com",
                 @"test.test@example.com",
                 @"test-test@example.com",
                 @"test_test@example.com",
                 @"test+test@example.com",
                 @"test@test.example.com",
                 @"test@test-example.com",
                 //@"test@test_example.com",
                 nil];
    
    EMAILS_INCORRECT = [NSArray arrayWithObjects:
                        @"example.com",
                        @"@example.com",
                        @"test",
                        @"test@", nil];
    
    URLS_OK = [NSArray arrayWithObjects:
               @"test.com",
               @"test.example.com",
               @"test-example.com",
               @"test.fr",
               @"test.info",
               @"http://test.com",
               @"https://test.com",
               @"t.e.s.t.com",
               @"test.com:80",
               @"test123.com",
               @"www.test.com/some/path",
               @"test",
               @"test_example.com",
               // @"10.100.10.1",
               nil];
    
    URLS_INCORRECT = [NSArray arrayWithObjects:
                      @"test.",
                      @"test{}.com",
                      @"test().com",
                      @"test[].com",
                      @"test!.com",
                      @"test&.com",
                      @"test*.com",
                      @"test|.com",
                      @"test example.com",
                      @"test...example.com",
                      //@"test~.com",
                      //@".com",
                      //@"test@.com",
                      //@"test#.com",
                      //@"test$.com",
                      nil];

}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEmailFormat
{
    
    for (NSString *email in EMAILS_OK) {
        XCTAssertTrue([CloudUtils checkEmailFormat:email], @"Email %@ should be correct", email);
    }
    
    for (NSString *email in EMAILS_INCORRECT) {
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
    NSString *expectedUrl = @"http://mytenant.exoplatform.net";
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

- (void)testCorrectServerURL
{
    for (NSString *url in URLS_OK) {
        XCTAssertNotNil([CloudUtils correctServerUrl:url], @"URL %@ should be correct", url);
    }
    
    for (NSString *url in URLS_INCORRECT) {
        XCTAssertNil([CloudUtils correctServerUrl:url], @"URL %@ should be incorrect", url);
    }
}

- (void)testNameContainsSpecialCharacters
{
    NSArray *names = [NSArray arrayWithObjects:
                      @"test&",
                      @"test<>",
                      @"test\"",
                      @"test'",
                      @"test!",
                      @"test;",
                      @"test\\",
                      @"test|",
                      @"test()",
                      @"test{}",
                      @"test[]",
                      @"test,",
                      @"test*",
                      @"test%",
                      nil];
    NSString *specialChars = @"&<>\"'!;\\|(){}[],*%";
    
    for (NSString *name in names) {
        XCTAssertTrue([CloudUtils nameContainSpecialCharacter:name inSet:specialChars], @"Name %@ should be incorrect", name);
    }
}

@end
