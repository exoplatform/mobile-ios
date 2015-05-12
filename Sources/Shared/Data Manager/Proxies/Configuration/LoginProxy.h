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
#import "PlatformServerVersion.h"
#import "SocialRestConfiguration.h"

@protocol LoginProxyDelegate;


@interface LoginProxy : NSObject<RKObjectLoaderDelegate, NSURLConnectionDataDelegate> {
        
    id<LoginProxyDelegate> _delegate;
}

@property (nonatomic, assign) id<LoginProxyDelegate> delegate;
@property (nonatomic, retain) NSString *serverUrl;

+ (void)doLogout;
-(instancetype)initWithDelegate:(id<LoginProxyDelegate>)delegate;
- (void)retrievePlatformInformations; // get public platform infos to fill in settings view when user is not signed in
- (void)getPlatformInfoAfterAuthenticate; //get private infos after authenticating and then switch to activity stream
- (void)authenticate;
- (instancetype)initWithDelegate:(id<LoginProxyDelegate>)delegate username:(NSString *)username password:(NSString *)password;
- (instancetype)initWithDelegate:(id<LoginProxyDelegate>)delegate username:(NSString *)username password:(NSString *)password serverUrl:(NSString *)serverUrl;
@end

@class LoginProxy;
@protocol LoginProxyDelegate<NSObject>
- (void)loginProxy:(LoginProxy *)proxy platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion;
- (void)loginProxy:(LoginProxy *)proxy authenticateFailedWithError:(NSError *)error;
@end

@interface LoginProxyAlert : NSObject
+ (UIAlertView*) alertWithError:(NSError*)error andDelegate:(id)delegate;
@end
