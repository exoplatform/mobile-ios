//
//  FilesProxy.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 22/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilesProxy.h"
#import "NSString+HTML.h"
#import "eXo_Constants.h"
#import "DataProcess.h"

@implementation FilesProxy


#pragma mark -
#pragma mark Utils method for files

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
	
	NSString* ret = [NSString stringWithCString:tmp encoding:NSASCIIStringEncoding];
	free(tmp);
	
	return ret;
}

+ (NSString*)stringOfAuthorizationHeaderWithUsername:(NSString*)username password:(NSString*)password
{
    NSString* s = @"Basic ";
    NSString* author = [s stringByAppendingString:[self stringEncodedWithBase64:[NSString stringWithFormat:@"%@:%@", username, password]]];	
	return author;
}


#pragma mark -
#pragma NSObject Methods

- (id)init{
    if ((self = [super init])) { 
        _authenticateProxy = [[AuthenticateProxy alloc] init];
    }
    return self;
}


- (void)dealloc {

    [_authenticateProxy release];
    _authenticateProxy = nil;
    
    [super dealloc];
}




#pragma mark -
#pragma mark Files retrieving methods


- (File *)initialFileForRootDirectory
{
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
    NSString* username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
    NSString* urlStr = [domain stringByAppendingString:@"/rest/private/jcr/repository/collaboration/Users/"];
    urlStr = [urlStr stringByAppendingString:username];
    
    return [[File alloc] initWithUrlStr:urlStr fileName:username];
}

- (NSArray*)getPersonalDriveContent:(File *)file
{
	
	NSData* dataReply = [_authenticateProxy sendRequestWithAuthorization:file.urlStr];
	NSString* strData = [[[NSString alloc] initWithData:dataReply encoding:NSUTF8StringEncoding] autorelease];
	
	NSMutableArray* arrDicts = [[NSMutableArray alloc] init];
	
	NSRange range1;
	NSRange range2;
	do 
	{
		range1 = [strData rangeOfString:@"alt=\"\"> "];
		range2 = [strData rangeOfString:@"</a>"];
		
		if(range1.length > 0)
		{
			NSString *fileName = [strData substringWithRange:NSMakeRange(range1.length + range1.location, 
																		 range2.location - range1.location - range1.length)];
			fileName = [fileName stringByDecodingHTMLEntities];
			if(![fileName isEqualToString:@".."])
			{
				NSRange range3 = [strData rangeOfString:@"<a href=\""];
				NSRange range4 = [strData rangeOfString:@"\"><img src"];
				NSString *urlStr = [strData substringWithRange:NSMakeRange(range3.length + range3.location, 
																		   range4.location - range3.location - range3.length)];
				File *file2 = [[File alloc] initWithUrlStr:urlStr fileName:fileName];
				[arrDicts addObject:file2];
                [file2 release];
			}
            
		}
		if(range2.length > 0)
			strData = [strData substringFromIndex:range2.location + range2.length];
	} while (range1.length > 0);
	
    
	return (NSArray *)arrDicts;
}



-(NSString *)fileAction:(NSString *)protocol source:(NSString *)source destination:(NSString *)destination data:(NSData *)data
{	
	source = [DataProcess encodeUrl:source];
	destination = [DataProcess encodeUrl:destination];
	
	NSRange range;
	range = [source rangeOfString:@"http://"];
	if(range.length == 0)
		source = [source stringByReplacingOccurrencesOfString:@":/" withString:@"://"];
	range = [destination rangeOfString:@"http://"];
	if(range.length == 0)
		destination = [destination stringByReplacingOccurrencesOfString:@":/" withString:@"://"];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
	NSString *password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
	
	NSHTTPURLResponse* response;
	NSError* error;
    
    //Message for error
    NSString *errorMessage;
    
	
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
	[request setURL:[NSURL URLWithString:source]]; 
	
	if([protocol isEqualToString:kFileProtocolForDelete])
	{
		[request setHTTPMethod:@"DELETE"];
		
	}else if([protocol isEqualToString:kFileProtocolForUpload])
	{
		[request setHTTPMethod:@"PUT"];
		[request setValue:@"T" forHTTPHeaderField:@"Overwrite"];
		[request setHTTPBody:data];
		
	}
	else if([protocol isEqualToString:kFileProtocolForCopy])
	{
		[request setHTTPMethod:@"COPY"];
		[request setValue:destination forHTTPHeaderField:@"Destination"];
		[request setValue:@"T" forHTTPHeaderField:@"Overwrite"];
        
	}else
	{
		[request setHTTPMethod:kFileProtocolForMove];
		[request setValue:destination forHTTPHeaderField:@"Destination"];
		[request setValue:@"T" forHTTPHeaderField:@"Overwrite"];
		
		if([source isEqualToString:destination]) {
			
            //Put the label into the error
            // TODO Localize this label
            errorMessage = [NSString stringWithFormat:@"Can not move file to its location"];
             
            [request release];
            
			return errorMessage;
		}
	}
	
	NSString *s = @"Basic ";
    NSString *author = [s stringByAppendingString: [FilesProxy stringEncodedWithBase64:[NSString stringWithFormat:@"%@:%@", username, password]]];
	[request setValue:author forHTTPHeaderField:@"Authorization"];
	
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [request release];
    
	NSUInteger statusCode = [response statusCode];
	if(!(statusCode >= 200 && statusCode < 300))
	{
        //Put the label into the error
        // TODO Localize this label
        errorMessage = [NSString stringWithFormat:@"Can not transfer file"];
		        
    }
    
    
	return nil;
}


@end
