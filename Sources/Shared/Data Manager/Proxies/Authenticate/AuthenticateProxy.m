//
//  AuthenticateProxy.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 22/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "AuthenticateProxy.h"
#import "defines.h"
#import "DataProcess.h"
#import "ServerPreferencesManager.h"


@interface AuthenticateProxy (PrivateMethods)


- (NSString*)stringEncodedWithBase64:(NSString*)str;	//Convert NSString to String64 

- (NSString*)stringOfAuthorizationHeaderWithUsername:(NSString*)username password:(NSString*)password;	//Athentication encoding

- (NSString*)getExtend:(NSString*)domain;	//Get sub URL path

@end


@implementation AuthenticateProxy


@synthesize username = _username, password = _password, firstLoginContent = _firstLoginContent, domainName =_domainName;


#pragma mark - Object Management
//Singleton Accessor/Creator
+ (AuthenticateProxy*)sharedInstance
{
	static AuthenticateProxy *sharedInstance;
	@synchronized(self)
	{
		if(!sharedInstance)
		{
			sharedInstance = [[AuthenticateProxy alloc] init];
		}
		return sharedInstance;
	}
	return sharedInstance;
}


//Initialisation Method
- (id) init
{
    if ((self = [super init])) 
    {
        _domainName = [[ServerPreferencesManager sharedInstance] selectedDomain];
        _username = [[ServerPreferencesManager sharedInstance] username];
        _password = [[ServerPreferencesManager sharedInstance] password];
        
    }	
	return self;
}

//Dealloc method
- (void) dealloc
{
	[_domainName release];
    [_firstLoginContent release];
    _firstLoginContent = nil;
    [_username release];
    [_password release];
	[super dealloc];
}



#pragma mark - Private Methods


//Encode Base 64 Method
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
	
	NSString* ret = [NSString stringWithCString:tmp encoding:NSASCIIStringEncoding];
	free(tmp);
	
	return ret;
}

// Create the authenticate prefix needed for Basic Authenticate Method
- (NSString*)stringOfAuthorizationHeaderWithUsername:(NSString*)username password:(NSString*)password
{
    NSString* s = @"Basic ";
    NSString* author = [s stringByAppendingString:[self stringEncodedWithBase64:[NSString stringWithFormat:@"%@:%@", username, password]]];	
	return author;
}

//Get extension to intranet portal url
- (NSString*)getExtend:(NSString*)domain
{
	return @"/portal/private/intranet";
}



#pragma mark - Authenticate Requests


//Send a request to know the reachability status
- (BOOL)isReachabilityURL:(NSString *)urlStr userName:(NSString *)userName password:(NSString *)password
{
    BOOL returnValue = NO;
    
    NSHTTPURLResponse* response;
    NSError* error;
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
    [request setURL:[NSURL URLWithString:urlStr]];
    
    [request setHTTPMethod:@"HEAD"];
    
    if(userName != nil)
    {
        NSString *s = @"Basic ";
        NSString *author = [s stringByAppendingString: [self stringEncodedWithBase64:[NSString stringWithFormat:@"%@:%@",userName, password]]];
        [request setValue:author forHTTPHeaderField:@"Authorization"];    
    }
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];    
    [request release];
    
    NSUInteger statusCode = [response statusCode];
    if(statusCode >= 200 && statusCode < 300)
    {
        returnValue = YES;        
    }  
    
    return returnValue;
}

