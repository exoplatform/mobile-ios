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

#import "ExoCloudProxy.h"
#import "CloudUtils.h"
#import "defines.h"

static NSString *EXO_CLOUD_TRY_AGAIN_PATH = @"/tryagain.jsp";
static NSString *EXO_CLOUD_RESUMING_PATH = @"/resuming.jsp";
static NSString *EXO_CLOUD_LOGIN_PATH = @"/";

//constants for the response body of cloud rest service

static NSString *USER_EXIST_RESPONSE = @"true";
static NSString *USER_NOT_EXIST_RESPONSE = @"false";
static NSString *TENANT_RESUMING_RESPONSE = @"starting";
static NSString *TENANT_ONLINE_RESPONSE = @"online";
static NSString *TENANT_CREATION_FAIL_RESPONSE=@"creation_fail";
static NSString *TENANT_STOPPED_RESPONSE = @"stopped";
static NSString *TENANT_CREATION_RESPONSE = @"creation";
static NSString *TENANT_WAITING_CREATION_RESPONSE = @"waiting_creation";

//response when signup for a tenant which reached the limit of users
#define ACCOUNT_BEING_PROCESSED_RESPONSE [NSString stringWithFormat:@"the request to create or join a workspace from %@ has already been submitted. it is currently being processed. please wait for the creation to be completed, or use another email.",self.email]
@implementation ExoCloudProxy {
    CloudRequest cloudRequest;
    int statusCode;
}
@synthesize delegate = _delegate;
@synthesize email = _email;
@synthesize tenantName = _tenantName;
@synthesize username = _username;

- (instancetype)initWithDelegate:(id<ExoCloudProxyDelegate>)delegate andEmail:(NSString *)email
{
    if((self = [super init])) {
        self.email = email;
        self.delegate = delegate;
    }
    return self;
}


- (void)signUp
{
    cloudRequest = SIGN_UP;
    NSString *encodedEmail = [self.email stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSString *postString = [NSString stringWithFormat:@"user-mail=%@", encodedEmail];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[self signUpRestUrl]]];
    
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    
    NSURLConnection *connectinon = [NSURLConnection connectionWithRequest:request delegate:self];
    
    [connectinon start];
}

- (void)checkTenantStatus
{
    cloudRequest = CHECK_TENANT_STATUS;
    
    NSString *requestLink = [NSString stringWithFormat:@"%@/%@",[self tenantStatusRestUrl], self.tenantName];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestLink]];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

