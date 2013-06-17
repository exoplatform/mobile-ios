//
//  ExoCloudProxy.m
//  eXo Platform
//
//  Created by vietnq on 6/17/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "ExoCloudProxy.h"

//NSString const *EXO_CLOUD_URL = @"http://wks-acc.exoplatform.org";
NSString const *EXO_CLOUD_URL = @"http://cloud-workspaces.com";
NSString const *EXO_CLOUD_SIGNUP_REST_PATH = @"/rest/cloud-admin/cloudworkspaces/tenant-service/signup";
NSString const *EXO_CLOUD_TRY_AGAIN_PATH = @"/tryagain.jsp";
NSString const *EXO_CLOUD_RESUMING_PATH = @"/resuming.jsp";
NSString const *EXO_CLOUD_LOGIN_PATH = @"/";

@implementation ExoCloudProxy {
    CloudResponse cloudResponse;
}
@synthesize delegate = _delegate;

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
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    if(response) {
        NSString *path = [[request URL] path];
        if([EXO_CLOUD_RESUMING_PATH isEqualToString:path]) {
            [_delegate handleCloudResponse: TENANT_SUSPENDED];
        } else if([EXO_CLOUD_TRY_AGAIN_PATH isEqualToString:path]) {
            [_delegate handleCloudResponse: EMAIL_BLACKLISTED];
        } else if([EXO_CLOUD_LOGIN_PATH isEqualToString:path]) {
            [_delegate handleCloudResponse: ACCOUNT_CREATED];
        }
        [connection cancel];
        return nil;
    }
    return request;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finish loading");
    [_delegate handleCloudResponse:EMAIL_SENT];
}

- (void)dealloc
{
    [super dealloc];
    [_delegate release];
}

#pragma mark Cloud rest service url
- (NSString *)signUpRestUrl
{
    return [NSString stringWithFormat:@"%@%@", EXO_CLOUD_URL, EXO_CLOUD_SIGNUP_REST_PATH];
}


@end
