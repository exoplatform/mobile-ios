//
//  ExoCloudProxy.m
//  eXo Platform
//
//  Created by vietnq on 6/17/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
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


@implementation ExoCloudProxy {
    CloudRequest cloudRequest;
}
@synthesize delegate = _delegate;
@synthesize email = _email;
@synthesize tenantName = _tenantName;
@synthesize username = _username;

- (id)initWithDelegate:(id<ExoCloudProxyDelegate>)delegate andEmail:(NSString *)email
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
    [_delegate cloudProxy:self handleError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *responseBody = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] lowercaseString];
    if([responseBody length] > 0) {
        if([responseBody isEqualToString:TENANT_RESUMING_RESPONSE] || [responseBody isEqualToString:TENANT_STOPPED_RESPONSE] || [responseBody isEqualToString:TENANT_CREATION_FAIL_RESPONSE]) {
            [_delegate cloudProxy:self handleCloudResponse:TENANT_RESUMING forEmail:self.email];
            [connection cancel];
        } else if([responseBody isEqualToString:TENANT_ONLINE_RESPONSE]) {
            [_delegate cloudProxy:self handleCloudResponse:TENANT_ONLINE forEmail:self.email];
            [connection cancel];
        } else if([responseBody isEqualToString:USER_EXIST_RESPONSE]) {
            [_delegate cloudProxy:self handleCloudResponse:USER_EXISTED forEmail:self.email];
            [connection cancel];
        } else if([responseBody isEqualToString:USER_NOT_EXIST_RESPONSE]) {
            [_delegate cloudProxy:self handleCloudResponse:USER_NOT_EXISTED forEmail:self.email];
            [connection cancel];
        } else if([responseBody isEqualToString:TENANT_CREATION_RESPONSE] || [responseBody isEqualToString:TENANT_WAITING_CREATION_RESPONSE]) {
            [_delegate cloudProxy:self handleCloudResponse:TENANT_CREATION forEmail:self.email];
            [connection cancel];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    switch (cloudRequest) {
        case CHECK_TENANT_STATUS: {
            switch (httpResponse.statusCode) {
                case 404: {
                    [_delegate cloudProxy:self handleCloudResponse:TENANT_NOT_EXIST forEmail:nil];
                    [connection cancel];
                    break;
                }
                case 503 : {
                    [_delegate cloudProxy:self handleCloudResponse:SERVICE_UNAVAILABLE forEmail:nil];
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
                    [_delegate cloudProxy:self handleCloudResponse:NUMBER_OF_USERS_EXCEED forEmail:nil];
                    [connection cancel];
                    //            [self createMarketoLead];
                    break;
                }
                case 503 : {
                    [_delegate cloudProxy:self handleCloudResponse:SERVICE_UNAVAILABLE forEmail:nil];
                    [connection cancel];
                    break;
                }
                    
                case 200 :  {
                    [_delegate cloudProxy:self handleCloudResponse:EMAIL_SENT forEmail:self.email];
                    [connection cancel];
                    //            [self createMarketoLead];
                    break;
                }
            }
            break;
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
            [_delegate cloudProxy:self handleCloudResponse: TENANT_RESUMING forEmail:self.email];
        } else if([EXO_CLOUD_TRY_AGAIN_PATH isEqualToString:path]) {
            [_delegate cloudProxy:self handleCloudResponse: EMAIL_BLACKLISTED forEmail:self.email];
        } else if([EXO_CLOUD_LOGIN_PATH isEqualToString:path]) {
            [_delegate cloudProxy:self handleCloudResponse: ACCOUNT_CREATED forEmail:self.email];
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
    [_delegate release];
    [_email release];
    [_tenantName release];
    [_username release];
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

- (void) getUserMailInfo
{
    NSString *requestLink = [NSString stringWithFormat:@"%@/%@", [self usermailInfoRestUrl], self.email];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestLink]];
    [request setHTTPMethod:@"GET"];
        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLResponse *response;
        NSError *error;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(!data) {
            NSLog(@"%@", [error description]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate cloudProxy:self handleError:error];
            });
        } else {
            [self parseMailInfoResponse:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self checkTenantStatus];
            });
        }
    });
}

- (void)createMarketoLead
{
    NSString *actionLink = @"http://learn.exoplatform.com/index.php/leadCapture/save";
    NSString *encodedEmail = [self.email stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *params = [NSString stringWithFormat:@"Email=%@&lpId=1967&subId=46&munchkinId=577-PCT-880&formid=1167&returnLPId=-1", encodedEmail];
    NSData *payload = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:actionLink]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:payload];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLResponse *response;
        NSError *error;
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(error) {
            NSLog(@"creating marketo lead failed");
        }
    });
}

//parse the response from user mail info rest service to get username and tenant name
//the response has form: {"username":"john","tenant":"exoplatform"}
//NSJSONSerialization is not available in iOS 4.3, so we must manually parse the response
- (void)parseMailInfoResponse:(NSData *)data
{
    NSString *infoString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    infoString = [infoString stringByReplacingOccurrencesOfString:@"{" withString:@""];
    infoString = [infoString stringByReplacingOccurrencesOfString:@"}" withString:@""];
    infoString = [infoString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSRange range = [infoString rangeOfString:@","];
    if(range.location != NSNotFound) {
        NSString *userPart = [infoString substringToIndex:range.location];
        NSString *tenantPart = [infoString substringFromIndex:range.location + 1];
        NSRange usernameRange = [userPart rangeOfString:@"username:"];
        NSRange tenantRange = [tenantPart rangeOfString:@"tenant:"];
        
        if(usernameRange.location != NSNotFound) {
            self.username = [userPart substringFromIndex:[userPart rangeOfString:@"username:"].location + [@"username:" length]];
            
        }
        if(tenantRange.location != NSNotFound) {
            self.tenantName = [tenantPart substringFromIndex:[tenantPart rangeOfString:@"tenant:"].location + [@"tenant:" length]];
        }
    }
}
@end