- (void)checkUserExistance
{
    cloudRequest = CHECK_USER_EXIST;
    NSString *requestLink = [NSString stringWithFormat:@"%@/%@/%@", [self userExistRestUrl], self.tenantName,self.username];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestLink]];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
}
#pragma mark NSURLConnectionDelegate methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", [error description]);
    [self.delegate cloudProxy:self handleError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *responseBody = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] lowercaseString];
    if([responseBody length] > 0) {
        if([responseBody isEqualToString:TENANT_RESUMING_RESPONSE] || [responseBody isEqualToString:TENANT_STOPPED_RESPONSE] || [responseBody isEqualToString:TENANT_CREATION_FAIL_RESPONSE]) {
            [self.delegate cloudProxy:self handleCloudResponse:TENANT_RESUMING forEmail:self.email];
            [connection cancel];
        } else if([responseBody isEqualToString:TENANT_ONLINE_RESPONSE]) {
            [self.delegate cloudProxy:self handleCloudResponse:TENANT_ONLINE forEmail:self.email];
            [connection cancel];
        } else if([responseBody isEqualToString:USER_EXIST_RESPONSE]) {
            [self.delegate cloudProxy:self handleCloudResponse:USER_EXISTED forEmail:self.email];
            [connection cancel];
        } else if([responseBody isEqualToString:USER_NOT_EXIST_RESPONSE]) {
            [self.delegate cloudProxy:self handleCloudResponse:USER_NOT_EXISTED forEmail:self.email];
            [connection cancel];
        } else if([responseBody isEqualToString:TENANT_CREATION_RESPONSE] || [responseBody isEqualToString:TENANT_WAITING_CREATION_RESPONSE]) {
            [self.delegate cloudProxy:self handleCloudResponse:TENANT_CREATION forEmail:self.email];
            [connection cancel];
        } else if([responseBody isEqualToString:ACCOUNT_BEING_PROCESSED_RESPONSE] && statusCode == 500) {
            [self.delegate cloudProxy:self handleCloudResponse:NUMBER_OF_USERS_EXCEED forEmail:self.email];
            [connection cancel];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    statusCode = httpResponse.statusCode;
    switch (cloudRequest) {
        case CHECK_TENANT_STATUS: {
            switch (statusCode) {
                case 404: {
                    [self.delegate cloudProxy:self handleCloudResponse:TENANT_NOT_EXIST forEmail:nil];
                    [connection cancel];
                    break;
                }
                case 503 : {
                    [self.delegate cloudProxy:self handleCloudResponse:SERVICE_UNAVAILABLE forEmail:nil];
                    [connection cancel];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case SIGN_UP: {
            switch(httpResponse.statusCode) {
                case 202: {
                    [self.delegate cloudProxy:self handleCloudResponse:NUMBER_OF_USERS_EXCEED forEmail:nil];
                    [connection cancel];
                    [self getInfoForMail:self.email andCreateLead:YES];
                    break;
                }
                case 503 : {
                    [self.delegate cloudProxy:self handleCloudResponse:SERVICE_UNAVAILABLE forEmail:nil];
                    [connection cancel];
                    break;
                }
                    
                case 200 :  {
                    [self.delegate cloudProxy:self handleCloudResponse:EMAIL_SENT forEmail:self.email];
                    [connection cancel];
                    [self getInfoForMail:self.email andCreateLead:YES];
                    break;
                }
                
                default:
                    break;
            }
        }
        default:
            break;
    }
    
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    if(response) {
        NSString *path = [[request URL] path];
        if([EXO_CLOUD_RESUMING_PATH isEqualToString:path]) {
            [self.delegate cloudProxy:self handleCloudResponse: TENANT_RESUMING forEmail:self.email];
        } else if([EXO_CLOUD_TRY_AGAIN_PATH isEqualToString:path]) {
            [self.delegate cloudProxy:self handleCloudResponse: EMAIL_BLACKLISTED forEmail:self.email];
        } else if([EXO_CLOUD_LOGIN_PATH isEqualToString:path]) {
            [self.delegate cloudProxy:self handleCloudResponse: ACCOUNT_CREATED forEmail:self.email];
        } 
        [connection cancel];
        return nil;
    }
    return request;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

- (void)dealloc
{
    [super dealloc];
    self.email = nil;
    self.tenantName = nil;
    self.username = nil;
    self.delegate = nil;
}

#pragma mark Cloud rest service url
- (NSString *)signUpRestUrl
{
    return [NSString stringWithFormat:@"%@/%@/%@", EXO_CLOUD_URL, EXO_CLOUD_TENANT_SERVICE_PATH,@"signup"];
}

- (NSString *)tenantStatusRestUrl
{
    return [NSString stringWithFormat:@"%@/%@/%@", EXO_CLOUD_URL, EXO_CLOUD_TENANT_SERVICE_PATH, @"status"];
}

- (NSString *)userExistRestUrl
{
    return [NSString stringWithFormat:@"%@/%@/%@", EXO_CLOUD_URL, EXO_CLOUD_TENANT_SERVICE_PATH, @"isuserexist"];
}

- (NSString *)usermailInfoRestUrl
{
    return [NSString stringWithFormat:@"%@/%@/%@", EXO_CLOUD_URL, EXO_CLOUD_TENANT_SERVICE_PATH, @"usermailinfo"];
}

//gets username, tenant name from email address by requesting a rest service from cloud
//if createLead=true, create a marketo lead for given email and tenant name
- (void) getInfoForMail:(NSString *)email andCreateLead:(BOOL)createLead
{
    NSString *requestLink = [NSString stringWithFormat:@"%@/%@", [self usermailInfoRestUrl], email];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestLink]];
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if(error) {
            [self.delegate cloudProxy:self handleError:error];
        } else {
            NSError *jsonError = nil;
            NSDictionary *dict = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:0
                                  error:&error];
            if(jsonError) {
                [self.delegate cloudProxy:self handleError:error];
            } else {
                self.username = dict[@"username"];
                self.tenantName = dict[@"tenant"];
                if(createLead) {
                    //create marketo lead when signing up
                    [self createLeadForEmail:self.email andTenant:self.tenantName];
                } else {
                    //then check tenant status before logging in
                   [self checkTenantStatus]; 
                }
            }
        }
    }];
}

- (void)createLeadForEmail:(NSString *)email andTenant:(NSString *)tenant
{
    NSString *actionLink = @"http://learn.exoplatform.com/index.php/leadCapture/save";
    NSString *encodedEmail = [email stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *params = [NSString stringWithFormat:@"Email=%@&lpId=1967&subId=46&munchkinId=577-PCT-880&formid=1167&returnLPId=-1&eXo_Cloud_Tenant_Name__c=%@", encodedEmail, tenant];
    NSData *payload = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:actionLink]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:payload];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error) {
          NSLog(@"create marketo lead failed for email: %@", email);    
        }
    }];
}
@end
