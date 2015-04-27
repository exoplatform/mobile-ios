//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import <Foundation/Foundation.h>
#import "SocialUserProfile.h"
#import "SocialPictureAttach.h"
#import "defines.h"
@interface SocialActivity : NSObject

@property (nonatomic, retain) NSString* identityId;
@property (nonatomic, retain) NSString* activityId;
@property (nonatomic, assign) int totalNumberOfComments;
@property (nonatomic, assign) int totalNumberOfLikes;
@property BOOL liked;
@property double postedTime;
@property double lastUpdated;
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
@property (nonatomic, retain) NSString* updatedTimeInWords;
@property (nonatomic, retain) NSAttributedString* attributedMessage;
@property (nonatomic, retain) NSDictionary* templateParams; 
@property int           activityType;

- (void)getActivityType;
- (void)convertToPostedTimeInWords;
- (void)convertHTMLEncoding;
/*
 In the case of Activity type link: a bloc HTML contains all the status message & the links (in <a href ..> tag. We need to convert this HTML to an attributedString to be able to display without using a Web View.
 */
- (void)convertToAttributedMessage;
- (void)setKeyForTemplateParams:(NSString*)key value:(NSString*)value;
- (void)cellHeightCalculationForWidth:(CGFloat)fWidth;
- (void)convertToUpdatedTimeInWords;

@end
