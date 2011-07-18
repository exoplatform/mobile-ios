//
//  SocialComment.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 15/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "SocialIdentity.h"

/*
 {
 "text": "ouais un comment",
 "identityId": "e4f574dec0a80126368b5c3e4cc727b4",
 "createdAt": "Fri Jul 15 14:48:18 +0200 2011",
 "postedTime": 1310734098154
 }
 */

@interface SocialComment : RKObject {
   
    NSString*           _text;
    SocialIdentity*     _identityId;
    NSString*           _createdAt;
    NSNumber*           _postedTime;
    
}

@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) SocialIdentity* identityId;
@property (nonatomic, retain) NSString* createdAt;
@property (nonatomic, retain) NSNumber* postedTime;

@end
