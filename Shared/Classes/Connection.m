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
#import "Gadget_iPhone.h"
#import "Gadget.h"

static NSString* _strUsername;
static NSString* _strPassword;
static NSString* _strFirstLoginContent;

@implementation Connection

- (id)init 
{
	self = [super init];
	if(self)
	{
		
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
	
	NSString* ret = [NSString stringWithCString:tmp encoding:NSASCIIStringEncoding];
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

- (NSString*)sendAuthenticateRequest:(NSString*)domain username:(NSString*)username password:(NSString*)password
{	
	NSURLResponse* response;
	NSError* error;
	NSData* dataResponse;
	NSString* urlContent = [[NSString alloc] init];
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
	
	_strFirstLoginContent = [[NSMutableString alloc] initWithData:dataResponse encoding:NSISOLatin1StringEncoding];
	NSRange rgCheck = [urlContent rangeOfString:@"Sign in failed. Wrong username or password."];
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

- (NSString*)getFirstLoginContent
{
	return _strFirstLoginContent;
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


- (NSString*)loginForStandaloneGadget:(NSString*)domain
{
	NSURLResponse* response;
	NSError* error;
	NSData* dataResponse;
	NSString* urlContent = [[NSString alloc] init];
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
	
	NSString* redirectStr = [NSString stringWithFormat:@"%@%@", domain, [self getExtend:domain]];
	
	NSURL* redirectURL1 = [NSURL URLWithString:redirectStr];
	NSString* checkUrlStr = [NSString stringWithContentsOfURL:redirectURL1 encoding:NSUTF8StringEncoding error:nil];
	if(checkUrlStr == nil) 
	{
		redirectURL1 = nil;
		[redirectURL1 release];
		return @"ERROR";
	}
	

	NSString* loginStr;
	NSHTTPCookieStorage *store = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	
//	NSRange rangeOfPrivate = [redirectStr rangeOfString:@"/classic"];
//	if(rangeOfPrivate.length > 0)
//		loginStr = [[redirectStr substringToIndex:rangeOfPrivate.location] stringByAppendingString:@"/j_security_check"];
//	else
//		loginStr = [redirectStr stringByAppendingString:@"/j_security_check"];
	
	loginStr = @"http://mobile.demo.exoplatform.org/portal/login";
	//Request to login
	NSURL* loginURL = [NSURL URLWithString:loginStr];
	NSMutableURLRequest* loginRequest = [[NSMutableURLRequest alloc] init];	
	[loginRequest setURL:loginURL];
	[loginRequest setTimeoutInterval:60.0];
	[loginRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
	[loginRequest setHTTPShouldHandleCookies:NO];
	
	NSDictionary* postDictionary = [[NSMutableDictionary alloc] initWithCapacity:2];
	[postDictionary setValue:_strUsername forKey:@"username"];
	[postDictionary setValue:_strPassword forKey:@"password"];
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


- (NSMutableArray*)getItemsInDashboard
{
	NSMutableArray* arrDbItems = [[NSMutableArray alloc] init];
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString* domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];	
	
	NSString* strContent = _strFirstLoginContent;
	
	NSRange range1;
	NSRange range2;
	NSRange range3;
	range1 = [strContent rangeOfString:@"DashboardIcon TBIcon"];
	
	if(range1.length <= 0)
		return nil;
	
	strContent = [strContent substringFromIndex:range1.location + range1.length];
	range1 = [strContent rangeOfString:@"TBIcon"];
	
	if(range1.length <= 0)
		return nil;
	
	strContent = [strContent substringToIndex:range1.location];
	
	do 
	{
		range1 = [strContent rangeOfString:@"ItemIcon DefaultPageIcon\" href=\""];
		range2 = [strContent rangeOfString:@"\" >"];
		
		if (range1.length > 0 && range2.length > 0) 
		{
			NSString *gadgetTabUrlStr = [strContent substringWithRange:NSMakeRange(range1.location + range1.length, range2.location - range1.location - range1.length)];
			NSURL *gadgetTabUrl = [NSURL URLWithString:gadgetTabUrlStr];
			
			strContent = [strContent substringFromIndex:range2.location + range2.length];
			range3 = [strContent rangeOfString:@"</a>"];
			
			NSString *gadgetTabName = [strContent substringToIndex:range3.location]; 
			//NSArray* arrTmpGadgetsInItem = [[NSArray alloc] init];
			NSMutableArray* arrTmpGadgetsInItem = [[NSArray alloc] init];
			NSMutableArray* arrTmpStandaloneGadgetsInITem = [[NSArray alloc] init];
			arrTmpGadgetsInItem = [self listOfGadgetsWithURL:[domain stringByAppendingFormat:@"%@", gadgetTabUrlStr]];
			arrTmpStandaloneGadgetsInITem = [self listOfStandaloneGadgetsWithURL:[domain stringByAppendingFormat:@"%@", gadgetTabUrlStr]];
			for (int i = 0; i < [arrTmpGadgetsInItem count]; i++) 
			{
				Gadget* tmpGadget = [arrTmpGadgetsInItem objectAtIndex:i];
				for (int j = 0; j < [arrTmpStandaloneGadgetsInITem count]; j++) 
				{
					StandaloneGadget* tmpStandaloneGadget = [arrTmpStandaloneGadgetsInITem objectAtIndex:j];
					if ([tmpStandaloneGadget._strName isEqualToString:tmpGadget._strName]) 
					{
						tmpGadget._urlContent = tmpStandaloneGadget._urlContent;
						[arrTmpGadgetsInItem replaceObjectAtIndex:i withObject:tmpGadget];
						break;
					}
				}
			}
			
			GateInDbItem* tmpGateInDbItem = [[GateInDbItem alloc] init];
			[tmpGateInDbItem setObjectWithName:gadgetTabName andURL:gadgetTabUrl andGadgets:arrTmpGadgetsInItem];
			[arrDbItems addObject:tmpGateInDbItem];
			
			strContent = [strContent substringFromIndex:range3.location];
			range1 = [strContent rangeOfString:@"ItemIcon DefaultPageIcon\" href=\""];
		}	
	} 
	while (range1.length > 0);
	
	return arrDbItems;
}

-(NSString *)getStringForGadget:(NSString *)gadgetStr startStr:(NSString *)startStr endStr:(NSString *)endStr
{
	NSString *returnValue = @"";
	NSRange range1;
	NSRange range2;
	
	range1 = [gadgetStr rangeOfString:startStr];
	
	if(range1.length > 0)
	{
		NSString *tmpStr = [gadgetStr substringFromIndex:range1.location + range1.length];
		range2 = [tmpStr rangeOfString:endStr];
		if(range2.length > 0)
		{
			returnValue = [tmpStr substringToIndex:range2.location];
		}
	}
	
	return [returnValue retain];
}

- (NSMutableArray*)listOfGadgetsWithURL:(NSString *)url
{
	NSMutableArray* arrTmpGadgets = [[NSMutableArray alloc] init];
	
	NSString* strGadgetName;
	NSString* strGadgetDescription;
	NSURL* urlGadgetContent;
	UIImage* imgGadgetIcon;
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString* domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
	
	NSMutableString* strContent;
	
	NSData *data = [self sendRequestToGetGadget:url];
	strContent = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSRange range1;
	NSRange range2;
	
	range1 = [strContent rangeOfString:@"eXo.gadget.UIGadget.createGadget"];
	if(range1.length <= 0)
		return nil;
	
	do 
	{
		strContent = (NSMutableString *)[strContent substringFromIndex:range1.location + range1.length];
		range2 = [strContent rangeOfString:@"'/eXoGadgetServer/gadgets',"];
		if (range2.length > 0) 
		{
			NSString *tmpStr = [strContent substringToIndex:range2.location + range2.length + 10];
			
			strGadgetName = [self getStringForGadget:tmpStr startStr:@"\"title\":\"" endStr:@"\","]; 
			strGadgetDescription = [self getStringForGadget:tmpStr startStr:@"\"description\":\"" endStr:@"\","];
			NSString *gadgetIconUrl = [self getStringForGadget:tmpStr startStr:@"\"thumbnail\":\"" endStr:@"\","];
			if([gadgetIconUrl isEqualToString:@""])
				imgGadgetIcon = [UIImage imageNamed:@"PortletsIcon.png"];
			else
			{
				imgGadgetIcon = [UIImage imageWithData:[self sendRequest:gadgetIconUrl]];
				if(imgGadgetIcon == nil)
				{	
					NSRange range3 = [gadgetIconUrl rangeOfString:@"://"];
					if(range3.length == 0)
					{
						strContent = (NSMutableString *)[strContent substringFromIndex:range2.location + range2.length];
						range1 = [strContent rangeOfString:@"eXo.gadget.UIGadget.createGadget"];
						continue;
					}
					
					gadgetIconUrl = [gadgetIconUrl substringFromIndex:range3.location + range3.length];
					range3 = [gadgetIconUrl rangeOfString:@"/"];
					gadgetIconUrl = [gadgetIconUrl substringFromIndex:range3.location];
					//gadgetIconUrl = [NSString stringWithFormat:@"%@%@", domain, gadgetIconUrl];		
					NSString* tmpGGIC= [NSString stringWithFormat:@"%@%@", domain, gadgetIconUrl];		
					imgGadgetIcon = [UIImage imageWithData:[self sendRequest:tmpGGIC]];
					if(imgGadgetIcon == nil)
					{
						imgGadgetIcon = [UIImage imageNamed:@"PortletsIcon.png"];
					}	
				}
			}
			
			NSMutableString *gadgetUrl = [[NSMutableString alloc] initWithString:@""];
			[gadgetUrl appendString:domain];
			
			[gadgetUrl appendFormat:@"%@/", [self getStringForGadget:tmpStr startStr:@"'home', '" endStr:@"',"]];
			[gadgetUrl appendFormat:@"ifr?container=default&mid=1&nocache=0&lang=%@&debug=1&st=default", [self getStringForGadget:tmpStr startStr:@"&lang=" endStr:@"\","]];
			
			NSString *token = [NSString stringWithFormat:@":%@", [self getStringForGadget:tmpStr startStr:@"\"default:" endStr:@"\","]];
			token = [token stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
			token = [token stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
			token = [token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
			
			
			[gadgetUrl appendFormat:@"%@&url=", token];
			
			NSString *gadgetXmlFile = [self getStringForGadget:tmpStr startStr:@"\"url\":\"" endStr:@"\","];
			gadgetXmlFile = [gadgetXmlFile stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
			gadgetXmlFile = [gadgetXmlFile stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
			
			[gadgetUrl appendFormat:@"%@", gadgetXmlFile];
			
			urlGadgetContent = [NSURL URLWithString:gadgetUrl];
			
			Gadget* gadget = [[Gadget alloc] init];
			
			[gadget setObjectWithName:strGadgetName description:strGadgetDescription urlContent:urlGadgetContent urlIcon:nil imageIcon:imgGadgetIcon];
			[arrTmpGadgets addObject:gadget];
			
			strContent = (NSMutableString *)[strContent substringFromIndex:range2.location + range2.length];
			range1 = [strContent rangeOfString:@"eXo.gadget.UIGadget.createGadget"];
		}	
		
	} while (range1.length > 0);
	
	return arrTmpGadgets;
}

- (NSMutableArray*)listOfStandaloneGadgetsWithURL:(NSString *)url
{
	NSMutableArray* arrTmpStandaloneGadgets = [[NSMutableArray alloc] init];
	
	NSMutableString* strContent;
	
	NSData *data = [self sendRequestToGetGadget:url];
	strContent = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSRange range1;
	NSRange range2;
	
	NSArray* arrParagraphs = [strContent componentsSeparatedByString:@"<div class=\"UIGadget\""];
	
	for (int i = 1; i < [arrParagraphs count]; i++) 
	{
		NSString* tmpStr1 = [arrParagraphs objectAtIndex:i];
		range1 = [tmpStr1 rangeOfString:@"standalone"];
		if (range1.length > 0) 
		{
			range2 = [tmpStr1 rangeOfString:@"<a style=\"display:none\" href=\""];
			NSString* strStandaloneUrl = @"";
			NSString* strStandaloneName = @"";
			if (range2.length > 0) 
			{
				int mark = 0;
				for (int j = range2.location + range2.length; j < [tmpStr1 length]; j++) 
				{
					if ([tmpStr1 characterAtIndex:j] == '"') 
					{
						mark = j;
						break;
					}
				}
				NSRange range3 = NSMakeRange(range2.location + range2.length, mark - range2.location - range2.length);
				strStandaloneUrl = [tmpStr1 substringWithRange:range3];
			}
			range2 = [tmpStr1 rangeOfString:@"<div class=\"GadgetTitle\" style=\"display: none; float: none; width: auto; margin-right: 75px\">"];
			if (range2.length > 0) 
			{
				int mark = 0;
				for (int j = range2.location + range2.length; j < [tmpStr1 length]; j++) 
				{
					if ([tmpStr1 characterAtIndex:j] == '<') 
					{
						mark = j;
						break;
					}
				}
				NSRange range3 = NSMakeRange(range2.location + range2.length, mark - range2.location - range2.length);
				strStandaloneName = [tmpStr1 substringWithRange:range3];
			}
			
			if ([strStandaloneUrl length] > 0 && [strStandaloneName length] > 0) 
			{
				StandaloneGadget* tmpStandaloneGadget = [[StandaloneGadget alloc] init];
				tmpStandaloneGadget._strName = strStandaloneName;
				tmpStandaloneGadget._urlContent = [NSURL URLWithString:strStandaloneUrl];
				[arrTmpStandaloneGadgets addObject:tmpStandaloneGadget];
			}
		}
	}
	return arrTmpStandaloneGadgets;
}

@end
