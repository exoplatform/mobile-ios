//
//  FilesProxy.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 22/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilesProxy.h"
#import "NSString+HTML.h"
#import "DataProcess.h"
#import "Reachability.h"
#import "AuthenticateProxy.h"
#import "TouchXML.h"
#import "defines.h"
#import "ApplicationPreferencesManager.h"
#import "UserPreferencesManager.h"

@interface FilesProxy ()

- (NSData *)sendSynchronizedHTTPRequest:(NSMutableURLRequest *)request;

@end

@implementation FilesProxy

@synthesize _isWorkingWithMultipeUserLevel, _strUserRepository;

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

+ (NSString *)urlForFileAction:(NSString *)url
{	
	NSRange range;
	range = [url rangeOfString:@"http://"];
	if(range.length == 0)
		url = [url stringByReplacingOccurrencesOfString:@":/" withString:@"://"];
	
	return url;
	
}

- (NSData *)sendSynchronizedHTTPRequest:(NSMutableURLRequest *)request {
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorUserCancelledAuthentication) {
        // re-authenticate when timeout
        NSString *username = [[UserPreferencesManager sharedInstance] username];
        NSString *password = [[UserPreferencesManager sharedInstance] password];
        CFHTTPMessageRef dummyRequest = CFHTTPMessageCreateRequest(kCFAllocatorDefault, (CFStringRef)request.HTTPMethod, (CFURLRef)request.URL, kCFHTTPVersion1_1);
        CFHTTPMessageAddAuthentication(dummyRequest, nil, (CFStringRef)username, (CFStringRef)password,kCFHTTPAuthenticationSchemeBasic, FALSE);
        CFStringRef authorizationString = CFHTTPMessageCopyHeaderFieldValue(dummyRequest, CFSTR("Authorization"));
        [request setValue:(NSString *)authorizationString forHTTPHeaderField:@"Authorization"];
        CFRelease(dummyRequest);
        CFRelease(authorizationString);
        data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    }
    if (error) {
        LogDebug(@"HTTP request failed: %@", error);
    }
    return data;
}

#pragma mark -
#pragma NSObject Methods

+ (FilesProxy *)sharedInstance
{
	static FilesProxy *sharedInstance;
	@synchronized(self)
	{
		if(!sharedInstance)
		{
			sharedInstance = [[FilesProxy alloc] init];
		}
		return sharedInstance;
	}
    
	return sharedInstance;
}

- (id)init{
    if ((self = [super init])) { 
    }
    return self;
}


- (void)dealloc {
    [super dealloc];
}


- (void)calculateAbsPath:(NSString *)relativePath forItem:(File *)item {
    NSString *domain = [[ApplicationPreferencesManager sharedInstance] selectedDomain];
    item.path = [NSString stringWithFormat:@"%@%@%@/%@%@", domain, DOCUMENT_JCR_PATH_REST, [ApplicationPreferencesManager sharedInstance].currentRepository, item.workspaceName, relativePath];
}

#pragma mark -
#pragma mark Files retrieving methods

- (NSArray*)getDrives:(NSString*)driveName {
    
    NSString *domain = [ApplicationPreferencesManager sharedInstance].selectedDomain;
    BOOL showPrivate = [UserPreferencesManager sharedInstance].showPrivateDrive;
    

    // Initialize the array of files
    NSMutableArray *folderArray = [[[NSMutableArray alloc] init] autorelease];
	
    // Create URL for getting data
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@%@%@%@", domain, DOCUMENT_DRIVE_PATH_REST, driveName, DOCUMENT_DRIVE_SHOW_PRIVATE_OPT, showPrivate ? @"true" : @"false"]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    NSData *data = [self sendSynchronizedHTTPRequest:request];
    [request release];
    
    // Create a new parser object based on the TouchXML "CXMLDocument" class
    CXMLDocument *parser = [[[CXMLDocument alloc] initWithData:data options:0 error:nil] autorelease];
	
    // Create a new Array object to be used with the looping of the results from the parser
    NSArray *resultNodes = NULL;
	
    // Set the resultNodes Array to contain an object for every instance of an  node file/folder data
    resultNodes = [parser nodesForXPath:@"//Folder" error:nil];
	
    // Loop through the resultNodes to access each items actual data
    for (CXMLElement *resultElement in resultNodes) {
        
        File *file = [[File alloc] init];
        file.name = [[resultElement attributeForName:@"name"] stringValue];
        file.workspaceName = [[resultElement attributeForName:@"workspaceName"] stringValue];
        file.driveName = file.name;
        file.currentFolder = [[resultElement attributeForName:@"currentFolder"] stringValue];
        if(file.currentFolder == nil)
            file.currentFolder = @"";
        file.isFolder = YES;
		
        // Add the file to the global Array so that the view can access it.
        [folderArray addObject:file];
        [file release];
    }

    return folderArray;
}

