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
@class ExoCloudProxy;

@protocol ExoCloudProxyDelegate <NSObject>

-(void)cloudProxy:(ExoCloudProxy *)proxy handleCloudResponse:(CloudResponse)response forEmail:(NSString *)email;
- (void)cloudProxy:(ExoCloudProxy *)proxy handleError:(NSError *)error;
@end

@interface ExoCloudProxy : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSString *serverUrl;
    id<ExoCloudProxyDelegate> _delegate;
}
@property (nonatomic, retain) id<ExoCloudProxyDelegate> delegate;
@property (nonatomic, retain) NSString *email;
- (id)initWithServerUrl:(NSString *)serverurl;
- (void)signUpWithEmail:(NSString *)emailAddress;
- (CloudResponse)loginWithEmail:(NSString *)emailAddress password:(NSString *)password;
@end
