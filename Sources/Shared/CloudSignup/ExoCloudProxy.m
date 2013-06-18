//
//  ExoCloudProxy.m
//  eXo Platform
//
//  Created by vietnq on 6/17/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "ExoCloudProxy.h"

//NSString const *EXO_CLOUD_URL = @"http://wks-acc.exoplatform.org";
static NSString *EXO_CLOUD_URL = @"http://cloud-workspaces.com";
static NSString *EXO_CLOUD_SIGNUP_REST_PATH = @"/rest/cloud-admin/cloudworkspaces/tenant-service/signup";
static NSString *EXO_CLOUD_TRY_AGAIN_PATH = @"/tryagain.jsp";
static NSString *EXO_CLOUD_RESUMING_PATH = @"/resuming.jsp";
static NSString *EXO_CLOUD_LOGIN_PATH = @"/";

static NSString *EXO_CLOUD_TENANT_RESUMING_REST_BODY = @"starting";
static NSString *EXO_CLOUD_TENANT_ONLINE_REST_BODY = @"online";

static NSString *EXO_CLOUD_USER_EXIST_REST_BODY = @"true";
static NSString *EXO_CLOUD_USER_NOT_EXIST_REST_BODY = @"false";

@implementation ExoCloudProxy {
    CloudResponse cloudResponse;
}
@synthesize delegate = _delegate;
@synthesize email = _email;

- (id)initWithServerUrl:(NSString *)aServerUrl
{
    if((self = [super init])) {
        serverUrl = aServerUrl;
    }
    return self;
}

- (CloudResponse)loginWithEmail:(NSString *)emailAddress password:(NSString *)password
{
    return EMAIL_SENT;
}

- (void)signUpWithEmail:(NSString *)emailAddress
{
    NSString *encodedEmail = [emailAddress stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSString *postString = [NSString stringWithFormat:@"user-mail=%@", encodedEmail];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *cloudRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[self signUpRestUrl]]];

    [cloudRequest setHTTPBody:postData];
    [cloudRequest setHTTPMethod:@"POST"];
    
    NSURLConnection *connectinon = [NSURLConnection connectionWithRequest:cloudRequest delegate:self];
        
    [connectinon start];
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
    if([responseBody isEqualToString:EXO_CLOUD_TENANT_RESUMING_REST_BODY]) {
        NSLog(@"tenant resuming");
    } else if([responseBody isEqualToString:EXO_CLOUD_TENANT_ONLINE_REST_BODY]) {
        NSLog(@"tenant online");
    } else if([responseBody isEqualToString:EXO_CLOUD_USER_EXIST_REST_BODY]) {
        NSLog(@"user exist");
    } else if([responseBody isEqualToString:EXO_CLOUD_USER_NOT_EXIST_REST_BODY]) {
        NSLog(@"user not exist");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"status code: %u", httpResponse.statusCode);
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    if(response) {
        NSString *path = [[request URL] path];
        if([EXO_CLOUD_RESUMING_PATH isEqualToString:path]) {
            [_delegate cloudProxy:self handleCloudResponse: TENANT_SUSPENDED forEmail:self.email];
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
    NSLog(@"finish loading");
    [_delegate cloudProxy:self handleCloudResponse:EMAIL_SENT forEmail:self.email];
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
    return [NSString stringWithFormat:@"%@%@", EXO_CLOUD_URL, EXO_CLOUD_SIGNUP_REST_PATH];
}
@end
