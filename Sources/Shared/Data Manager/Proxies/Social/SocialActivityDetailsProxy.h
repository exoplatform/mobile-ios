//
//  SocialActivityDetailsProxy.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 15/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "SocialProxy.h"

@class SocialActivity;

@interface SocialActivityDetailsProxy : SocialProxy {
    
    NSString*   _activityIdentity;
    int         _numberOfComments;
    int         _numberOfLikes;
    BOOL        _posterIdentity;
    BOOL        _activityStream;
    
    SocialActivity*      _socialActivityDetails;
}

@property (nonatomic, retain) NSString* activityIdentity;
@property int numberOfComments;
@property int numberOfLikes;
@property BOOL posterIdentity;
@property BOOL activityStream;
@property (nonatomic, retain) SocialActivity *socialActivityDetails;

// helper methods
- (NSString *)createLikeResourcePath:(NSString *)activityId;

//Use this constructor when you want to set a particular value for the number of comment wanted
-(id)initWithNumberOfComments:(int)nbComments andNumberOfLikes:(int)nbLikes;

// Retrieve Activity details for a given identity
- (void)getActivityDetail:(NSString *)activityId;
// Get all of likers 
- (void)getLikers:(NSString *)activityId;


@end