- (NSArray*)getContentOfFolder:(File *)file {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
    
    // Initialize the array of files
    NSMutableArray *folderArray = [[[NSMutableArray alloc] init] autorelease];
	
    // Create URL for getting data
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", domain, DOCUMENT_FILE_PATH_REST, file.driveName, DOCUMENT_WORKSPACE_NAME, file.workspaceName, DOCUMENT_CURRENT_FOLDER, file.currentFolder];
    NSURL *url = [NSURL URLWithString: [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
    // Create a new parser object based on the TouchXML "CXMLDocument" class
    CXMLDocument *parser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
	
    // Create a new Array object to be used with the looping of the results from the parser
    NSArray *resultNodes = NULL;
	
    // MOB-1253 update values for the folder.
    CXMLElement *folderElm = [[parser nodesForXPath:@"//Folder" error:nil] objectAtIndex:0];
    file.canRemove = [[[folderElm attributeForName:@"canRemove"] stringValue] isEqualToString:@"true"];
    file.canAddChild = [[[folderElm attributeForName:@"canAddChild"] stringValue] isEqualToString:@"true"];
    file.hasChild = [[[folderElm attributeForName:@"hasChild"] stringValue] isEqualToString:@"true"];
    // MOB-1117 Update the folder path if it's unavailable. This case occurs when the folder is a drive and its path is not provided by other API methods before.
    [self calculateAbsPath:[[folderElm attributeForName:@"path"] stringValue] forItem:file];
    // -----
    
    // Set the resultNodes Array to contain an object for every instance of an  node file/folder data
    resultNodes = [parser nodesForXPath:@"//Folder/Folders/Folder" error:nil];
	
    // Loop through the resultNodes to access each items actual data
    for (CXMLElement *resultElement in resultNodes) {
        
        File *file = [[File alloc] init];
        file.name = [[resultElement attributeForName:@"name"] stringValue];
        file.workspaceName = [[resultElement attributeForName:@"workspaceName"] stringValue];
        file.driveName = [[resultElement attributeForName:@"driveName"] stringValue];
        file.currentFolder = [[resultElement attributeForName:@"currentFolder"] stringValue];
        file.isFolder = YES;
        file.canAddChild = [[[resultElement attributeForName:@"canAddChild"] stringValue] isEqualToString:@"true"];
        file.canRemove = [[[resultElement attributeForName:@"canRemove"] stringValue] isEqualToString:@"true"];
        [self calculateAbsPath:[[resultElement attributeForName:@"path"] stringValue] forItem:file];
        // Add the file to the global Array so that the view can access it.
        [folderArray addObject:file];
        [file release];
    }
    
    resultNodes = [parser nodesForXPath:@"//Folder/Files/File" error:nil];
	
    // Loop through the resultNodes to access each items actual data
    for (CXMLElement *resultElement in resultNodes) {
        
        File *file = [[File alloc] init];
        file.name = [[resultElement attributeForName:@"name"] stringValue];
        file.workspaceName = [[resultElement attributeForName:@"workspaceName"] stringValue];
        file.driveName = [[resultElement attributeForName:@"driveName"] stringValue];
        file.currentFolder = [[resultElement attributeForName:@"currentFolder"] stringValue];
        file.isFolder = NO;
        [self calculateAbsPath:[[resultElement attributeForName:@"path"] stringValue] forItem:file];
        file.nodeType = [[resultElement attributeForName:@"nodeType"] stringValue];
		file.canRemove = [[[resultElement attributeForName:@"canRemove"] stringValue] isEqualToString:@"true"]; 
        // Add the file to the global Array so that the view can access it.
        [folderArray addObject:file];
        [file release];
    }
    
    return folderArray; 
    
}

- (void)creatUserRepositoryHomeUrl
{
    ApplicationPreferencesManager *serverPM = [ApplicationPreferencesManager sharedInstance];
    
    NSString *urlForUserRepo = [NSString stringWithFormat:@"%@%@%@/%@%@", serverPM.selectedDomain, DOCUMENT_JCR_PATH_REST, serverPM.currentRepository, serverPM.defaultWorkspace, serverPM.userHomeJcrPath];
    
    self._strUserRepository = [NSString stringWithString:urlForUserRepo];    
}

- (void)sendImageInBackgroundForDirectory:(NSString *)directory data:(NSData *)imageData
{
    [self fileAction:kFileProtocolForUpload source:directory destination:nil data:imageData];
}

-(NSString *)fileAction:(NSString *)protocol source:(NSString *)source destination:(NSString *)destination data:(NSData *)data
{	
    NSAutoreleasePool *pool =  [[NSAutoreleasePool alloc] init];

    
	source = [source stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	destination = [destination stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
    NSString *username = [[UserPreferencesManager sharedInstance] username];
    NSString *password = [[UserPreferencesManager sharedInstance] password];
	
	NSHTTPURLResponse* response = nil;
	NSError* error = nil;
    
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
    if([protocol isEqualToString:@"MKCOL"])
	{
		[request setHTTPMethod:@"MKCOL"];
	}
	else if([protocol isEqualToString:kFileProtocolForCopy])
	{
		[request setHTTPMethod:@"COPY"];
		[request setValue:destination forHTTPHeaderField:@"Destination"];
		[request setValue:@"T" forHTTPHeaderField:@"Overwrite"];
        
	}else if ([protocol isEqualToString:kFileProtocolForMove])
	{
		[request setHTTPMethod:kFileProtocolForMove];
		[request setValue:destination forHTTPHeaderField:@"Destination"];
		[request setValue:@"T" forHTTPHeaderField:@"Overwrite"];
		
		if([source isEqualToString:destination]) {
			
            //Put the label into the error
            // TODO Localize this label
            errorMessage = [NSString stringWithFormat:@"Cannot move file to its location"];
             
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
        errorMessage = [NSString stringWithFormat:@"Cannot transfer file"];
        
        return errorMessage;
		        
    }
    
    [pool release];
    
    
	return nil;
}

-(BOOL)createNewFolderWithURL:(NSString *)strUrl folderName:(NSString *)name
{
    BOOL returnValue = NO;
    
    NSURL *url = nil;
    
    if(strUrl)
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", strUrl, name]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", _strUserRepository, name]];
    
    BOOL isExistedUrl = [self isExistedUrl:[NSString stringWithFormat:@"%@/%@", strUrl, name]];
    
    if(isExistedUrl)
    {
        returnValue = YES; 
    }
    else
    {
        NSHTTPURLResponse* response;
        NSError* error;
        
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
        [request setURL:url];
        
        [request setHTTPMethod:@"MKCOL"];
        
        NSString *username = [[UserPreferencesManager sharedInstance] username];
        NSString *password = [[UserPreferencesManager sharedInstance] password];
        
        NSString *s = @"Basic ";
        NSString *author = [s stringByAppendingString: [FilesProxy stringEncodedWithBase64:[NSString stringWithFormat:@"%@:%@", username, password]]];
        [request setValue:author forHTTPHeaderField:@"Authorization"];
        
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];    
        [request release];
        
        NSUInteger statusCode = [response statusCode];
        if(statusCode >= 200 && statusCode < 300)
        {
            // TODO Localize this label
            returnValue = YES;
            
        }  
        
    }
    
	return returnValue;
}

-(BOOL)isExistedUrl:(NSString *)strUrl
{
    
    BOOL returnValue = NO;
    
    returnValue = [[AuthenticateProxy sharedInstance] isReachabilityURL:strUrl userName:nil password:nil];
    
    return returnValue;
    
}

@end
