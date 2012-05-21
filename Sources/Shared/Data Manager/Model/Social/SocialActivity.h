//
//  SocialActivity.h
//  eXo Platform
//
//  Created by exo on 5/21/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialUserProfile.h"
#import "SocialPictureAttach.h"

@interface SocialActivity : NSObject

@property (nonatomic, retain) NSString* identityId;
@property (nonatomic, retain) NSString* activityId;
@property (nonatomic, assign) int totalNumberOfComments;
@property (nonatomic, assign) int totalNumberOfLikes;
@property BOOL liked;
@property double postedTime;
@property CGFloat cellHeight;
@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSDictionary* activityStream;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* body;
@property (nonatomic, assign) int priority;
@property (nonatomic, retain) NSString* createdAt;
@property (nonatomic, retain) NSArray*  likedByIdentities;
@property (nonatomic, retain) NSString* titleId;
@property (nonatomic, retain) SocialUserProfile* posterIdentity;
@property (nonatomic, retain) SocialPictureAttach *posterPicture;
@property (nonatomic, retain) NSArray* comments;

@property (nonatomic, retain) NSString* postedTimeInWords;
@property (nonatomic, retain) NSDictionary* templateParams; 
@property int           activityType;

- (void)getActivityType;
- (void)convertToPostedTimeInWords;
- (void)convertHTMLEncoding;
- (void)setKeyForTemplateParams:(NSString*)key value:(NSString*)value;
- (void)cellHeightCalculationForWidth:(CGFloat)fWidth;

@end
