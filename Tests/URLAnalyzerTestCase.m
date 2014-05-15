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

- (void)testParserURL
{
    NSArray *originUrls = [NSArray arrayWithObjects:
                           @"demo.platform.exo.org/portal",
                           @"http://demo.platform.exo.org",
                           @"demo.platform.exo.org/",
                           @"http://demo.platform.exo.org/portal",
                           nil];
    
    for (NSString *url in originUrls) {

        XCTAssertEqualObjects([URLAnalyzer parserURL:url], TEST_SERVER_URL, @"Failed to parse and validate URL %@",url);
    }

}

- (void)testParserURLWithHTTPS
{
    NSString *url = @"https://demo.platform.exo.org/portal";
    NSString *expectedUrl = @"https://demo.platform.exo.org";
    XCTAssertEqualObjects([URLAnalyzer parserURL:url], expectedUrl, @"Failed to parse and validate HTTPS URL %@", url);
}

- (void)testParserURLWithPort
{
    NSString *url = @"https://demo.platform.exo.org:80/portal";
    NSString *expectedUrl = @"https://demo.platform.exo.org:80";
    XCTAssertEqualObjects([URLAnalyzer parserURL:url], expectedUrl, @"Failed to parse and validate HTTPS URL %@", url);
}

@end
