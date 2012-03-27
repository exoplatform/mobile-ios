//
//  Connection.m
//  GateInMobile-iPad
//
//  Created by Tran Hoai Son on 5/27/10.
//  Copyright 2010 home. All rights reserved.
//

#import "Connection.h"
#import "DataProcess.h"
#import "defines.h"

@implementation Connection

@synthesize _strUsername;
@synthesize _strPassword;

- (id)init 
{
	self = [super init];
	if(self)
	{
		_strFirstLoginContent = [[NSString alloc] init];
	}	
	return self;
}

- (void)dealloc 
{
	[super dealloc];
}

- (NSString*)stringEncodedWithBase64:(NSString*)str
{
	static const char *tbl = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	
	const char *s = [str UTF8String];
	int length = [str length];
	char *tmp = malloc(length * 4 / 3 + 4);
	
	int i = 0;
	int n = 0;
	char *p = tmp;
	
	while (i < length)
	{
		n = s[i++];
		n *= 256;
		if (i < length) n += s[i];
		i++;
		n *= 256;
		if (i < length) n += s[i];
		i++;
		
		p[0] = tbl[((n & 0x00fc0000) >> 18)];
		p[1] = tbl[((n & 0x0003f000) >> 12)];
		p[2] = tbl[((n & 0x00000fc0) >>  6)];
		p[3] = tbl[((n & 0x0000003f) >>  0)];
		
		if (i > length) p[3] = '=';
		if (i > length + 1) p[2] = '=';
		
		p += 4;
	}
	
	*p = '\0';
	
	NSString* ret = [NSString stringWithCString:tmp];
	free(tmp);
	
	return ret;
}

- (NSString*)stringOfAuthorizationHeaderWithUsername:(NSString*)username password:(NSString*)password
{
    NSString* s = @"Basic ";
    NSString* author = [s stringByAppendingString:[self stringEncodedWithBase64:[NSString stringWithFormat:@"%@:%@", username, password]]];	
	return author;
}

- (NSString*)getExtend:(NSString*)domain
{
	NSArray *domainArr = [DOMAINLIST componentsSeparatedByString:@";"];
	for(int i = 0; i < [domainArr count]; i++)
	{
		NSString *domainStr = [domainArr objectAtIndex:i];
		NSRange rangeOfDomain = [domainStr rangeOfString:domain];
		if (rangeOfDomain.length > 0)
		{
			NSRange rangeOfSpace = [domainStr rangeOfString:@" "];
			return [domainStr substringFromIndex:rangeOfSpace.location + 1];
		}
	}
	
	return @"/portal/private/intranet";
	
}

- (NSString*)getFirstLoginContent
{
	return _strFirstLoginContent;
}

