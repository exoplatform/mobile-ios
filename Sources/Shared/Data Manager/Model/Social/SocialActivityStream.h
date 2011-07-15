//
//  SocialActivityStream.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>


@interface SocialActivityStream : RKObject {
    NSString*               _identityId;
    NSString*               _totalNumberOfComments;
    NSString*               _liked;
    NSString*               _postedTime;
    NSString*               _type;
    NSString*               _posterIdentity;
    NSString*               _activityStream;
    NSString*               _identify;
    NSString*               _title;
    NSString*               _priority;
    NSString*               _createdAt;
    NSString*               _likedByIdentities;
    NSString*               _titleId;
    NSString*               _comments;
}

@property (nonatomic, retain) NSString* identityId;
@property (nonatomic, retain) NSString* totalNumberOfComments;
@property (nonatomic, retain) NSString* liked;
@property (nonatomic, retain) NSString* postedTime;
@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSString* posterIdentity;
@property (nonatomic, retain) NSString* activityStream;
@property (nonatomic, retain) NSString* identify;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* priority;
@property (nonatomic, retain) NSString* createdAt;
@property (nonatomic, retain) NSString* likedByIdentities;
@property (nonatomic, retain) NSString* titleId;
@property (nonatomic, retain) NSString* comments;

@end
