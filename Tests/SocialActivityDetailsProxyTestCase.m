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
#import "SocialActivityDetailsProxy.h"
#import "SocialComment.h"
#import "HTTPStubsHelper.h"
#import "SocialTestsHelper.h"

@interface SocialActivityDetailsProxyTestCase : AsyncProxyTestCase<SocialProxyDelegate> {
    SocialActivityDetailsProxy *adProxy;
    SocialActivity *activity;
    HTTPStubsHelper *httpHelper;
    SocialTestsHelper *socHelper;
}

@end

@implementation SocialActivityDetailsProxyTestCase

- (void)setUp
{
    [super setUp];
    socHelper = [SocialTestsHelper getInstance];
    adProxy = [[SocialActivityDetailsProxy alloc] initWithNumberOfComments:4 andNumberOfLikes:7];
    adProxy.delegate = self;
    activity = [socHelper createSocialActivity];
    [socHelper createSocialRestConfiguration];
    httpHelper = [HTTPStubsHelper getInstance];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}


- (void)testLikeActivityResourcePath
{
    NSString *path = [adProxy createLikeResourcePath:activity.activityId];
    NSString *expectedPath = @"private/api/social/v1-alpha3/portal/activity/1e20cf09c06313bc0a9d372ecd6bd2a7/likes.json";
    
    XCTAssertEqualObjects(path, expectedPath, @"Path to like activity is not correct");
}

- (void)testCommentActivityResourcePath
{
    NSString *path = [adProxy createCommentsResourcePath:activity.activityId];
    NSString *expectedPath = @"private/api/social/v1-alpha3/portal/activity/1e20cf09c06313bc0a9d372ecd6bd2a7/comments.json";
    
    XCTAssertEqualObjects(path, expectedPath, @"Path to comment activity is not correct");
}

- (void)testGetActivityDetails
{
    [httpHelper HTTPStubForActivityDetails];
    [httpHelper logWhichStubsAreRegistered];
    
    [adProxy getActivityDetail:activity.activityId];
    
    [self wait];
    
    SocialActivity *activityDetails = adProxy.socialActivityDetails;
    
    XCTAssertNotNil(activityDetails, @"Social Activity Details object should have been created");
    XCTAssertEqualObjects(activityDetails.activityId, activity.activityId, @"Mapping of activity details failed: incorrect activity ID");
    XCTAssertEqualObjects(activityDetails.title, @"Login", @"Mapping of activity details failed: incorrect title");
    XCTAssertEqualObjects(activityDetails.type, @"LINK_ACTIVITY", @"Mapping of activity details failed: incorrect activity type");
    XCTAssertEqualObjects(activityDetails.body, @"", @"Mapping of activity details failed: incorrect body");
    XCTAssertEqualObjects(activityDetails.createdAt, @"Wed May 21 11:33:25 +0200 2014", @"Mapping of activity details failed: incorrect activity creation date");
    XCTAssertEqual(activityDetails.postedTime, 1400664805123, @"Mapping of activity details failed: incorrect posted time");
    XCTAssertEqual(activityDetails.totalNumberOfComments, 4, @"Mapping of activity details failed: incorrect number of comments");
    XCTAssertEqual(activityDetails.totalNumberOfLikes, 7, @"Mapping of activity details failed: incorrect number of likes");
    XCTAssertTrue(activityDetails.liked, @"Mapping of activity details failed: activity is liked");
}

- (void)testGetActivityLikes
{
    [httpHelper HTTPStubForActivityLikes];
    [httpHelper logWhichStubsAreRegistered];
    
    [adProxy getLikers:activity.activityId];
    
    [self wait];
    
    XCTAssertNotNil(adProxy.socialActivityDetails, @"Social Activity Details object should have been created");
    XCTAssertEqual(adProxy.socialActivityDetails.totalNumberOfLikes, 7, @"There should have been 7 likes");
    NSArray *likers = adProxy.socialActivityDetails.likedByIdentities;
    XCTAssertEqual([likers count], 7, @"Array of likers should contain 7 elements");
    
    NSArray *likersProfiles = [NSArray arrayWithObjects:
        [socHelper createSocialUserProfileWithID:@"4fece28a0a2106c63ce09784543ce781" username:@"john_smith" fullname:@"John Smith"],
        [socHelper createSocialUserProfileWithID:@"51998d9b0a2106c60330eb14726dc376" username:@"mary_williams" fullname:@"Mary Williams"],
        [socHelper createSocialUserProfileWithID:@"50d5e1250a2106c6693ac5a1f2978328" username:@"johndoe" fullname:@"John Doe"],
        [socHelper createSocialUserProfileWithID:@"07358dc80a20d9903523c3bbc6ea321d" username:@"jdaniels" fullname:@"Jack Daniels"],
        [socHelper createSocialUserProfileWithID:@"d4ddb0ecc06313bc5d57b7d699a1daa0" username:@"paulo" fullname:@"Paul Oneill"],
        [socHelper createSocialUserProfileWithID:@"4589aee8c0a803245a4d44f53df4b19b" username:@"tungnguyen" fullname:@"Tung Nguyen"],
        [socHelper createSocialUserProfileWithID:@"51aa8e300a2106c6717816abbfdab170" username:@"joed" fullname:@"Joe Dalton"],
                               nil];
    
    int i=0;
    for (SocialUserProfile *liker in likers) {
        SocialUserProfile *profile = [likersProfiles objectAtIndex:i];
        XCTAssertEqualObjects(liker.identity, profile.identity, @"Liker identity does not match");
        XCTAssertEqualObjects(liker.remoteId, profile.remoteId, @"Liker username does not match");
        XCTAssertEqualObjects(liker.fullName, profile.fullName, @"Liker full name does not match");
        i++;
    }
}

- (void)testGetActivityComments
{
    [httpHelper HTTPStubForActivityComments];
    [httpHelper logWhichStubsAreRegistered];
    
    [adProxy getAllOfComments:activity.activityId];
    
    [self wait];
    
    XCTAssertNotNil(adProxy.socialActivityDetails, @"Social Activity Details object should have been created");
    XCTAssertEqual(adProxy.socialActivityDetails.totalNumberOfComments, 4, @"There should have been 4 comments");
    NSArray *comments = adProxy.socialActivityDetails.comments;
    XCTAssertEqual([comments count], 4, @"Array of comments should contain 4 elements");
    
    NSArray *commentsObj = [NSArray arrayWithObjects:
                    [socHelper createCommentWithID:@"e5efc8c0c06313bc4a27bbe61bfabf8f" text:@"Look Ma, an apple!"],
                    [socHelper createCommentWithID:@"ed041476c06313bc737a212a6930e917" text:@"I'm walking on sunshine"],
                    [socHelper createCommentWithID:@"03deea81c06313bc2dd5d10dcfe1ef92" text:@"Fly me to the moon"],
                    [socHelper createCommentWithID:@"03df01c3c06313bc1f93a805a1ecc48b" text:@"Lorem ipsum dolor"],
                            nil];
    int i=0;
    for (SocialComment *comment in comments) {
        SocialComment *comm = [commentsObj objectAtIndex:i];
        XCTAssertEqualObjects(comment.identityId, comm.identityId, @"Comment ID does not match");
        XCTAssertEqualObjects(comment.text, comm.text, @"Comment text does not match");
        i++;
    }
}

@end
