//
//  eXoUserClient.h
//  eXoApp
//
//  Created by Tran Hoai Son on 5/8/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "defines.h"
#import "httpClient.h"
#import "eXoUser.h"

@class eXoUserClient;

@protocol eXoUserClientDelegate
- (void)eXoUserClientSucceeded:(eXoUserClient*)sender;
- (void)eXoUserClientFailed:(eXoUserClient*)sender;
@end

@interface eXoUserClient : httpClient {
	@private
	NSObject<eXoUserClientDelegate>*	_delegate;
	eXoUser*							_user;
	UIImage*							_imgGadgetIcon;
}

+ (id)instance;
+ (id)newInstance;

- (id)initWithDelegate:(NSObject<eXoUserClientDelegate>*)delegate;
- (void)getUserInfoForScreenName:(NSString*)screenName;
- (void)getUserInfoForUserId:(NSString*)userId;
- (void)getGadgets:(NSString*)url;
//- (BOOL)signInWithUserName:(NSString*)userName password:(NSString*)password;
//- (NSString*)signInWithUserName:(NSString*)userName password:(NSString*)password;
- (NSString*)signInDomain:(NSString*)domain withUserName:(NSString*)userName password:(NSString*)password;
- (void)getExoOpenSocialActivitiesStream;


@property (readonly) eXoUser*	_user;
@property (readonly) UIImage*	_imgGadgetIcon;

@end
