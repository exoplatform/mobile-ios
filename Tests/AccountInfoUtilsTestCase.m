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
#import "AccountInfoUtils.h"
#import "ExoTestCase.h"

@interface AccountInfoUtilsTestCase : ExoTestCase

@end

@implementation AccountInfoUtilsTestCase

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAccountNameIsNotCorrect
{
    NSString *forbiddenChars = @"` ~ ! @ # $ % ^ & * ( ) _ - + = { } [ ] | \\ : ; \" ' < > , . ? /";
    NSArray *chars = [forbiddenChars componentsSeparatedByString:@" "];
    for (NSString *c in chars) {
        NSString* name = [NSString stringWithFormat:@"Test %@", c];
        XCTAssertFalse([AccountInfoUtils accountNameIsValid:name], @"Name %@ should be incorrect", name);
    }
}

- (void)testAccountNameIsCorrect
{
    NSArray *names = [NSArray arrayWithObjects:
                      @"Test",
                      @"test123",
                      @"Test 1",
                      @"1 test",
                      @"123 TEST",
                      nil];
    
    for (NSString *name in names) {
        XCTAssertTrue([AccountInfoUtils accountNameIsValid:name], @"Name %@ should be correct", name);
    }
}

- (void)testUsernameIsCorrect
{
    NSArray *names = [NSArray arrayWithObjects:
                      @"test",
                      @"test123",
                      @"Test.1",
                      @"1-test",
                      @"123_TEST",
                      @"test+user",
                      nil];
    
    for (NSString *username in names) {
        XCTAssertTrue([AccountInfoUtils usernameIsValid:username], @"Username %@ should be correct", username);
    }
}

- (void)testUsernameIsNotCorrect
{
    NSString *forbiddenChars = @"` ~ ! @ # $ % ^ & * ( ) = { } [ ] | \\ : ; \" ' < > , ? /";
    NSArray *chars = [forbiddenChars componentsSeparatedByString:@" "];
    
    for (NSString *c in chars) {
        NSString* username = [NSString stringWithFormat:@"%@%@%@", @"user", c, @"user"];
        XCTAssertFalse([AccountInfoUtils usernameIsValid:username], @"Username %@ should be incorrect", username);
    }

    NSArray *names = [NSArray arrayWithObjects:
                      @" test",
                      @"test 123",
                      @"Test ",
                      @" test ",
                      nil];

    for (NSString *username in names) {
        XCTAssertFalse([AccountInfoUtils usernameIsValid:username], @"Username %@ should be incorrect", username);
    }
}

- (void)testAccountNameExtraction_CloudURL
{
    NSString* url = TEST_CLOUD_URL; // http://mytenant.exoplatform.net
    
    NSString* name = [AccountInfoUtils extractAccountNameFromURL:url];
    
    XCTAssertEqualObjects(@"Mytenant", name, @"Extracted tenant name is incorrect");
}

- (void)testAccountNameExtraction_Localhost
{
    NSString* url = @"http://localhost";
    
    NSString* name = [AccountInfoUtils extractAccountNameFromURL:url];
    
    XCTAssertEqualObjects(@"Localhost", name, @"Extracted name is incorrect");
}

- (void)testAccountNameExtraction_ShortURL
{
    NSString* url = @"http://mycompany.com";
    
    NSString* name = [AccountInfoUtils extractAccountNameFromURL:url];
    
    XCTAssertEqualObjects(@"Mycompany", name, @"Extracted name is incorrect");
}

- (void)testAccountNameExtraction_NormalURL
{
    NSString* url = @"http://int.mycompany.com";
    
    NSString* name = [AccountInfoUtils extractAccountNameFromURL:url];
    
    XCTAssertEqualObjects(@"Int", name, @"Extracted name is incorrect");
}

- (void)testAccountNameExtraction_LongURL
{
    NSString* url = @"http://int.my.cool.company.com";
    
    NSString* name = [AccountInfoUtils extractAccountNameFromURL:url];
    
    XCTAssertEqualObjects(@"Int", name, @"Extracted name is incorrect");
}

- (void)testAccountNameExtraction_HTTPS_URL
{
    NSString* url = @"https://int.mycompany.com";
    
    NSString* name = [AccountInfoUtils extractAccountNameFromURL:url];
    
    XCTAssertEqualObjects(@"Int", name, @"Extracted name is incorrect");
}

- (void)testAccountNameExtraction_IP
{
    NSString* url = @"http://192.168.4.42";
    
    NSString* name = [AccountInfoUtils extractAccountNameFromURL:url];
    
    XCTAssertEqualObjects(@"192.168.4.42", name, @"Extracted name is incorrect");

}

- (void)testAccountNameExtraction_URL_With_Port
{
    NSString* url = @"http://mycompany.com:8080";
    
    NSString* name = [AccountInfoUtils extractAccountNameFromURL:url];
    
    XCTAssertEqualObjects(@"Mycompany", name, @"Extracted name is incorrect");
}

- (void)testAccountNameExtraction_IP_With_Port
{
    NSString* url = @"http://192.168.4.42:8080";
    
    NSString* name = [AccountInfoUtils extractAccountNameFromURL:url];
    
    XCTAssertEqualObjects(@"192.168.4.42", name, @"Extracted name is incorrect");
    
}


@end
