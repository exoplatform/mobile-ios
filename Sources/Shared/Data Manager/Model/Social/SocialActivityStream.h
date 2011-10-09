//
//  SocialActivityStream.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialUserProfile.h"

@interface SocialActivityStream : NSObject {
    NSString*               _identityId;
    int                     _totalNumberOfComments;
    int                     _totalNumberOfLikes;
    BOOL                    _liked;
    double                  _postedTime;
    NSString*               _type;
    NSString*               _posterIdentity;
    SocialUserProfile*      _posterUserProfile;
    NSString*               _activityId;
    NSString*               _title;
    NSString*               _createdAt;
    NSArray*                _likedByIdentities;
    NSString*               _titleId;
    NSArray*                _comments;    
    NSString*               _postedTimeInWords;
}

@property (nonatomic, retain) NSString* identityId;
@property int totalNumberOfComments;
@property int totalNumberOfLikes;
@property BOOL liked;
@property double postedTime;
@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSString* posterIdentity;
@property (nonatomic, retain) NSString* activityId;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* createdAt;
@property (nonatomic, retain) NSArray* likedByIdentities;
@property (nonatomic, retain) NSString* titleId;
@property (nonatomic, retain) NSArray* comments;
@property (nonatomic, retain) NSString* postedTimeInWords;
@property (nonatomic, retain) SocialUserProfile* posterUserProfile;

- (void)convertToPostedTimeInWords;
@end
