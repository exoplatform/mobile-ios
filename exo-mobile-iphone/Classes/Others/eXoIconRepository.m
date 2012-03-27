//
//  eXoIconRepository.m
//  eXoApp
//
//  Created by Tran Hoai Son on 5/20/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import "eXoIconRepository.h"
#import "eXoCache.h"
#import <CommonCrypto/CommonDigest.h>

static UIImage *default_icon = nil;
static eXoIconRepository *_instance = nil;

@implementation eXoIconContainer

@synthesize iconImage;

+ (NSString*)md5:(NSString*) str 
{
	const char *cStr = [str UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, strlen(cStr), result );
	NSString* tmpStr = [NSString stringWithFormat: 
						@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
						result[0], result[1],
						result[2], result[3],
						result[4], result[5],
						result[6], result[7],
						result[8], result[9],
						result[10], result[11],
						result[12], result[13],
						result[14], result[15]];
	return tmpStr;
}


- (id)init {
	self = [super init];
	delegates = [[NSMutableArray alloc] init];
	return self;
}

+ (NSString*)cacheFilenameForURL:(NSString*)url 
{
	NSString* tmpStr = [[eXoIconRepository instance].iconCacheRootPath stringByAppendingString:[eXoIconContainer md5:url]];
	return tmpStr;
}

+ (void)writeAsCacheFileForURL:(NSString*)url data:(NSData*)data 
{
	[eXoCache saveWithFilename:[eXoIconContainer cacheFilenameForURL:url] data:data];
}

+ (NSData*)readFromCacheFileForURL:(NSString*)url 
{
	NSString* tmpStr = [eXoIconContainer cacheFilenameForURL:url];
	NSData* tmpData = [eXoCache loadWithFilename:tmpStr];
	return tmpData;
}

- (void)dealloc {
	[iconImage release];
	[delegates release];
	[url release];
	[super dealloc];
}

- (BOOL)requestForURL:(NSString*)aUrl delegate:(NSObject<eXoIconDownloadDelegate>*)delegate 
{
	NSData *cached = [eXoIconContainer readFromCacheFileForURL:aUrl];
	if (cached) 
	{
		[iconImage release];
		iconImage = [[UIImage alloc] initWithData:cached];
		return YES;
	} 
	else 
	{
		if (!downloading) 
		{
			downloading = YES;
			[url release];
			url = aUrl;
			[url retain];
			eXoIconDownloader *downloader = [[eXoIconDownloader alloc] initWithDelegate:self];
			[downloader download:aUrl];
		}
		[delegates addObject:delegate];
	}
	return FALSE;
}

- (void)iconDownloaderSucceeded:(eXoIconDownloader*)sender 
{
	[iconImage release];
	iconImage = [[UIImage alloc] initWithData:sender._receivedData];
	[eXoIconContainer writeAsCacheFileForURL:url data:sender._receivedData];

	[url release];
	url = nil;
	downloading = NO;
	
	for (NSObject<eXoIconDownloadDelegate>* d in delegates) 
	{
		[d finishedToGetIcon:self];
	}
	[delegates removeAllObjects];
}

- (void)iconDownloaderFailed:(eXoIconDownloader*)sender 
{
	[url release];
	url = nil;
	downloading = NO;
	
	for (NSObject<eXoIconDownloadDelegate>* d in delegates) 
	{
		[d failedToGetIcon:self];
	}
	[delegates removeAllObjects];
}

@end


//=============================================================
@implementation eXoIconRepository

@synthesize iconCacheRootPath;

+ (eXoIconRepository*) instance 
{
    @synchronized (self) 
	{
        if (!_instance) 
		{
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

+ (UIImage*)defaultIcon 
{
	if (default_icon == nil) 
	{
		default_icon = [UIImage imageNamed:@"default_icon.png"];
	}
	return default_icon;
}

- (id) init 
{
	self = [super init];
    urlToContainer = [[NSMutableDictionary alloc] initWithCapacity:100];
	iconCacheRootPath = [eXoCache createIconCacheDirectory];
	[iconCacheRootPath retain];
    return self;
}

- (void) dealloc 
{
	[urlToContainer release];
	[iconCacheRootPath release];
	[super dealloc];
}

- (UIImage*)imageForURL:(NSString*)url delegate:(NSObject<eXoIconDownloadDelegate>*)delegate 
{
	if(url)
	{
		eXoIconContainer *container = [urlToContainer objectForKey:url];
		if (!container) 
		{
			container = [[eXoIconContainer alloc] init];
			[urlToContainer setObject:container forKey:url];
			[container release];
		}
		if (container.iconImage || [container requestForURL:url delegate:delegate]) 
		{
			return container.iconImage;
		}
	}
	return nil;
}

@end
