//
//  httpClient.m
//  eXoApp
//
//  Created by Tran Hoai Son on 5/9/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import "httpClient.h"
#import "eXoUserClient.h"
#import "defines.h"
#import "DataProcess.h"
#import "eXoAccount.h"
#import "DDXML.h"

static	NSString* _strFirstLoginContent;
static NSString* _fullDomainStr;

@implementation httpClient
@synthesize _receivedData, _statusCode;

- (id)init 
{
	self = [super init];
	_receivedData = [[NSMutableData alloc] init];
	return self;
}

- (void)dealloc 
{
	[_connection release];
	[_receivedData release];
	[super dealloc];
}

+ (NSString*)URLForEXOWithAccount 
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	return [NSString stringWithFormat:@"%@/portal/public/webos", [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN]];
}

+ (NSString*)stringEncodedWithBase64:(NSString*)str
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
	
	NSString *ret = [NSString stringWithCString:tmp];
	free(tmp);
	
	
	return ret;
}

+ (NSString*)stringOfAuthorizationHeaderWithUsername:(NSString*)username password:(NSString*)password
{
    NSString *s = @"Basic ";
    //[s autorelease];
    NSString *author = [s stringByAppendingString:[eXoUserClient stringEncodedWithBase64:[NSString stringWithFormat:@"%@:%@", username, password]]];

	
	return author;
}

+ (NSData*)sendRequest:(NSString*)urlStr
{
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSURLResponse* response;
	NSError* error;
	NSData* dataReply;
	
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

	NSURL* url = [NSURL URLWithString:urlStr];
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
	[request setURL:url];
	[request setTimeoutInterval:60.0];
	[request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
	//[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	//[request setHTTPShouldHandleCookies:YES];	
	[request setHTTPMethod:@"GET"];
	
	dataReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	//[pool release];
	return dataReply;
}

+ (NSData*)sendRequestWithAuthorization:(NSString*)urlStr
{
	NSURLResponse* response;
	NSError* error;
	NSData* dataReply;
	NSString* username;
	NSString* password;
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
	password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
	
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSURL* url = [NSURL URLWithString:urlStr];
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
	[request setURL:url]; 
	[request setTimeoutInterval:600.0];
	[request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
	[request setHTTPShouldHandleCookies:YES];
	[request setHTTPMethod:@"GET"];
	//[request setValue:[httpClient stringOfAuthorizationHeaderWithUsername:username password:password] forHTTPHeaderField:@"Authorization"];
	dataReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return dataReply;
}

- (NSMutableURLRequest*)makeRequest:(NSString*)url 
{
	//NSString *encodedUrl = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)url, NULL, NULL, kCFStringEncodingUTF8);
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	//[request setURL:[NSURL URLWithString:encodedUrl]];
	[request setURL:[NSURL URLWithString:url]];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setTimeoutInterval:TIMEOUT_SEC];
	[request setHTTPShouldHandleCookies:YES];
	//[encodedUrl release];
	return request;
}

- (NSMutableURLRequest*)makeRequest:(NSString*)url username:(NSString*)username password:(NSString*)password
{
	NSMutableURLRequest *request = [self makeRequest:url];
	[request setValue:[httpClient stringOfAuthorizationHeaderWithUsername:username password:password] forHTTPHeaderField:@"Authorization"];
	return request;
}

- (void)requestGET:(NSString*)url
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSMutableURLRequest *request = [self makeRequest:url];
	endGetData = NO;
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	while (!endGetData) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
}

- (void)requestGET:(NSString*)url username:(NSString*)username password:(NSString*)password
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSMutableURLRequest *request = [self makeRequest:url username:username password:password];
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

/*
- (void)requestPOST:(NSString*)url body:(NSString*)body
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSMutableURLRequest *request = [self makeRequest:url];
	[request setHTTPMethod:@"POST"];
	if (body)
	{
		[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	}
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
*/

- (void)requestPOST:(NSString*)url body:(NSString*)body username:(NSString*)username password:(NSString*)password
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSMutableURLRequest *request = [self makeRequest:url username:username password:password];
    [request setHTTPMethod:@"POST"];
	if (body)
	{
		[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	}
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
	
	NSURLResponse* response;
	NSError* error;
	NSData* dataReply;
	NSString* urlContent = [[NSString alloc] init];
	
	NSURL* homeURL = [NSURL URLWithString:domain];
	NSMutableURLRequest* homeRequest = [[NSMutableURLRequest alloc] init];
	[homeRequest setURL:homeURL];
	[homeRequest setHTTPMethod:@"GET"];
	dataReply = [NSURLConnection sendSynchronousRequest:homeRequest returningResponse:&response error:&error];
	
	urlContent = [[NSMutableString alloc] initWithData:dataReply encoding:NSISOLatin1StringEncoding];
	NSString* context = @"";
	
	NSRange range = [urlContent rangeOfString:@"eXo.env.server.portalBaseURL = \""];
	if(range.length > 0)
	{
		urlContent = [urlContent substringWithRange:NSMakeRange(range.location + range.length, 100)];
		range = [urlContent rangeOfString:@"/\" ;"];
		urlContent = [urlContent substringToIndex:range.location];
		
		NSRange tmpRange = [urlContent rangeOfString:@"public"];
		if(tmpRange.length > 0)
		{
			context = [urlContent stringByReplacingOccurrencesOfString:@"public" withString:@"private"];
		}
	}
	else if([domain isEqualToString:@"http://platform.demo.exoplatform.org"]|| [domain isEqualToString:@"http://localhost:8080"])
	{
		context = @"/portal/private/intranet";
	}
	else {
		context = @"/portal/private/classic";
	}

	return context;

}


