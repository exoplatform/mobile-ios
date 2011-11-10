//
//  ActivityHelper.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialActivityStream.h"


#define ACTIVITY_DEFAULT 0
#define ACTIVITY_FORUM_CREATE_TOPIC 1
#define ACTIVITY_FORUM_CREATE_POST 2
#define ACTIVITY_FORUM_UPDATE_POST 3
#define ACTIVITY_FORUM_UPDATE_TOPIC 4

#define ACTIVITY_WIKI_ADD_PAGE 5
#define ACTIVITY_WIKI_MODIFY_PAGE 6

#define ACTIVITY_LINK 7
#define ACTIVITY_DOC 8

#define ACTIVITY_EXOSOCIAL_RELATIONSHIP 9
#define ACTIVITY_EXOSOCIAL_PEOPLE 10
#define ACTIVITY_EXOSOCIAL_SPACE 11

#define ACTIVITY_CONTENTS_SPACE 12


#define ACTIVITY_ANSWER_ADD_QUESTION 13
#define ACTIVITY_ANSWER_UPDATE_QUESTION 14
#define ACTIVITY_ANSWER_QUESTION  15

@interface ActivityHelper : NSObject {
    
}

+ (CGFloat)getHeightForActivityCell:(SocialActivityStream *)activtyStream forTableViewWidth:(CGFloat)fWidth;
+ (float)getHeightSizeForText:(NSString*)text andTableViewWidth:(CGFloat)fWidth;
+ (float)heightForAllDecorationsWithTableViewWidth:(CGFloat)fWidth;

@end