- (NSString*)sendAuthenticateRequest:(NSString*)domain username:(NSString*)username password:(NSString*)password
{	
	NSURLResponse* response;
	NSError* error;
	NSData* dataResponse;
	NSString* urlContent = [[NSString alloc] init];
	NSData* bodyData;
	
	_strUsername = username;
	_strPassword = password;
	
	NSString* redirectStr = [NSString stringWithFormat:@"%@%@", domain, [self getExtend:domain]];
	
	NSURL* redirectURL1 = [NSURL URLWithString:redirectStr];
	NSString* checkUrlStr = [NSString stringWithContentsOfURL:redirectURL1 encoding:NSUTF8StringEncoding error:nil];
	if(checkUrlStr == nil) 
	{
		redirectURL1 = nil;
		[redirectURL1 release];
		return @"ERROR";
	}
	
	NSHTTPCookieStorage *store = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	
//	NSArray* tmpCookie = [store cookies];
//	for(int i = 0; i < [tmpCookie count]; i++) 
//	{
//		[store deleteCookie:(NSHTTPCookie *)[tmpCookie objectAtIndex:i]];
//	}
//	
//	NSURL* redirectURL = [NSURL URLWithString:redirectStr];
//	NSMutableURLRequest* redirectRequest = [[NSMutableURLRequest alloc] init];	
//	[redirectRequest setURL:redirectURL]; 
//	[redirectRequest setTimeoutInterval:60.0];
//	[redirectRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
//	[redirectRequest setHTTPShouldHandleCookies:YES];	
//	[redirectRequest setHTTPMethod: @"GET"];
//	
//	dataResponse = [NSURLConnection sendSynchronousRequest:redirectRequest returningResponse:&response error:&error];
//	
//	NSArray* cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[(NSHTTPURLResponse*)response allHeaderFields] forURL:redirectURL];
//	NSEnumerator* c = [cookies objectEnumerator];
//	id cookie;
//	while (cookie = [c nextObject]) 
//	{
//		//	NSString* ckstr = [cookie description];
//		[store setCookie:cookie];
//	}
	
	
	NSRange rangeOfPrivate = [redirectStr rangeOfString:@"/classic"];
	
	//Request to login
	NSString* loginStr;
	if(rangeOfPrivate.length > 0)
		loginStr = [[redirectStr substringToIndex:rangeOfPrivate.location] stringByAppendingString:@"/j_security_check"];
	else
		loginStr = [redirectStr stringByAppendingString:@"/j_security_check"];
	
	//Request to login
	NSURL* loginURL = [NSURL URLWithString:loginStr];
	NSMutableURLRequest* loginRequest = [[NSMutableURLRequest alloc] init];	
	[loginRequest setURL:loginURL];
	[loginRequest setTimeoutInterval:60.0];
	[loginRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
	[loginRequest setHTTPShouldHandleCookies:NO];
	
	NSDictionary* postDictionary = [[NSMutableDictionary alloc] initWithCapacity:2];
	[postDictionary setValue:username forKey:@"j_username"];
	[postDictionary setValue:password forKey:@"j_password"];
	DataProcess* dataProcess = [DataProcess instance];
	bodyData = [dataProcess formatDictData:postDictionary WithEncoding:NSUTF8StringEncoding];
	
	[loginRequest setHTTPBody:bodyData];
	[loginRequest setHTTPMethod: @"POST"]; 
	
	NSDictionary *cookiesInfo = [NSHTTPCookie requestHeaderFieldsWithCookies:[store cookies]];
	[loginRequest setValue:[cookiesInfo objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
	
	
	dataResponse = [NSURLConnection sendSynchronousRequest:loginRequest returningResponse:&response error:&error];
	//NSString *tmpStr = [[NSString alloc] initWithData:dataReply encoding:NSUTF8StringEncoding];
	if([dataResponse bytes] == nil) 
	{
		[loginRequest release];
		return @"ERROR";
	}
	urlContent = [[NSMutableString alloc] initWithData:dataResponse encoding:NSISOLatin1StringEncoding];
	
	NSRange rgCheck = [urlContent rangeOfString:@"Sign in failed. Wrong username or password."];
	if(rgCheck.length > 0)
	{
		[loginRequest release];
		return @"NO";
	}
	else
	{
		[loginRequest release];
		_strFirstLoginContent = urlContent;
		return @"YES";
	}
}

- (NSData*)sendRequestToGetGadget:(NSString*)urlStr
{
	NSURLResponse* response;
	NSError* error;
	NSData* dataResponse;
	NSData* bodyData;
	
	NSURL* redirectURL = [NSURL URLWithString:urlStr];
	NSString* checkUrlStr = [NSString stringWithContentsOfURL:redirectURL encoding:NSUTF8StringEncoding error:nil];
	if(checkUrlStr == nil) 
	{
		redirectURL = nil;
		[redirectURL release];
		return nil;
	}
	
	NSHTTPCookieStorage *store = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	
	NSRange rangeOfPrivate = [urlStr rangeOfString:@"/classic"];
	
	//Request to login
	NSString* loginStr;
	if(rangeOfPrivate.length > 0)
		loginStr = [[urlStr substringToIndex:rangeOfPrivate.location] stringByAppendingString:@"/j_security_check"];
	else
	{
		rangeOfPrivate = [urlStr rangeOfString:@"/intranet"];
		if(rangeOfPrivate.length > 0)
			loginStr = [[urlStr substringToIndex:rangeOfPrivate.location + rangeOfPrivate.length] stringByAppendingString:@"/j_security_check"];
		
	}
	
	NSURL* loginURL = [NSURL URLWithString:loginStr];
	NSMutableURLRequest* loginRequest = [[NSMutableURLRequest alloc] init];	
	[loginRequest setURL:loginURL];
	[loginRequest setTimeoutInterval:60.0];
	[loginRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
	[loginRequest setHTTPShouldHandleCookies:NO];
	
	NSDictionary* postDictionary = [[NSMutableDictionary alloc] initWithCapacity:2];
	[postDictionary setValue:_strUsername forKey:@"j_username"];
	[postDictionary setValue:_strPassword forKey:@"j_password"];
	DataProcess* dataProcess = [DataProcess instance];
	bodyData = [dataProcess formatDictData:postDictionary WithEncoding:NSUTF8StringEncoding];
	
	[loginRequest setHTTPBody:bodyData];
	[loginRequest setHTTPMethod: @"POST"]; 
	
	NSDictionary *cookiesInfo = [NSHTTPCookie requestHeaderFieldsWithCookies:[store cookies]];
	[loginRequest setValue:[cookiesInfo objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
	
	dataResponse = [NSURLConnection sendSynchronousRequest:loginRequest returningResponse:&response error:&error];
	
	return dataResponse;
}

- (NSData*)sendRequestToSocialToGetGadget:(NSString*)urlStr
{
	NSURLResponse* response;
	NSError* error;
	NSData* dataResponse;
	NSData* bodyData;
		
	NSURL* redirectURL = [NSURL URLWithString:urlStr];
	NSString* checkUrlStr = [NSString stringWithContentsOfURL:redirectURL encoding:NSUTF8StringEncoding error:nil];
	if(checkUrlStr == nil) 
	{
		redirectURL = nil;
		[redirectURL release];
		return nil;
	}
	
	NSHTTPCookieStorage *store = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	
	NSRange rangeOfPrivate = [urlStr rangeOfString:@"/classic"];
	
	//Request to login
	NSString* loginStr = [[urlStr substringToIndex:rangeOfPrivate.location] stringByAppendingString:@"/j_security_check"];
	NSURL* loginURL = [NSURL URLWithString:loginStr];
	NSMutableURLRequest* loginRequest = [[NSMutableURLRequest alloc] init];	
	[loginRequest setURL:loginURL];
	[loginRequest setTimeoutInterval:60.0];
	[loginRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
	[loginRequest setHTTPShouldHandleCookies:NO];
	
	NSDictionary* postDictionary = [[NSMutableDictionary alloc] initWithCapacity:2];
	[postDictionary setValue:_strUsername forKey:@"j_username"];
	[postDictionary setValue:_strPassword forKey:@"j_password"];
	DataProcess* dataProcess = [DataProcess instance];
	bodyData = [dataProcess formatDictData:postDictionary WithEncoding:NSUTF8StringEncoding];
	
	[loginRequest setHTTPBody:bodyData];
	[loginRequest setHTTPMethod: @"POST"]; 
	
	NSDictionary *cookiesInfo = [NSHTTPCookie requestHeaderFieldsWithCookies:[store cookies]];
	[loginRequest setValue:[cookiesInfo objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
	
	dataResponse = [NSURLConnection sendSynchronousRequest:loginRequest returningResponse:&response error:&error];
	
	return dataResponse;
}

- (NSData*)sendRequestWithAuthorization:(NSString*)urlStr
{
	NSURLResponse* response;
	NSError* error;
	NSData* dataResponse;

	//[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSURL* url = [NSURL URLWithString:urlStr];
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
	[request setURL:url]; 
	[request setTimeoutInterval:60.0];
	[request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
	[request setHTTPShouldHandleCookies:YES];	
	[request setHTTPMethod:@"GET"];
	[request setValue:[self stringOfAuthorizationHeaderWithUsername:_strUsername password:_strPassword] forHTTPHeaderField:@"Authorization"];
	dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	return dataResponse;
}

- (NSData*)sendRequest:(NSString*)urlStr
{
	NSURLResponse* response;
	NSError* error;
	NSData* dataResponse;	
	NSURL* url = [NSURL URLWithString:urlStr];
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
	
	[request setURL:url];
	[request setTimeoutInterval:60.0];
	[request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
	[request setHTTPMethod:@"GET"];
	dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	return dataResponse;
}


@end
