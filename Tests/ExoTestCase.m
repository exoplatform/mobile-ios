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

#import "ExoTestCase.h"

@implementation ExoTestCase

- (void)setUp
{
    [super setUp];
    [self initVariables];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (NSString *) URLEncodedString:(NSString*)s
{
    NSMutableString * output = [NSMutableString string];
    const unsigned char * source = (const unsigned char *)[s UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

- (void)initVariables
{
    TEST_SERVER_URL = @"http://demo.platform.exo.org";
    TEST_SERVER_NAME = @"Test Server";
    
    TEST_EMAILS_OK = [NSArray arrayWithObjects:
                 @"test@example.com",
                 @"test.test@example.com",
                 @"test-test@example.com",
                 @"test_test@example.com",
                 @"test+test@example.com",
                 @"test@test.example.com",
                 @"test@test-example.com",
                 //@"test@test_example.com",
                 nil];
    
    TEST_EMAILS_INCORRECT = [NSArray arrayWithObjects:
                        @"example.com",
                        @"@example.com",
                        @"test",
                        @"test@", nil];
    
    TEST_URLS_OK = [NSArray arrayWithObjects:
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
    
    TEST_URLS_INCORRECT = [NSArray arrayWithObjects:
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

@end