//- (BOOL)sendAuthenticateRequest:(NSString*)urlStr username:(NSString*)username password:(NSString*)password
- (NSString*)sendAuthenticateRequest:(NSString*)domain username:(NSString*)username password:(NSString*)password
{	
	
	NSURLResponse* response;
	NSError* error;
	NSData* dataReply;
	//_strFirstLoginContent = [[NSString alloc] init];
	NSData* bodyData;
	
	//Request to keep the redirected URL
	if(_fullDomainStr == nil)
	{
		_fullDomainStr = [[NSString alloc] initWithString:[self getExtend:domain]];
	}
	NSString* redirectStr = [NSString stringWithFormat:@"%@%@", domain, _fullDomainStr];
	
	NSURL* redirectURL = [NSURL URLWithString:redirectStr];
	NSString* checkUrlStr = [NSString stringWithContentsOfURL:redirectURL encoding:NSUTF8StringEncoding error:nil];
	if(checkUrlStr == nil) {
		redirectURL = nil;
		[redirectURL release];
		return @"ERROR";
	}
	
	NSHTTPCookieStorage *store = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	
	NSRange rangeOfPrivate = [redirectStr rangeOfString:@"/classic"];
	
	//Request to login
	NSString* loginStr;
	if(rangeOfPrivate.length > 0)
		loginStr = [[redirectStr substringToIndex:rangeOfPrivate.location] stringByAppendingString:@"/j_security_check"];
	else
		loginStr = [redirectStr stringByAppendingString:@"/j_security_check"];
	
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
	
	
	dataReply = [NSURLConnection sendSynchronousRequest:loginRequest returningResponse:&response error:&error];
	if([dataReply bytes] == nil) 
	{
		[loginRequest release];
		return @"ERROR";
	}
	_strFirstLoginContent = [[NSMutableString alloc] initWithData:dataReply encoding:NSISOLatin1StringEncoding];
	
	NSRange rgCheck = [_strFirstLoginContent rangeOfString:@"Sign in failed. Wrong username or password."];
	if(rgCheck.length > 0)
	{
		[loginRequest release];
		return @"NO";
	}
	else
	{
		[loginRequest release];
		return @"YES";
	}
}

+ (NSData*)sendRequestToGetGadget:(NSString*)urlStr username:(NSString*)username password:(NSString*)password
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
	[postDictionary setValue:username forKey:@"j_username"];
	[postDictionary setValue:password forKey:@"j_password"];
	DataProcess* dataProcess = [DataProcess instance];
	bodyData = [dataProcess formatDictData:postDictionary WithEncoding:NSUTF8StringEncoding];
	
	[loginRequest setHTTPBody:bodyData];
	[loginRequest setHTTPMethod: @"POST"]; 
	
	NSDictionary *cookiesInfo = [NSHTTPCookie requestHeaderFieldsWithCookies:[store cookies]];
	[loginRequest setValue:[cookiesInfo objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
	
	dataResponse = [NSURLConnection sendSynchronousRequest:loginRequest returningResponse:&response error:&error];
	
	return dataResponse;
}


+ (NSString*)getFirstLoginContent
{
	return _strFirstLoginContent;
}

+ (NSString*)getFullDomainStr;
{
	return _fullDomainStr;
}
- (void)cancel
{
	[_connection cancel];
	[self requestFailed:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)requestSucceeded
{
	// implement by subclass
}

- (void)requestFailed:(NSError*)error
{
	// implement by subclass
	[_connection release];
}

/*
 -(void)connection:(NSURLConnection*)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge { 
 [[challenge sender] cancelAuthenticationChallenge:challenge]; 
 }    
 */

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
	_statusCode = [(NSHTTPURLResponse*)response statusCode];
	NSDictionary *header = [(NSHTTPURLResponse*)response allHeaderFields];
	//
	_isXmlTypeContent = NO;
	NSString* content_type = [header objectForKey:@"Content-Type"];
	if (content_type)
	{
		NSRange r = [content_type rangeOfString:@"xml"];
		if (r.location != NSNotFound)
		{
			_isXmlTypeContent = YES;
		}
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
	NSMutableData *responseData;
	responseData = [[NSMutableData data] retain];
	[responseData setLength:0];
	[responseData appendData:_receivedData];
	
	//NSString* inString = [[[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding] autorelease]; 
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	endGetData = YES;
	[_connection release];
	[self requestSucceeded];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError*)error
{
	[self requestFailed:error];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
