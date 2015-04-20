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
#import "URLAnalyzer.h"

@interface URLAnalyzerTestCase : ExoTestCase

@end

@implementation URLAnalyzerTestCase

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

- (void)testParserURLWithPath
{
    NSString *url1 = @"demo.platform.exo.org/some/path";
    NSString *url2 = @"http://demo.platform.exo.org/some/path";
    NSString *expectedUrl = @"http://demo.platform.exo.org";
    
    XCTAssertEqualObjects([URLAnalyzer parserURL:url1], expectedUrl, @"Failed to parse and validate URL with path %@", url1);
    XCTAssertEqualObjects([URLAnalyzer parserURL:url2], expectedUrl, @"Failed to parse and validate URL with path %@", url2);
}

- (void)testParserURLWithQueryParam
{
    NSString *url = @"demo.platform.exo.org?foo=bar&param=value";
    NSString *expectedUrl = @"http://demo.platform.exo.org";
    
    XCTAssertEqualObjects([URLAnalyzer parserURL:url], expectedUrl, @"Failed to parse and validate URL with param %@", url);
}

- (void)testParserURLWithHTTPS
{
    NSString *url = @"https://demo.platform.exo.org";
    NSString *expectedUrl = @"https://demo.platform.exo.org";
    XCTAssertEqualObjects([URLAnalyzer parserURL:url], expectedUrl, @"Failed to parse and validate HTTPS URL %@", url);
}

- (void)testParserURLWithPort
{
    NSString *url = @"demo.platform.exo.org:8080";
    NSString *expectedUrl = @"http://demo.platform.exo.org:8080";
    XCTAssertEqualObjects([URLAnalyzer parserURL:url], expectedUrl, @"Failed to parse and validate URL with port number %@", url);
}

- (void)testParserURLWithIPAddress
{
    NSString *url = @"192.168.10.10";
    NSString *expectedUrl = @"http://192.168.10.10";
    XCTAssertEqualObjects([URLAnalyzer parserURL:url], expectedUrl, @"Failed to parse and validate IP address %@", url);
}

- (void)testCorrectServerURL
{
    for (NSString *url in TEST_URLS_OK) {
        NSString * correctUrl = [URLAnalyzer parserURL:url];
        XCTAssertNotNil(correctUrl, @"URL %@ (obtained from %@) should be correct", correctUrl, url);
    }
}

- (void)testIncorrectServerURL
{
    for (NSString *url in TEST_URLS_INCORRECT) {
        NSString * incorrectUrl = [URLAnalyzer parserURL:url];
        XCTAssertNil(incorrectUrl, @"URL %@ (obtained from %@) should be nil", incorrectUrl, url);
    }
}

- (void)testExtractDomainFromURL_Success
{
    // http
    NSArray* urls = @[
                      @"http://community.exoplatform.com/a/path",
                      @"http://community.exoplatform.com/",
                      @"http://community.exoplatform.com"
                      ];
    for (NSString* url in urls) {
        XCTAssertEqualObjects([URLAnalyzer extractDomainFromURL:url],
                              @"http://community.exoplatform.com",
                              @"Failed to extract domain from URL %@", url);
    }
    
    // https
    NSString* urlHttps = @"https://community.exoplatform.com/a/path";
    XCTAssertEqualObjects([URLAnalyzer extractDomainFromURL:urlHttps],
                          @"https://community.exoplatform.com",
                          @"Failed to extract domain from URL %@", urlHttps);
}

- (void)testExtractDomainFromURL_Failure
{
    NSArray* urls = @[
                      @"community.exoplatform.com/rest/private",
                      @"",
                      @"null"
                      ];
    for (NSString* url in urls) {
        XCTAssertEqualObjects([URLAnalyzer extractDomainFromURL:url],
                              @"",
                              @"Domain extraction from %@ should have failed and returned an empty string", url);
    }
}

@end
