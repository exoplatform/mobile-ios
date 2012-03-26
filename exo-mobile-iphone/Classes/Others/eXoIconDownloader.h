//
//  eXoIconDownloader.h
//  eXoApp
//
//  Created by Tran Hoai Son on 5/20/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "httpClient.h"

@class eXoIconDownloader;

@protocol eXoIconDownloaderDelegate
- (void)iconDownloaderSucceeded:(eXoIconDownloader*)sender;
- (void)iconDownloaderFailed:(eXoIconDownloader*)sender;
@end

@interface eXoIconDownloader : httpClient {
	NSObject<eXoIconDownloaderDelegate> *delegate;
}

- (id)initWithDelegate:(NSObject<eXoIconDownloaderDelegate>*)delegate;
- (void)download:(NSString*)url;

@end
