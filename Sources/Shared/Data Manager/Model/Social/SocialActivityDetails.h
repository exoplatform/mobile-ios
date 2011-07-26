//
//  SocialActivityDetails.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 15/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialUserProfile.h"
#import "SocialIdentity.h"
#import "SocialComment.h"

/*
 {
 "appId": null,
 "identityId": "e4f574dec0a80126368b5c3e4cc727b4",
 "totalNumberOfComments": 1,
 "liked": false,
 "templateParams": {},
 "postedTime": 1310716061540,
 "type": "DEFAULT_ACTIVITY",
 "posterIdentity": null,
 "activityStream": null,
 "id": "2cc3e76dc0a80126036313166ead0ad2",
 "title": "youhou",
 "priority": null,
 "createdAt": "Fri Jul 15 09:47:41 +0200 2011",
 "likedByIdentities": null,
 "titleId": null,
 "comments": [
 {
 "text": "ouais un comment",
 "identityId": "e4f574dec0a80126368b5c3e4cc727b4",
 "createdAt": "Fri Jul 15 14:48:18 +0200 2011",
 "postedTime": 1310734098154
 }
 ]
 }*/


@interface SocialActivityDetails : NSObject {
    NSString*               _identityId;
    NSNumber*               _totalNumberOfComments;
    NSString*               _liked;
    double                  _postedTime;
    NSString*               _type;
    NSString*               _activityStream;
    NSString*               _identifyId;
    NSString*               _title;
    NSNumber*               _priority;
    NSString*               _createdAt;
    NSArray*                _likedByIdentities;
    NSString*               _titleId;
    SocialUserProfile*      _posterIdentity;
    NSArray*                _comments;
    
    NSString*               _postedTimeInWords;
}

@property (nonatomic, retain) NSString* identityId;
@property (nonatomic, retain) NSNumber* totalNumberOfComments;
@property (nonatomic, retain) NSString* liked;
@property double postedTime;
@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSString* activityStream;
@property (nonatomic, retain) NSString* identifyId;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSNumber* priority;
@property (nonatomic, retain) NSString* createdAt;
@property (nonatomic, retain) NSArray*  likedByIdentities;
@property (nonatomic, retain) NSString* titleId;
@property (nonatomic, retain) SocialUserProfile* posterIdentity;
@property (nonatomic, retain) NSArray* comments;

@property (nonatomic, retain) NSString* postedTimeInWords;

- (void)convertToPostedTimeInWords;

@end
