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
    
    
    XCTAssertEqualObjects(activity.postedTimeInWords.description, @"1 day ago", @"%@ should be: 1 day ago", activity.postedTimeInWords.description);
    XCTAssertEqualObjects(activity.updatedTimeInWords.description, @"About 2 hours ago", @"%@ should be: About 2 hours ago", activity.updatedTimeInWords.description);
}

- (void)testActivityTypesWiki
{
    SocialActivity *activity = [[SocialActivity alloc] init];
    activity.type = @"ks-wiki";
    activity.activityType = -1;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_WIKI_ADD_PAGE, @"Activity Type %d is incorrect", activity.activityType);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"update_page", @"act_key", nil];
    activity.templateParams = params;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_WIKI_MODIFY_PAGE, @"Activity Type %d is incorrect", activity.activityType);

    
}

- (void)testActivityTypesContent
{
    SocialActivity *activity = [[SocialActivity alloc] init];
    activity.type = @"contents:spaces";
    activity.activityType = -1;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_CONTENTS_SPACE, @"Activity Type %d is incorrect", activity.activityType);
    
    //
    
    activity.type = @"files:spaces";
    activity.activityType = -1;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_CONTENTS_SPACE, @"Activity Type %d is incorrect", activity.activityType);
    
}

- (void)testActivityTypesForum
{
    NSDictionary *params = nil;
    SocialActivity *activity = [[SocialActivity alloc] init];
    activity.type = @"ks-forum";
    activity.activityType = -1;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_FORUM_CREATE_TOPIC, @"Activity Type %d is incorrect", activity.activityType);
    
    params = [NSDictionary dictionaryWithObjectsAndKeys:@"UpdatePost", @"ActivityType", nil];
    activity.templateParams = params;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_FORUM_UPDATE_POST, @"Activity Type %d is incorrect", activity.activityType);
    
    params = [NSDictionary dictionaryWithObjectsAndKeys:@"AddPost", @"ActivityType", nil];
    activity.templateParams = params;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_FORUM_CREATE_POST, @"Activity Type %d is incorrect", activity.activityType);
    
    params = [NSDictionary dictionaryWithObjectsAndKeys:@"UpdateTopic", @"ActivityType", nil];
    activity.templateParams = params;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_FORUM_UPDATE_TOPIC, @"Activity Type %d is incorrect", activity.activityType);
    
}

- (void)testActivityTypesAnswer
{
    NSDictionary *params = nil;
    SocialActivity *activity = [[SocialActivity alloc] init];
    activity.type = @"ks-answer";
    activity.activityType = -1;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_ANSWER_ADD_QUESTION, @"Activity Type %d is incorrect", activity.activityType);
    
    params = [NSDictionary dictionaryWithObjectsAndKeys:@"QuestionUpdate", @"ActivityType", nil];
    activity.templateParams = params;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_ANSWER_UPDATE_QUESTION, @"Activity Type %d is incorrect", activity.activityType);
    
    params = [NSDictionary dictionaryWithObjectsAndKeys:@"AnswerAdd", @"ActivityType", nil];
    activity.templateParams = params;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_ANSWER_QUESTION, @"Activity Type %d is incorrect", activity.activityType);
    
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
    XCTAssertEqual(activity.activityType, ACTIVITY_CALENDAR_ADD_EVENT, @"Activity Type %d is incorrect", activity.activityType);
    
    params = [NSDictionary dictionaryWithObjectsAndKeys:@"EventUpdated", @"EventType", nil];
    activity.templateParams = params;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_CALENDAR_UPDATE_EVENT, @"Activity Type %d is incorrect", activity.activityType);
    
    params = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskAdded", @"EventType", nil];
    activity.templateParams = params;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_CALENDAR_ADD_TASK, @"Activity Type %d is incorrect", activity.activityType);
    
    params = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskUpdated", @"EventType", nil];
    activity.templateParams = params;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_CALENDAR_UPDATE_TASK, @"Activity Type %d is incorrect", activity.activityType);
    
}

- (void)testActivityTypesSocial
{
    SocialActivity *activity = [[SocialActivity alloc] init];
    activity.type = @"LINK_ACTIVITY";
    activity.activityType = -1;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_LINK, @"Activity Type %d is incorrect", activity.activityType);
    
    //
    
    activity.type = @"DOC_ACTIVITY";
    activity.activityType = -1;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_DOC, @"Activity Type %d is incorrect", activity.activityType);
    
}

- (void)testActivityTypesDefault
{
    SocialActivity *activity = [[SocialActivity alloc] init];
    activity.type = @"nothing";
    activity.activityType = -1;
    [activity getActivityType];
    XCTAssertEqual(activity.activityType, ACTIVITY_DEFAULT, @"Activity Type %d is incorrect", activity.activityType);
    
}

@end
