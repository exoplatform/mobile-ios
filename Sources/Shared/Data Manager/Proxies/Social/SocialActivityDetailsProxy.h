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

// Create like resource path
- (NSString *)createLikeResourcePath:(NSString *)activityId;
// Create comment resource path
- (NSString *)createCommentsResourcePath:(NSString *)activityId;

//Use this constructor when you want to set a particular value for the number of comment wanted
-(instancetype)initWithNumberOfComments:(int)nbComments andNumberOfLikes:(int)nbLikes;

// Get all likers of the activity
- (void)getLikers:(NSString *)activityId;
// Get all comments of the activity
- (void)getAllOfComments:(NSString *)activityId;


@end
