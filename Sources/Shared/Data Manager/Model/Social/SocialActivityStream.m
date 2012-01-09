//
//  SocialActivityStream.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialActivityStream.h"
#import "NSDate+Formatting.h"
#import "GTMNSString+HTML.h"
#import "ActivityHelper.h"

@implementation SocialActivityStream

@synthesize identityId = _identityId;
@synthesize totalNumberOfComments = _totalNumberOfComments;
@synthesize totalNumberOfLikes = _totalNumberOfLikes;
@synthesize liked = _liked;
@synthesize postedTime = _postedTime;
@synthesize type = _type;
@synthesize activityType = _activityType;
@synthesize posterIdentity = _posterIdentity;
@synthesize activityId = _activityId;
@synthesize title = _title;
@synthesize body = _body;
@synthesize createdAt = _createdAt;
@synthesize likedByIdentities = _likedByIdentities;
@synthesize titleId = _titleId;
@synthesize comments = _comments;
@synthesize postedTimeInWords = _postedTimeInWords;
@synthesize posterUserProfile = _posterUserProfile;
@synthesize posterPicture = _posterPicture;
@synthesize templateParams = _templateParams;
@synthesize activityStream = _activityStream;
@synthesize cellHeight = _cellHeight;
 
- (void)dealloc {
    [_identityId release];
    [_type release];
    [_posterIdentity release];
    [_activityId release];
    [_title release];
    [_body release];
    [_createdAt release];
    [_likedByIdentities release];
    [_titleId release];
    [_comments release];
    [_postedTimeInWords release];
    [_posterUserProfile release];
    [_posterPicture release];
    [_templateParams release];
    [_activityStream release];
    [super dealloc];
}

- (void)convertToPostedTimeInWords
{    
    self.postedTimeInWords = [[NSDate date] distanceOfTimeInWordsWithTimeInterval:self.postedTime];
}

- (NSString*)fixupTextForStyledTextLabel:(NSString*)text { 
    text = [text stringByReplacingOccurrencesOfString:@"&eacute;" withString:@"&amp;"];
    return text; 
} 

-(void)convertHTMLEncoding 
{
    self.title = [self.title gtm_stringByUnescapingFromHTML];

    self.posterPicture.message = [self.posterPicture.message gtm_stringByUnescapingFromHTML];
}    

-(void)getActivityType {
    if([_type rangeOfString:@"ks-wiki"].length > 0){
        if([[_templateParams valueForKey:@"act_key"] isEqualToString:@"add_page"]){
            _activityType = ACTIVITY_WIKI_ADD_PAGE;
        } else if([[_templateParams valueForKey:@"act_key"] isEqualToString:@"update_page"]){
            _activityType = ACTIVITY_WIKI_MODIFY_PAGE;
        }
    }else if([_type rangeOfString:@"LINK_ACTIVITY"].length > 0){
        _activityType = ACTIVITY_LINK;
    }else if([_type rangeOfString:@"DOC_ACTIVITY"].length > 0){
        _activityType = ACTIVITY_DOC;
    }else if([_type rangeOfString:@"contents:spaces"].length > 0){
        _activityType = ACTIVITY_CONTENTS_SPACE;
    }else if([_type rangeOfString:@"ks-forum"].length > 0){
        if([[_templateParams valueForKey:@"ActivityType"] isEqualToString:@"AddTopic"]){
            _activityType = ACTIVITY_FORUM_CREATE_TOPIC;
        } else if([[_templateParams valueForKey:@"ActivityType"] isEqualToString:@"UpdatePost"]){
            _activityType = ACTIVITY_FORUM_UPDATE_POST;
        }else if([[_templateParams valueForKey:@"ActivityType"] isEqualToString:@"AddPost"]){
            _activityType = ACTIVITY_FORUM_CREATE_POST;
        }else if([[_templateParams valueForKey:@"ActivityType"] isEqualToString:@"UpdateTopic"]){
            _activityType = ACTIVITY_FORUM_UPDATE_TOPIC;
        }//
    }else if([_type rangeOfString:@"ks-answer"].length > 0){//
        if([[_templateParams valueForKey:@"ActivityType"] isEqualToString:@"QuestionAdd"]){
            _activityType = ACTIVITY_ANSWER_ADD_QUESTION;
        } else if([[_templateParams valueForKey:@"ActivityType"] isEqualToString:@"QuestionUpdate"]){
            _activityType = ACTIVITY_ANSWER_UPDATE_QUESTION;
        }else if([[_templateParams valueForKey:@"ActivityType"] isEqualToString:@"AnswerAdd"]){
            _activityType = ACTIVITY_ANSWER_QUESTION;
        }//
    }else if([_type rangeOfString:@"cs-calendar"].length > 0){//
        if([[_templateParams valueForKey:@"EventType"] isEqualToString:@"EventAdded"]){
            _activityType = ACTIVITY_CALENDAR_ADD_EVENT;
        } else if([[_templateParams valueForKey:@"EventType"] isEqualToString:@"EventUpdated"]){
            _activityType = ACTIVITY_CALENDAR_UPDATE_EVENT;
        }else if([[_templateParams valueForKey:@"EventType"] isEqualToString:@"TaskAdded"]){
            _activityType = ACTIVITY_CALENDAR_ADD_TASK;
        }else if([[_templateParams valueForKey:@"EventType"] isEqualToString:@"TaskUpdated"]){
            _activityType = ACTIVITY_CALENDAR_UPDATE_TASK;
        }
    }else {
        _activityType = ACTIVITY_DEFAULT;
    }
}



- (void)cellHeightCalculationForWidth:(CGFloat)fWidth {

    _cellHeight = [ActivityHelper getHeightForActivityCell:self forTableViewWidth:fWidth];
    
}

@end
