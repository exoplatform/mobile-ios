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


+ (NSString *)fileType:(NSString *)type
{	
    NSString* strIconFileName = @"unknownFileIcon.png";
    if (type != nil || type.length > 0) {
        if (([type rangeOfString:@"image"]).length > 0)
            strIconFileName = @"DocumentIconForImage.png";
        else if (([type rangeOfString:@"video"]).length > 0)
            strIconFileName = @"DocumentIconForVideo.png";
        else if (([type rangeOfString:@"audio"]).length > 0)
            strIconFileName = @"DocumentIconForMusic.png";
        else if (([type rangeOfString:@"application/msword"]).length > 0)
            strIconFileName = @"DocumentIconForWord.png";
        else if (([type rangeOfString:@"application/pdf"]).length > 0)
            strIconFileName = @"DocumentIconForPdf.png";
        else if (([type rangeOfString:@"application/xls"]).length > 0)
            strIconFileName = @"DocumentIconForXls.png";
        else if (([type rangeOfString:@"application/vnd.ms-powerpoint"]).length > 0)
            strIconFileName = @"DocumentIconForPpt.png";
        else if (([type rangeOfString:@"text"]).length > 0)
            strIconFileName = @"DocumentIconForTxt.png";
    } else
        strIconFileName = @"unknownFileIcon.png";
    
    return strIconFileName;

}



-(BOOL)isFolder:(NSString *)urlStr
{
	self.contentType = [[NSString alloc] initWithString:@"text/html"];
	
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
            self.contentType = [responseStr substringWithRange:
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
