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
#import "SocialUserProfile.h"

/*
 {
 "text": "ouais un comment",
 "identityId": "e4f574dec0a80126368b5c3e4cc727b4",
 "createdAt": "Fri Jul 15 14:48:18 +0200 2011",
 "postedTime": 1310734098154
 }
 */

@interface SocialComment : NSObject{
    
    NSString*           _text;
    NSString*           _identityId;
    NSString*           _createdAt;
    double              _postedTime;
    NSString*           _postedTimeInWords;
    
    SocialUserProfile*  _userProfile;
    NSDictionary *_userDict;
}

@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSString* identityId;
@property (nonatomic, retain) NSString* createdAt;
@property double postedTime;
@property (nonatomic, retain) NSString* postedTimeInWords;
@property (nonatomic, retain) SocialUserProfile* userProfile;
@property (nonatomic, retain) NSDictionary *userDict;

- (void)convertToPostedTimeInWords;
- (void)convertHTMLEncoding;


@end
