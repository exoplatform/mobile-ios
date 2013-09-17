//
//  LoginProxy.h
//  eXo Platform
//
//  Created by Le Thanh Quang on 26/07/11.
//  Copyright 2011 eXo Platform. All rights reserved.
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
-(id)initWithDelegate:(id<LoginProxyDelegate>)delegate;
- (void)retrievePlatformInformations; // get public platform infos to fill in settings view when user is not signed in
- (void)getPlatformInfoAfterAuthenticate; //get private infos after authenticating and then switch to activity stream
- (void)authenticate;
- (id)initWithDelegate:(id<LoginProxyDelegate>)delegate username:(NSString *)username password:(NSString *)password;
- (id)initWithDelegate:(id<LoginProxyDelegate>)delegate username:(NSString *)username password:(NSString *)password serverUrl:(NSString *)serverUrl;
@end

@class LoginProxy;
@protocol LoginProxyDelegate<NSObject>
- (void)loginProxy:(LoginProxy *)proxy platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion;
- (void)loginProxy:(LoginProxy *)proxy authenticateFailedWithError:(NSError *)error;
@end