//
//  eXoIconRepository.h
//  eXoApp
//
//  Created by Tran Hoai Son on 5/20/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eXoIconDownloader.h"

@class eXoIconContainer;

@protocol eXoIconDownloadDelegate
- (void) finishedToGetIcon:(eXoIconContainer*)sender;
- (void) failedToGetIcon:(eXoIconContainer*)sender;
@end

//=============================================================
@interface eXoIconContainer : NSObject <eXoIconDownloaderDelegate>
{
	UIImage *iconImage;
	NSMutableArray *delegates;
	NSString *url;
	BOOL downloading;
}

@property (readonly) UIImage *iconImage;

- (BOOL)requestForURL:(NSString*)url delegate:(NSObject<eXoIconDownloadDelegate>*)delegate;
+ (NSData*)readFromCacheFileForURL:(NSString*)url;
@end

//=============================================================
@interface eXoIconRepository : NSObject {
    NSMutableDictionary *urlToContainer;
	NSString *iconCacheRootPath;
}

@property (readonly) NSString *iconCacheRootPath;

+ (eXoIconRepository*) instance;
+ (UIImage*) defaultIcon;

- (UIImage*)imageForURL:(NSString*)url delegate:(NSObject<eXoIconDownloadDelegate>*)delegate;
@end
