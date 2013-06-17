//
//  ExoCloudProxy.m
//  eXo Platform
//
//  Created by vietnq on 6/17/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "ExoCloudProxy.h"

NSString const *EXO_CLOUD_URL = @"http://wks-acc.exoplatform.org";
NSString const *EXO_CLOUD_SIGNUP_REST_PATH = @"/rest/cloud-admin/cloudworkspaces/tenant-service/signup";

@implementation ExoCloudProxy

- (id)initWithServerUrl:(NSString *)aServerUrl
{
    if((self = [super init])) {
        serverUrl = aServerUrl;
    }
    return self;
}

+ (ExoCloudProxy *)sharedInstance
{
	static ExoCloudProxy *sharedInstance;
	@synchronized(self)
	{
		if(!sharedInstance)
		{
			sharedInstance = [[ExoCloudProxy alloc] init];
		}
		return sharedInstance;
	}
	return sharedInstance;
}
- (CloudResponse)loginWithEmail:(NSString *)emailAddress password:(NSString *)password
{
    return EMAIL_SENT;
}

- (CloudResponse)signUpWithEmail:(NSString *)emailAddress
{
    NSString *encodedEmail = [emailAddress stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSString *postString = [NSString stringWithFormat:@"user-mail=%@", encodedEmail];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *cloudRequest = nil;
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = nil;
    
    cloudRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[self signUpRestUrl]]];
    [cloudRequest setHTTPMethod:@"POST"];
    [cloudRequest setHTTPBody:postData];
    
    data = [NSURLConnection sendSynchronousRequest:cloudRequest returningResponse:&response error:&error];
    
    return [self cloudResponseWithHttpResponse:(NSHTTPURLResponse *)response data:data error:error];
    
}

- (NSString *)signUpRestUrl
{
    return [NSString stringWithFormat:@"%@%@", EXO_CLOUD_URL, EXO_CLOUD_SIGNUP_REST_PATH];
}

- (CloudResponse) cloudResponseWithHttpResponse:(NSHTTPURLResponse *)httpResponse data:(NSData *)data error:(NSError *)error
{
    CloudResponse response = nil;
    
    if(error) {
        response = nil;
    }
    
    if(httpResponse.statusCode == 200) {
        response = EMAIL_SENT;
    }
    
    if(httpResponse.statusCode == 309) {
        response = ACCOUNT_CREATED;
    }
    return response;
}
@end
