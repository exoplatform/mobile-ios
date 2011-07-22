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

@class SocialActivityDetails;

@interface SocialActivityDetailsProxy : SocialProxy <RKObjectLoaderDelegate> {
    
    NSString*   _activityIdentity;
    int         _numberOfComments;
    BOOL        _posterIdentity;
    BOOL        _activityStream;
    
    SocialActivityDetails*      _socialActivityDetails;
}

@property (nonatomic, retain) NSString* activityIdentity;
@property int numberOfComments;
@property BOOL posterIdentity;
@property BOOL activityStream;
@property (nonatomic, retain) SocialActivityDetails* socialActivityDetails;


//Use this constructor when you want to set a particular value for the number of comment wanted
-(id)initWithNumberOfComments:(int)nbComments;

//Retrieve Activity details for a given identity
- (void)getActivityDetail:(NSString *)activityId;




@end
