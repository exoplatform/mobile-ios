//
//  ExoCloudProxy.h
//  eXo Platform
//
//  Created by vietnq on 6/17/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    EMAIL_SENT = 1, //validation email sent
    ACCOUNT_CREATED, //account confirmed
    NUMBER_OF_USERS_EXCEED,
    EMAIL_BLACKLISTED,
    TENANT_RESUMING,
    TENANT_NOT_EXIST,
    TENANT_ONLINE,
    USER_EXISTED,
    USER_NOT_EXISTED,
    TENANT_NOT_READY
} CloudResponse;

typedef enum
{
    CHECK_USER_EXIST = 1,
    CHECK_TENANT_STATUS,
    SIGN_UP
} CloudRequest;

@class ExoCloudProxy;

@protocol ExoCloudProxyDelegate <NSObject>

-(void)cloudProxy:(ExoCloudProxy *)cloudProxy handleCloudResponse:(CloudResponse)response forEmail:(NSString *)email;
- (void)cloudProxy:(ExoCloudProxy *)cloudProxy handleError:(NSError *)error;
@end

@interface ExoCloudProxy : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {

}

@property (nonatomic, retain) id<ExoCloudProxyDelegate> delegate;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *tenantName;
@property (nonatomic, retain) NSString *username;

- (id)initWithDelegate:(id<ExoCloudProxyDelegate>)delegate andEmail:(NSString *)email;
- (void)signUp;
- (void)checkTenantStatus;
- (void)checkUserExistance;
- (void)getUserMailInfo;
@end
