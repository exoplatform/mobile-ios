//
//  AuthenticateProxy.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 22/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthenticateProxy.h"
#import "FilesProxy.h"
#import "eXo_Constants.h"


@implementation AuthenticateProxy

- (NSData*)sendRequestWithAuthorization:(NSString*)urlStr
{
	NSURLResponse* response;
	NSError* error;
	NSData* dataResponse;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSString *username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
	NSString *password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
    
    
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSURL* url = [NSURL URLWithString:urlStr];
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
	[request setURL:url]; 
	[request setTimeoutInterval:60.0];
	[request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
	[request setHTTPShouldHandleCookies:YES];	
	[request setHTTPMethod:@"GET"];
	[request setValue:[FilesProxy stringOfAuthorizationHeaderWithUsername:username password:password] forHTTPHeaderField:@"Authorization"];
	dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	return dataResponse;
}

@end
