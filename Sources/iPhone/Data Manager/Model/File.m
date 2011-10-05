//
//  File.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 22/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "File.h"
#import "FilesProxy.h"
#import "AuthenticateProxy.h"
#import "eXo_Constants.h"

@implementation File

@synthesize fileName=_fileName, urlStr=_urlStr, contentType=_contentType, isFolder=_isFolder;


+ (NSString *)fileType:(NSString *)fileName
{	
	if([fileName length] < 5)
		return @"unknownFileIcon.png";
	else
	{
		NSRange range = NSMakeRange([fileName length] - 4, 4);
		NSString *tmp = [fileName substringWithRange:range];
		tmp = [tmp lowercaseString];
		
		if([tmp isEqualToString:@".png"] || [tmp isEqualToString:@".jpg"] || [tmp isEqualToString:@".jpeg"] || 
		   [tmp isEqualToString:@".gif"] || [tmp isEqualToString:@".psd"] || [tmp isEqualToString:@".tiff"] ||
		   [tmp isEqualToString:@".bmp"] || [tmp isEqualToString:@".pict"])
		{	
			return @"DocumentIconForImage.png";
		}	
		if([tmp isEqualToString:@".rtf"] || [tmp isEqualToString:@".rtfd"] || [tmp isEqualToString:@".txt"])
		{	
			return @"DocumentIconForTxt.png";
		}
        if([tmp isEqualToString:@".mdb"])
		{	
			return @"DocumentIconForMdb.png";
		}
		if([tmp isEqualToString:@".pdf"])
		{	
			return @"DocumentIconForPdf.png";
		}
		if([tmp isEqualToString:@".doc"])
		{	
			return @"DocumentIconForWord.png";
		}
		if([tmp isEqualToString:@".ppt"])
		{	
			return @"DocumentIconForPpt.png";
		}
		if([tmp isEqualToString:@".xls"])
		{	
			return @"DocumentIconForXls.png";
		}
		if([tmp isEqualToString:@".swf"])
		{	
			return @"DocumentIconForSwf.png";
		}
		if([tmp isEqualToString:@".mp3"] || [tmp isEqualToString:@".aac"] || [tmp isEqualToString:@".wav"])
		{	
			return @"DocumentIconForMusic.png";
		}	
		if([tmp isEqualToString:@".mov"])
		{	
			return @"DocumentIconForVideo.png";
		}
		return @"DocumentIconForUnknown.png";
	}
}



-(BOOL)isFolder:(NSString *)urlStr
{
	_contentType = [[NSString alloc] initWithString:@""];
	
	urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSString *username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
	NSString *password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
	
	BOOL returnValue = FALSE;
	
	NSURL* url = [NSURL URLWithString:[NSString stringWithString:urlStr]];
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
	[request setURL:url];
	[request setTimeoutInterval:60.0];
	[request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
	
	[request setHTTPMethod:@"PROPFIND"];
	
	[request setHTTPBody: [[NSString stringWithString: @"<?xml version=\"1.0\" encoding=\"utf-8\" ?><D:propfind xmlns:D=\"DAV:\">"
							"<D:prop><D:getcontenttype/></D:prop></D:propfind>"] dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    
	[request setValue:[[AuthenticateProxy sharedInstance] stringOfAuthorizationHeaderWithUsername:username password:password] forHTTPHeaderField:@"Authorization"];
	
	NSData *dataReply = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *responseStr = [[NSString alloc] initWithData:dataReply encoding:NSUTF8StringEncoding];
    [request release];
    
    
	NSRange dirRange = [responseStr rangeOfString:@"<D:getcontenttype/></D:prop>"];
    
	if(dirRange.length > 0)
	{	
		returnValue = TRUE;
        
	}
	else
	{
		NSRange contentTypeRange1 = [responseStr rangeOfString:@"<D:getcontenttype>"];
		NSRange contentTypeRange2 = [responseStr rangeOfString:@"</D:getcontenttype>"];
		if(contentTypeRange1.length > 0 && contentTypeRange2.length > 0)
            _contentType = [responseStr substringWithRange:
                            NSMakeRange(contentTypeRange1.location + contentTypeRange1.length, 
                                        contentTypeRange2.location - contentTypeRange1.location - contentTypeRange1.length)];
	}
    
    [responseStr release];
	
	return returnValue;
}

-(NSString *)convertPathToUrlStr:(NSString *)path
{
	return [path stringByReplacingOccurrencesOfString:@":/" withString:@"://"];
}

-(id)initWithUrlStr:(NSString *)urlStr fileName:(NSString *)fileName
{
    self = [super init];
	if(self)
	{
		_fileName = [[NSString alloc] initWithString:fileName];
		_urlStr = [[NSString alloc] initWithString:urlStr];
		_isFolder = [self isFolder:urlStr];
        
	}
	
	return self;
}





- (void)dealloc {
    [_contentType release];
    _contentType = nil;
    
    [_fileName release];
    _fileName = nil;
    
    [_urlStr release];
    _urlStr = nil;
    
    [super dealloc];
}


@end
