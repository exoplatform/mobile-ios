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
#import "ActivityHelper.h"

@implementation ExoTestCase

- (void)setUp
{
    [super setUp];
    [self createVariables];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)logHTTPStubs
{
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        NSLog(@"%@ request stubbed (%@)", stub.name, request.URL);
    }];
}

- (void)HTTPStubForAuthenticationWithSuccess:(BOOL)success
{
    NSString *name = success ? @"Successful Authenticate challenge" : @"Failed Authenticate challenge";
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.path isEqualToString:@"/rest/private"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        if (success)
            return [OHHTTPStubsResponse responseWithData:[@"" dataUsingEncoding:NSUTF8StringEncoding] statusCode:200 headers:nil];
        else
            return [OHHTTPStubsResponse responseWithError:[NSError errorWithDomain:NSURLErrorDomain code:kCFURLErrorUserAuthenticationRequired userInfo:nil]];
    }].name = name;

}

- (void)HTTPStubForPlatformInfoAuthenticated:(BOOL)auth
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        if (auth)
            return [request.URL.path isEqualToString:@"/rest/private/platform/info"];
        else
            return [request.URL.path isEqualToString:@"/rest/platform/info"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"PlatformInfoResponse-4.0.json", nil) statusCode:200 headers:[NSDictionary dictionaryWithObject:@"application/json" forKey:@"Content-Type"]];
    }].name = @"Platform Information";
}

- (void)HTTPStubForActivityStream
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.path isEqualToString:@"/rest/private/api/social/v1-alpha3/portal/activity_stream/feed.json"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"ActivityStreamResponse-4.0.json", nil) statusCode:200 headers:[NSDictionary dictionaryWithObject:@"application/json" forKey:@"Content-Type"]];
    }].name = @"Activity Stream";
}

- (void)HTTPStubForActivityDetails
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.path isEqualToString:@"/rest/private/api/social/v1-alpha3/portal/activity/1e20cf09c06313bc0a9d372ecd6bd2a7.json"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"ActivityDetailsResponse-4.0.json", nil) statusCode:200 headers:[NSDictionary dictionaryWithObject:@"application/json" forKey:@"Content-Type"]];
    }].name = @"Activity Details";
}

- (void)HTTPStubForActivityLikes
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.path isEqualToString:@"/rest/private/api/social/v1-alpha3/portal/activity/1e20cf09c06313bc0a9d372ecd6bd2a7/likes.json"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"ActivityDetailsLikesResponse-4.0.json", nil) statusCode:200 headers:[NSDictionary dictionaryWithObject:@"application/json" forKey:@"Content-Type"]];
    }].name = @"Activity Likes";
}

- (void)HTTPStubForActivityComments
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.path isEqualToString:@"/rest/private/api/social/v1-alpha3/portal/activity/1e20cf09c06313bc0a9d372ecd6bd2a7/comments.json"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"ActivityDetailsCommentsResponse-4.0.json", nil) statusCode:200 headers:[NSDictionary dictionaryWithObject:@"application/json" forKey:@"Content-Type"]];
    }].name = @"Activity Comments";
}

- (void)HTTPStubForSocialUserProfileWithUsername:(NSString *)username
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSString *urlPath = [NSString stringWithFormat:@"/rest/private/api/social/v1-alpha3/portal/identity/organization/%@.json",
                                                        username];
        return [request.URL.path isEqualToString:urlPath];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"SocialUserProfileResponse-4.0.json", nil) statusCode:200 headers:[NSDictionary dictionaryWithObject:@"application/json" forKey:@"Content-Type"]];
    }].name = @"Social User Profile";
}

// based on http://stackoverflow.com/questions/3423545/objective-c-iphone-percent-encode-a-string/3426140#3426140
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

- (void)createVariables
{
    TEST_SERVER_URL = @"http://demo.platform.exo.org";
    TEST_SERVER_NAME = @"Test Server";
    
    TEST_USER_NAME = @"johndoe";
    TEST_USER_PASS = @"p4zzw0rd";
    TEST_USER_FIRST_NAME = @"John";
    TEST_USER_LAST_NAME = @"Doe";
    
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

- (SocialRestConfiguration *)createSocialRestConfiguration
{
    SocialRestConfiguration *conf = [SocialRestConfiguration sharedInstance];
    conf.restContextName = @"rest";
    conf.restVersion = @"v1-alpha3";
    conf.portalContainerName = @"portal";
    conf.username = TEST_USER_NAME;
    conf.password = TEST_USER_PASS;
    
    return conf;
}


- (SocialUserProfile *)createSocialUserProfile
{
    SocialUserProfile *profile = [[SocialUserProfile alloc] init];
    profile.identity = @"e4f574dec0a80126368b5c3e4cc727b4";
    profile.remoteId = TEST_USER_NAME;
    profile.providerId = @"organization";
    profile.fullName = [NSString stringWithFormat:@"%@ %@", TEST_USER_FIRST_NAME, TEST_USER_LAST_NAME];
    profile.avatarUrl = @"http://demo.platform.exo.org/rest/jcr/repository/social/organization/profile/johndoe/avatar/?upd=1378196459997";
    return profile;
}

- (SocialActivity *)createSocialActivity
{
    SocialActivity *act = [[SocialActivity alloc] init];
    act.activityId = @"1e20cf09c06313bc0a9d372ecd6bd2a7";
    act.identityId = @"d3c28a300a2106c658573c3c030bf9da";
    act.postedTime = 1400664805123;
    act.lastUpdated = 1400664805123;
    act.liked = NO;
    act.title = @"A cool activity";
    act.body = @"";
    act.activityType = ACTIVITY_LINK;
    return act;
}


@end