- (NSString*)sendAuthenticateRequest:(NSString*)domain username:(NSString*)username password:(NSString*)password
{	
	NSURLResponse* response;
	NSError* error;
	NSData* dataResponse;
	NSData* bodyData;
	
	NSURL* tmpURL = [NSURL URLWithString:domain];
	NSString* tmpCheck = [NSString stringWithContentsOfURL:tmpURL encoding:NSUTF8StringEncoding error:nil];
	NSRange tmpRange = [tmpCheck rangeOfString:@"'error', '/main?url"];
	if(tmpCheck == nil || tmpRange.length > 0) 
	{
		tmpURL = nil;
		[tmpURL release];
		return @"ERROR";
	}
	
    
	self.username = username;
	self.password = password;
	self.domainName = domain;
    
	if ([_domainName hasSuffix:@"/"]) {
		_domainName = [_domainName substringToIndex:[_domainName length]-1];
	}
	
	NSString* redirectStr = [NSString stringWithFormat:@"%@%@", _domainName, [self getExtend:_domainName]];
	
	NSURL* redirectURL1 = [NSURL URLWithString:redirectStr];
	NSString* checkUrlStr = [NSString stringWithContentsOfURL:redirectURL1 encoding:NSUTF8StringEncoding error:nil];
	if(checkUrlStr == nil) 
	{
		redirectURL1 = nil;
		[redirectURL1 release];
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
	
	//Request to login
	NSURL* loginURL = [NSURL URLWithString:loginStr];
	NSMutableURLRequest* loginRequest = [[NSMutableURLRequest alloc] init];	
	[loginRequest setURL:loginURL];
	[loginRequest setTimeoutInterval:60.0];
	[loginRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
	[loginRequest setHTTPShouldHandleCookies:NO];
	
	NSDictionary* postDictionary = [NSMutableDictionary dictionaryWithCapacity:2];
	[postDictionary setValue:username forKey:@"j_username"];
	[postDictionary setValue:password forKey:@"j_password"];
	DataProcess* dataProcess = [DataProcess instance];
	bodyData = [dataProcess formatDictData:postDictionary WithEncoding:NSUTF8StringEncoding];
	
	[loginRequest setHTTPBody:bodyData];
	[loginRequest setHTTPMethod: @"POST"]; 
	
	NSDictionary *cookiesInfo = [NSHTTPCookie requestHeaderFieldsWithCookies:[store cookies]];
	[loginRequest setValue:[cookiesInfo objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
	
	
	dataResponse = [NSURLConnection sendSynchronousRequest:loginRequest returningResponse:&response error:&error];
	if([dataResponse bytes] == nil) 
	{
		[loginRequest release];
		return @"ERROR";
	}
	
	self.firstLoginContent = [[NSMutableString alloc] initWithData:dataResponse encoding:NSISOLatin1StringEncoding];
    
	NSRange rgCheck = [_firstLoginContent rangeOfString:@"Sign in failed. Wrong username or password."];
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


- (NSData*)sendRequestWithAuthorization:(NSString*)urlStr
{
	NSURLResponse* response;
	NSError* error;
	NSData* dataResponse;
    
	urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSURL* url = [NSURL URLWithString:urlStr];
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
	[request setURL:url]; 
	[request setTimeoutInterval:60.0];
	[request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
	[request setHTTPShouldHandleCookies:YES];	
	[request setHTTPMethod:@"GET"];
	[request setValue:[self stringOfAuthorizationHeaderWithUsername:_username password:_password] forHTTPHeaderField:@"Authorization"];
	dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	return dataResponse;
}



- (NSString*)loginForStandaloneGadget:(NSString*)domain
{
	NSURLResponse* response;
	NSError* error;
	NSData* dataResponse;
	NSData* bodyData;
	
	NSURL* tmpURL = [NSURL URLWithString:domain];
	NSString* tmpCheck = [NSString stringWithContentsOfURL:tmpURL encoding:NSUTF8StringEncoding error:nil];
	NSRange tmpRange = [tmpCheck rangeOfString:@"'error', '/main?url"];
	if(tmpCheck == nil || tmpRange.length > 0) 
	{
		tmpURL = nil;
		[tmpURL release];
		return @"ERROR";
	}
	
    NSString* urlContent = [[NSString alloc] init];
    
    
	NSString* loginStr;
	NSHTTPCookieStorage *store = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	
	loginStr = [NSString stringWithFormat:@"%@%@",_domainName,@"/portal/login"];
	//Request to login
	NSURL* loginURL = [NSURL URLWithString:loginStr];
	NSMutableURLRequest* loginRequest = [[NSMutableURLRequest alloc] init];	
	[loginRequest setURL:loginURL];
	[loginRequest setTimeoutInterval:60.0];
	[loginRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
	[loginRequest setHTTPShouldHandleCookies:NO];
	
	NSDictionary* postDictionary = [[NSMutableDictionary alloc] initWithCapacity:2];
	[postDictionary setValue:_username forKey:@"username"];
	[postDictionary setValue:_password forKey:@"password"];
	DataProcess* dataProcess = [DataProcess instance];
	bodyData = [dataProcess formatDictData:postDictionary WithEncoding:NSUTF8StringEncoding];
    //SLM release the postDictionary cause some troubles... so don't release it here
    
	[loginRequest setHTTPBody:bodyData];
	[loginRequest setHTTPMethod: @"POST"]; 
	
	NSDictionary *cookiesInfo = [NSHTTPCookie requestHeaderFieldsWithCookies:[store cookies]];
	[loginRequest setValue:[cookiesInfo objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
	
	
	dataResponse = [NSURLConnection sendSynchronousRequest:loginRequest returningResponse:&response error:&error];
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
        [urlContent release];
		return @"NO";
	}
	else
	{
		[loginRequest release];
//		_firstLoginContent = urlContent;
        [urlContent release];
		return @"YES";
	}
}



@end
