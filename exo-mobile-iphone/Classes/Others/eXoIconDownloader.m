//
//  eXoIconDownloader.m
//  eXoApp
//
//  Created by Tran Hoai Son on 5/20/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import "eXoIconDownloader.h"


@implementation eXoIconDownloader

- (id)initWithDelegate:(NSObject<eXoIconDownloaderDelegate>*)aDelegate {
	self = [super init];
	delegate = aDelegate;
	[delegate retain];
	return self;
}

- (void) dealloc 
{
	[delegate release];
	[super dealloc];
}

- (void)download:(NSString*)url 
{
	[self requestGET:url];
}

- (void)requestSucceeded 
{
	[delegate iconDownloaderSucceeded:self];
	[self autorelease];
}


- (void)requestFailed:(NSError*)error {
	[delegate iconDownloaderFailed:self];
	[self autorelease];
}
@end
