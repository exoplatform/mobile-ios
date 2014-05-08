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

typedef enum {
    EMAIL_SENT = 1, //validation email sent
    ACCOUNT_CREATED, //account confirmed
    NUMBER_OF_USERS_EXCEED, //maximum number of users is reached
    EMAIL_BLACKLISTED,//the email is blacklisted (public email like gmail, yahoo)
    TENANT_RESUMING, //tenant is being stopped/resumed
    TENANT_NOT_EXIST, //tenant does not exist
    TENANT_ONLINE, 
    USER_EXISTED,
    USER_NOT_EXISTED,
    SERVICE_UNAVAILABLE,
    TENANT_CREATION, //tenant is being created or waiting for creation
    INTERNAL_SERVER_ERROR //internal server error, 
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
- (void)getInfoForMail:(NSString *)email andCreateLead:(BOOL)createLead;
@end
