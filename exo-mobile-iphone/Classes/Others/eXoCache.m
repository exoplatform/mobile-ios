//
//  eXoCache.m
//  eXoApp
//
//  Created by Tran Hoai Son on 5/20/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import "eXoCache.h"


@implementation eXoCache

+ (NSString*)createCacheDirectoryWithName:(NSString*)name 
{
	NSString *path = [NSHomeDirectory() stringByAppendingString:@"/tmp"];
	[[NSFileManager defaultManager] createDirectoryAtPath:path attributes:nil];
	path = [NSString stringWithFormat:@"%@/%@", path, name];
	[[NSFileManager defaultManager] createDirectoryAtPath:path attributes:nil];
	return [path stringByAppendingString:@"/"];
}

+ (NSString*)createIconCacheDirectory 
{
	return [self createCacheDirectoryWithName:@"icon_cache"];
}

+ (NSString*)createXMLCacheDirectory 
{
	return [self createCacheDirectoryWithName:@"xml_cache"];
}

+ (NSString*)createTextCacheDirectory 
{
	return [self createCacheDirectoryWithName:@"text_backup"];
}

+ (void)saveWithFilename:(NSString*)filename data:(NSData*)data 
{
	[[NSFileManager defaultManager] createFileAtPath:filename contents:data attributes:nil];
}

+ (NSData*)loadWithFilename:(NSString*)filename 
{
	NSFileHandle* fileHandler = [NSFileHandle fileHandleForReadingAtPath:filename];
	NSData *ret = nil;
	if (fileHandler) 
	{
		ret = [fileHandler readDataToEndOfFile];
		[fileHandler closeFile];
	}
	return ret;
}

+ (void)removeAllCachedData 
{
	[[NSFileManager defaultManager] removeItemAtPath:[eXoCache createIconCacheDirectory] error:nil];
	[[NSFileManager defaultManager] removeItemAtPath:[eXoCache createXMLCacheDirectory] error:nil];
	[[NSFileManager defaultManager] removeItemAtPath:[eXoCache createTextCacheDirectory] error:nil];
}
@end
