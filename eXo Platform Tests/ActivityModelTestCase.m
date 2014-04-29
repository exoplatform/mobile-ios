//
//  ActivityModelTestCase.m
//  eXo Platform
//
//  Created by exoplatform on 4/28/14.
//  Copyright (c) 2014 eXoPlatform. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SocialActivity.h"
#import "ActivityHelper.h"

@interface ActivityModelTestCase : XCTestCase

@end

@implementation ActivityModelTestCase

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)test_Activity_Time_Is_Converted_In_Words
{
    SocialActivity *activity = [[SocialActivity alloc] init];
    NSDate *yesterday = [[NSDate alloc]
                         initWithTimeIntervalSinceNow:-(24 * 60 * 60)];
    NSDate *twoHoursAgo = [[NSDate alloc]
                           initWithTimeIntervalSinceNow:-(2 * 60 * 60)];
    activity.postedTimeInWords = nil;
    activity.updatedTimeInWords = nil;
    activity.postedTime = round([yesterday timeIntervalSince1970])*1000;
    activity.lastUpdated = round([twoHoursAgo timeIntervalSince1970])*1000;
    
    [activity convertToPostedTimeInWords];
    [activity convertToUpdatedTimeInWords];
    
    
    XCTAssertEqualObjects(activity.postedTimeInWords.description, @"1 day ago", @"Should be: 1 day ago");
    XCTAssertEqualObjects(activity.updatedTimeInWords.description, @"About 2 hours ago", @"Should be: About 2 hours ago");
}

- (void)testActivityTypesWiki
{
    SocialActivity *activity = [[SocialActivity alloc] init];
    activity.type = @"ks-wiki";
    activity.activityType = -1;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_WIKI_ADD_PAGE, @"");
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"update_page", @"act_key", nil];
    activity.templateParams = params;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_WIKI_MODIFY_PAGE, @"");

    
}

- (void)testActivityTypesContent
{
    SocialActivity *activity = [[SocialActivity alloc] init];
    activity.type = @"contents:spaces";
    activity.activityType = -1;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_CONTENTS_SPACE, @"");
    
    //
    
    activity.type = @"files:spaces";
    activity.activityType = -1;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_CONTENTS_SPACE, @"");
    
}

- (void)testActivityTypesForum
{
    NSDictionary *params = nil;
    SocialActivity *activity = [[SocialActivity alloc] init];
    activity.type = @"ks-forum";
    activity.activityType = -1;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_FORUM_CREATE_TOPIC, @"");
    
    params = [NSDictionary dictionaryWithObjectsAndKeys:@"UpdatePost", @"ActivityType", nil];
    activity.templateParams = params;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_FORUM_UPDATE_POST, @"");
    
    params = [NSDictionary dictionaryWithObjectsAndKeys:@"AddPost", @"ActivityType", nil];
    activity.templateParams = params;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_FORUM_CREATE_POST, @"");
    
    params = [NSDictionary dictionaryWithObjectsAndKeys:@"UpdateTopic", @"ActivityType", nil];
    activity.templateParams = params;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_FORUM_UPDATE_TOPIC, @"");
    
}

- (void)testActivityTypesAnswer
{
    NSDictionary *params = nil;
    SocialActivity *activity = [[SocialActivity alloc] init];
    activity.type = @"ks-answer";
    activity.activityType = -1;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_ANSWER_ADD_QUESTION, @"");
    
    params = [NSDictionary dictionaryWithObjectsAndKeys:@"QuestionUpdate", @"ActivityType", nil];
    activity.templateParams = params;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_ANSWER_UPDATE_QUESTION, @"");
    
    params = [NSDictionary dictionaryWithObjectsAndKeys:@"AnswerAdd", @"ActivityType", nil];
    activity.templateParams = params;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_ANSWER_QUESTION, @"");
    
}

- (void)testActivityTypesCalendar
{
    SocialActivity *activity = [[SocialActivity alloc] init];
    activity.type = @"cs-calendar";
    activity.activityType = -1;
    NSDictionary *params = nil;
    
    params = [NSDictionary dictionaryWithObjectsAndKeys:@"EventAdded", @"EventType", nil];
    activity.templateParams = params;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_CALENDAR_ADD_EVENT, @"");
    
    params = [NSDictionary dictionaryWithObjectsAndKeys:@"EventUpdated", @"EventType", nil];
    activity.templateParams = params;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_CALENDAR_UPDATE_EVENT, @"");
    
    params = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskAdded", @"EventType", nil];
    activity.templateParams = params;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_CALENDAR_ADD_TASK, @"");
    
    params = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskUpdated", @"EventType", nil];
    activity.templateParams = params;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_CALENDAR_UPDATE_TASK, @"");
    
}

- (void)testActivityTypesSocial
{
    SocialActivity *activity = [[SocialActivity alloc] init];
    activity.type = @"LINK_ACTIVITY";
    activity.activityType = -1;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_LINK, @"");
    
    //
    
    activity.type = @"DOC_ACTIVITY";
    activity.activityType = -1;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_DOC, @"");
    
}

- (void)testActivityTypesDefault
{
    SocialActivity *activity = [[SocialActivity alloc] init];
    activity.type = @"nothing";
    activity.activityType = -1;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_DEFAULT, @"");
    
}

@end
