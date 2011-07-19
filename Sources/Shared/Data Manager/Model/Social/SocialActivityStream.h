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
    int                     _totalNumberOfComments;
    BOOL                    _liked;
    double                  _postedTime;
    NSString*               _type;
    NSString*               _posterIdentity;
    NSString*               _activityStream;
    NSString*               _identify;
    NSString*               _title;
    NSString*               _priority;
    NSString*               _createdAt;
    NSArray*                _likedByIdentities;
    NSString*               _titleId;
    //NSString*               _comments;
    NSArray*               _comments;
}

@property (nonatomic, retain) NSString* identityId;
@property int totalNumberOfComments;
@property BOOL liked;
@property double postedTime;
@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSString* posterIdentity;
@property (nonatomic, retain) NSString* activityStream;
@property (nonatomic, retain) NSString* identify;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* priority;
@property (nonatomic, retain) NSString* createdAt;
@property (nonatomic, retain) NSArray* likedByIdentities;
@property (nonatomic, retain) NSString* titleId;
//@property (nonatomic, retain) NSString* comments;
@property (nonatomic, retain) NSArray* comments;

@end
