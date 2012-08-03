//
//  SocialActivity.m
//  eXo Platform
//
//  Created by Le Thanh Quang on 5/21/12.
//  Copyright (c) 2012 eXo Platform. All rights reserved.
//

#import "SocialActivity.h"
#import "NSDate+Formatting.h"
#import "GTMNSString+HTML.h"
#import "ActivityHelper.h"

@implementation SocialActivity

@synthesize identityId = _identityId;
@synthesize activityId = _activityId;
@synthesize totalNumberOfLikes = _totalNumberOfLikes;
@synthesize totalNumberOfComments = _totalNumberOfComments;
@synthesize liked = _liked;
@synthesize postedTime = _postedTime;
@synthesize cellHeight = _cellHeight;
@synthesize type = _type;
@synthesize activityStream = _activityStream;
@synthesize title = _title;
@synthesize body = _body;
@synthesize priority = _priority;
@synthesize createdAt = _createdAt;
@synthesize likedByIdentities = _likedByIdentities;
@synthesize titleId = _titleId;
@synthesize posterIdentity = _posterIdentity;
@synthesize posterPicture = _posterPicture;
@synthesize comments = _comments;
@synthesize postedTimeInWords = _postedTimeInWords;
@synthesize templateParams = _templateParams;
@synthesize activityType = _activityType;

- (void)dealloc {
    [_identityId release];
    [_activityId release];
    [_type release];
    [_activityStream release];
    [_title release];
    [_body release];
    [_createdAt release];
    [_likedByIdentities release];
    [_titleId release];
    [_posterIdentity release];
    [_posterPicture release];
    [_comments release];
    [_postedTimeInWords release];
    [_templateParams release];
    [super dealloc];
}

- (void)getActivityType {
    if ([_type rangeOfString:@"ks-wiki"].length > 0) {
        if ([[_templateParams valueForKey:@"act_key"] isEqualToString:@"add_page"]) {
            _activityType = ACTIVITY_WIKI_ADD_PAGE;
        } else if ([[_templateParams valueForKey:@"act_key"] isEqualToString:@"update_page"]) {
            _activityType = ACTIVITY_WIKI_MODIFY_PAGE;
        }
    } else if ([_type rangeOfString:@"LINK_ACTIVITY"].length > 0) {
        _activityType = ACTIVITY_LINK;
    } else if ([_type rangeOfString:@"DOC_ACTIVITY"].length > 0) {
        _activityType = ACTIVITY_DOC;
    } else if ([_type rangeOfString:@"contents:spaces"].length > 0) {
        _activityType = ACTIVITY_CONTENTS_SPACE;
    } else if ([_type rangeOfString:@"ks-forum"].length > 0) {
        if ([[_templateParams valueForKey:@"ActivityType"] isEqualToString:@"AddTopic"]) {
            _activityType = ACTIVITY_FORUM_CREATE_TOPIC;
        } else if ([[_templateParams valueForKey:@"ActivityType"] isEqualToString:@"UpdatePost"]) {
            _activityType = ACTIVITY_FORUM_UPDATE_POST;
        } else if ([[_templateParams valueForKey:@"ActivityType"] isEqualToString:@"AddPost"]) {
            _activityType = ACTIVITY_FORUM_CREATE_POST;
        } else if ([[_templateParams valueForKey:@"ActivityType"] isEqualToString:@"UpdateTopic"]) {
            _activityType = ACTIVITY_FORUM_UPDATE_TOPIC;
        }//
    } else if ([_type rangeOfString:@"ks-answer"].length > 0) {//
        if ([[_templateParams valueForKey:@"ActivityType"] isEqualToString:@"QuestionAdd"]) {
            _activityType = ACTIVITY_ANSWER_ADD_QUESTION;
        } else if ([[_templateParams valueForKey:@"ActivityType"] isEqualToString:@"QuestionUpdate"]) {
            _activityType = ACTIVITY_ANSWER_UPDATE_QUESTION;
        } else if ([[_templateParams valueForKey:@"ActivityType"] isEqualToString:@"AnswerAdd"]) {
            _activityType = ACTIVITY_ANSWER_QUESTION;
        }//
    } else if ([_type rangeOfString:@"cs-calendar"].length > 0) {//
        if ([[_templateParams valueForKey:@"EventType"] isEqualToString:@"EventAdded"]) {
            _activityType = ACTIVITY_CALENDAR_ADD_EVENT;
        } else if ([[_templateParams valueForKey:@"EventType"] isEqualToString:@"EventUpdated"]) {
            _activityType = ACTIVITY_CALENDAR_UPDATE_EVENT;
        } else if ([[_templateParams valueForKey:@"EventType"] isEqualToString:@"TaskAdded"]) {
            _activityType = ACTIVITY_CALENDAR_ADD_TASK;
        } else if ([[_templateParams valueForKey:@"EventType"] isEqualToString:@"TaskUpdated"]) {
            _activityType = ACTIVITY_CALENDAR_UPDATE_TASK;
        }
    } else {
        _activityType = ACTIVITY_DEFAULT;
    }
    
}

- (void)convertToPostedTimeInWords {
   self.postedTimeInWords = [[NSDate dateWithTimeIntervalSince1970:self.postedTime/1000] distanceOfTimeInWords:[NSDate date]]; 
}

- (void)convertHTMLEncoding {
    self.title = [self.title gtm_stringByUnescapingFromHTML];
    self.posterPicture.message = [self.posterPicture.message gtm_stringByUnescapingFromHTML];
}

- (void)cellHeightCalculationForWidth:(CGFloat)fWidth {
    _cellHeight = [ActivityHelper getHeightForActivityCell:self forTableViewWidth:fWidth];
}

- (void)setKeyForTemplateParams:(NSString *)key value:(NSString *)value {
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self.templateParams];
    [tempDic setValue:value forKey:key];
    self.templateParams = [NSDictionary dictionaryWithDictionary:tempDic];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[title : %@], [body : %@], [identityId : %@], [comment : %@]", self.title, self.body, self.identityId, self.comments];
}

@end
