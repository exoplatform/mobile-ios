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
#import "SocialUserProfile.h"
#import "SocialActivity.h"

typedef NS_ENUM(NSInteger, ActivityStreamProxyActivityType) {
  ActivityStreamProxyActivityTypeAllUpdates = 0,
  ActivityStreamProxyActivityTypeMyConnections, 
  ActivityStreamProxyActivityTypeMySpaces,
  ActivityStreamProxyActivityTypeMyStatus
} ;

@class SocialUserProfileProxy;

@interface SocialActivityStreamProxy : SocialProxy {
    
    NSArray*                    _arrActivityStreams;
    
    BOOL                        _isUpdateRequest;
}

@property (nonatomic, retain) NSArray* arrActivityStreams;
@property (readonly) BOOL isUpdateRequest;
@property (nonatomic, retain) SocialUserProfile *userProfile;

- (void)getActivitiesOfType:(ActivityStreamProxyActivityType)activitytype BeforeActivity:(SocialActivity*)activity;
- (void)getActivityStreams:(ActivityStreamProxyActivityType)activitytype;
- (NSString *)createPathForType:(ActivityStreamProxyActivityType)activityType;

@end


