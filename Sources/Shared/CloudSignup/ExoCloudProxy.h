//
//  ExoCloudProxy.h
//  eXo Platform
//
//  Created by vietnq on 6/17/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    EMAIL_SENT = 1,
    ACCOUNT_CREATED,
    NUMBER_OF_USERS_EXCEED,
    TENANT_SUSPENDED,
    EMAIL_BLACKLISTED
} CloudResponse;

@interface ExoCloudProxy : NSObject {
    NSString *serverUrl;
}
- (id)initWithServerUrl:(NSString *)serverurl;
- (CloudResponse)signUpWithEmail:(NSString *)emailAddress;
- (CloudResponse)loginWithEmail:(NSString *)emailAddress password:(NSString *)password;
+ (ExoCloudProxy *)sharedInstance;
@end
