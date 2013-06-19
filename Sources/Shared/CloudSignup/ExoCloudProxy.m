//
//  ExoCloudProxy.m
//  eXo Platform
//
//  Created by vietnq on 6/17/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "ExoCloudProxy.h"

static NSString *EXO_CLOUD_URL = @"http://wks-acc.exoplatform.org";
//static NSString *EXO_CLOUD_URL = @"http://cloud-workspaces.com";
//static NSString *EXO_CLOUD_URL = @"http://exoplatform.net";
static NSString *EXO_CLOUD_TENANT_SERVICE_PATH = @"rest/cloud-admin/cloudworkspaces/tenant-service";
static NSString *EXO_CLOUD_SIGNUP_REST_PATH = @"signup";
static NSString *EXO_CLOUD_TENANT_STATUS_REST_PATH = @"status";
static NSString *EXO_CLOUD_USER_EXIST_REST_PATH = @"isuserexist";

static NSString *EXO_CLOUD_TRY_AGAIN_PATH = @"/tryagain.jsp";
static NSString *EXO_CLOUD_RESUMING_PATH = @"/resuming.jsp";
static NSString *EXO_CLOUD_LOGIN_PATH = @"/";

static NSString *EXO_CLOUD_TENANT_RESUMING_REST_BODY = @"starting";
static NSString *EXO_CLOUD_TENANT_ONLINE_REST_BODY = @"online";

static NSString *EXO_CLOUD_USER_EXIST_REST_BODY = @"true";
static NSString *EXO_CLOUD_USER_NOT_EXIST_REST_BODY = @"false";

@implementation ExoCloudProxy {
    CloudRequest cloudRequest;
}
@synthesize delegate = _delegate;
@synthesize email = _email;

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
    NSString *requestLink = [NSString stringWithFormat:@"%@/%@",[self tenantStatusRestUrl], @"exoplatform"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestLink]];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

- (void)checkUserExistance
{
    cloudRequest = CHECK_USER_EXIST;
    NSString *requestLink = [NSString stringWithFormat:@"%@/%@/%@", [self userExistRestUrl], @"exoplatform",@"vietnq"];
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
        if([responseBody isEqualToString:EXO_CLOUD_TENANT_RESUMING_REST_BODY]) {
            NSLog(@"tenant resuming");
            [_delegate cloudProxy:self handleCloudResponse:TENANT_RESUMING forEmail:self.email];
        } else if([responseBody isEqualToString:EXO_CLOUD_TENANT_ONLINE_REST_BODY]) {
            NSLog(@"tenant online");
            [_delegate cloudProxy:self handleCloudResponse:TENANT_ONLINE forEmail:self.email];
        } else if([responseBody isEqualToString:EXO_CLOUD_USER_EXIST_REST_BODY]) {
            NSLog(@"user exist");
            [_delegate cloudProxy:self handleCloudResponse:USER_EXISTED forEmail:self.email];
        } else if([responseBody isEqualToString:EXO_CLOUD_USER_NOT_EXIST_REST_BODY]) {
            NSLog(@"user not exist");
            [_delegate cloudProxy:self handleCloudResponse:USER_NOT_EXISTED forEmail:self.email];
        }
        [connection cancel];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    //the tenant is not exist
    if(cloudRequest == CHECK_TENANT_STATUS && httpResponse.statusCode == 404) {
        NSLog(@"tenant not exist");
        [_delegate cloudProxy:self handleCloudResponse:TENANT_NOT_EXIST forEmail:nil];
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
    if(cloudRequest == SIGN_UP) {
        [_delegate cloudProxy:self handleCloudResponse:EMAIL_SENT forEmail:self.email];
    }
}

- (void)dealloc
{
    [super dealloc];
    [_delegate release];
    [_email release];
}

#pragma mark Cloud rest service url
- (NSString *)signUpRestUrl
{
    return [NSString stringWithFormat:@"%@/%@/%@", EXO_CLOUD_URL, EXO_CLOUD_TENANT_SERVICE_PATH,EXO_CLOUD_SIGNUP_REST_PATH];
}

- (NSString *)tenantStatusRestUrl
{
    return [NSString stringWithFormat:@"%@/%@/%@", EXO_CLOUD_URL, EXO_CLOUD_TENANT_SERVICE_PATH, EXO_CLOUD_TENANT_STATUS_REST_PATH];
}

- (NSString *)userExistRestUrl
{
    return [NSString stringWithFormat:@"%@/%@/%@", EXO_CLOUD_URL, EXO_CLOUD_TENANT_SERVICE_PATH, EXO_CLOUD_USER_EXIST_REST_PATH];
}
@end
