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
#import "SocialActivityStreamProxy.h"
#import "HTTPStubsHelper.h"
#import "SocialTestsHelper.h"
#import "ActivityHelper.h"

@interface SocialActivityStreamProxyTestCase : AsyncProxyTestCase<SocialProxyDelegate> {
    SocialActivityStreamProxy *asProxy;
    HTTPStubsHelper *httpHelper;
    SocialTestsHelper *socHelper;
}
@end

@implementation SocialActivityStreamProxyTestCase

- (void)setUp
{
    [super setUp];
    socHelper = [SocialTestsHelper getInstance];
    asProxy = [[SocialActivityStreamProxy alloc] init];
    asProxy.delegate = self;
    asProxy.userProfile = [socHelper createSocialUserProfile];
    [socHelper createSocialRestConfiguration];
    httpHelper = [HTTPStubsHelper getInstance];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}


- (void)testCreatePathForActivityType
{
    NSString *path = [asProxy createPathForType:ActivityStreamProxyActivityTypeAllUpdates];
    NSString *expectedPath = @"private/api/social/v1-alpha3/portal/activity_stream/feed.json";
    XCTAssertEqualObjects(path, expectedPath, @"All activities stream Rest URL is incorrect");
    
    path = [asProxy createPathForType:ActivityStreamProxyActivityTypeMyConnections];
    expectedPath = @"private/api/social/v1-alpha3/portal/activity_stream/connections.json";
    XCTAssertEqualObjects(path, expectedPath, @"My connections activities stream Rest URL is incorrect");
    
    path = [asProxy createPathForType:ActivityStreamProxyActivityTypeMySpaces];
    expectedPath = @"private/api/social/v1-alpha3/portal/activity_stream/spaces.json";
    XCTAssertEqualObjects(path, expectedPath, @"My spaces activities stream Rest URL is incorrect");
    
    path = [asProxy createPathForType:ActivityStreamProxyActivityTypeMyStatus];
    NSString *identityId = asProxy.userProfile.identity;
    expectedPath = [NSString stringWithFormat:@"private/api/social/v1-alpha3/portal/activity_stream/%@.json", identityId];
    XCTAssertEqualObjects(path, expectedPath, @"My status activities stream Rest URL is incorrect");
}

- (void)testGetActivityStream
{
    [httpHelper HTTPStubForActivityStream];
    [httpHelper logWhichStubsAreRegistered];
 
    [asProxy getActivityStreams:ActivityStreamProxyActivityTypeAllUpdates];
    
    [self wait];
    
    NSArray *activities = asProxy.arrActivityStreams;
    
    XCTAssertEqual(activities.count, 1, @"Failed to get activity stream");
    
    SocialActivity *activity = [activities objectAtIndex:0];
    
    XCTAssertEqualObjects(activity.type, @"LINK_ACTIVITY", @"Mapping of activity stream failed: incorrect activity type");
    XCTAssertEqualObjects(activity.activityId, @"1e20cf09c06313bc0a9d372ecd6bd2a7", @"Mapping of activity stream failed: incorrect activity ID");
    XCTAssertEqualObjects(activity.title, @"Login", @"Mapping of activity stream failed: incorrect activity title");
    XCTAssertEqualObjects(activity.identityId, @"d3c28a300a2106c658573c3c030bf9da", @"Mapping of activity stream failed: incorrect identity ID");
    XCTAssertEqual(activity.postedTime, 1400664805123, @"Mapping of activity stream failed: incorrect posted time");
    XCTAssertEqual(activity.lastUpdated, 1400664805123, @"Mapping of activity stream failed: incorrect last updated time");
    XCTAssertTrue(activity.liked, @"Mapping of activity stream failed: activity is liked");
    XCTAssertEqual(activity.totalNumberOfComments, 1, @"Mapping of activity stream failed: incorrect number of comments");
    XCTAssertEqual(activity.totalNumberOfLikes, 4, @"Mapping of activity stream failed: incorrect number of likes");
    XCTAssertEqualObjects(activity.createdAt, @"Wed May 21 11:33:25 +0200 2014", @"Mapping of activity stream failed: incorrect creation date");
    
}

- (void)testActivityStreamBeforeActivity
{
    [httpHelper HTTPStubForActivityStream];
    [httpHelper logWhichStubsAreRegistered];
    
    SocialActivity *oldActivity = [socHelper createSocialActivity];
    
    [asProxy getActivitiesOfType:ActivityStreamProxyActivityTypeAllUpdates BeforeActivity:oldActivity];
    
    [self wait];
    
    NSArray *activities = asProxy.arrActivityStreams;
    
    XCTAssertEqual(activities.count, 1, @"Failed to get activity stream");
    
    SocialActivity *activity = [activities objectAtIndex:0];
    
    XCTAssertEqualObjects(activity.type, @"LINK_ACTIVITY", @"Mapping of activity stream failed: incorrect activity type");
    XCTAssertEqualObjects(activity.activityId, @"1e20cf09c06313bc0a9d372ecd6bd2a7", @"Mapping of activity stream failed: incorrect activity ID");
    XCTAssertEqualObjects(activity.title, @"Login", @"Mapping of activity stream failed: incorrect activity title");
    XCTAssertEqualObjects(activity.identityId, @"d3c28a300a2106c658573c3c030bf9da", @"Mapping of activity stream failed: incorrect identity ID");
    XCTAssertEqual(activity.postedTime, 1400664805123, @"Mapping of activity stream failed: incorrect posted time");
    XCTAssertEqual(activity.lastUpdated, 1400664805123, @"Mapping of activity stream failed: incorrect last updated time");
    XCTAssertTrue(activity.liked, @"Mapping of activity stream failed: activity is liked");
    XCTAssertEqualObjects(activity.createdAt, @"Wed May 21 11:33:25 +0200 2014", @"Mapping of activity stream failed: incorrect creation date");
}


@end
