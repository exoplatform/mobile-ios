//
//  GadgetDisplayViewController.m
//  eXoApp
//
//  Created by Tran Hoai Son on 7/13/09.
//  Copyright 2009 home. All rights reserved.
//

#import "GadgetDisplayViewController.h"
#import "CXMLDocument.h"
#import "defines.h"
#import "eXoApplicationsViewController.h"
#import "Gadget_iPhone.h"
#import "httpClient.h"
#import "Connection.h"

@implementation GadgetDisplayViewController

@synthesize _url;
@synthesize _webView;
@synthesize _statusLabel;
@synthesize _progressIndicator, _delegate;

// custom init method to allow URL to be passed
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL 
{
	[super initWithNibName:nibName bundle:nibBundle];
	_url = defaultURL;
	_strBConnectStatus = @"NO";
	[_webView setDelegate:self];
	return self;
}

- (void)viewWillAppear:(BOOL)animated 
{
	if(_url != nil)
	{
		NSHTTPURLResponse* response;
		NSError* error;
		
		NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
		[request setURL:_url]; 
		
		
//		NSData* dataResponse;	
//		NSURL* url = _url;
//		request = [[NSMutableURLRequest alloc] init];	
//		
//		[request setURL:url];
//		[request setTimeoutInterval:60.0];
//		[request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
//		[request setHTTPMethod:@"GET"];
//		dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//		
//		NSString* urlContent = [[NSMutableString alloc] initWithData:dataResponse encoding:NSISOLatin1StringEncoding];
//		//[_webView loadHTMLString:urlContent baseURL:_url];
//		
//		int a = 1;
		
//		Connection* connection;
//		NSRange rang = [[_url absoluteString] rangeOfString:@"standalone"];
//		if (rang.length > 0) 
//		{
//			connection = [[Connection alloc] init];
//			_strBConnectStatus = [connection loginForStandaloneGadget:[_url absoluteString]];
//		}
//		
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		NSUInteger statusCode = [response statusCode];
		
		if(statusCode >= 200 && statusCode < 300)
		{
			[_webView loadRequest:request];
		}
		else
		{
			[_webView loadHTMLString:[NSString stringWithFormat:@"<html><body>%@</body></html>", 
									  [_delegate._dictLocalize objectForKey:@"ConnectionTimedOut"]] baseURL:nil];
		}
//		[connection release];
	}
}

- (void)setUrl:(NSURL*)url
{
	_url = [url retain];
}

- (void)startGadget:(Gadget_iPhone*)gadget
{
//	if(_url != nil)
//	{
//		NSHTTPURLResponse* response;
//		NSError* error;
//		
//		NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
//		[request setURL:[gadget urlContent]]; 
//		
//		if (![_strBConnectStatus isEqualToString:@"YES"]) 
//		{
//			_strBConnectStatus = [httpClient loginForStandaloneGadget:[[gadget urlContent] absoluteString]];
//		}
//		
//		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//		NSUInteger statusCode = [response statusCode];
//		
//		if(statusCode >= 200 && statusCode < 300)
//		{
//			[_webView loadRequest:request];
//		}
//		else
//		{
//			[_webView loadHTMLString:[NSString stringWithFormat:@"<html><body>%@</body></html>", 
//									  [_delegate._dictLocalize objectForKey:@"ConnectionTimedOut"]] baseURL:nil];
//		}
//	}
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
	_statusLabel.text = @"";
	[_progressIndicator stopAnimating];
}

// Stop loading animation
- (void)webViewDidFinishLoad:(UIWebView *)aWebView 
{
	_statusLabel.text = @"";
	[_progressIndicator stopAnimating];
}

// Start loading animation
- (void)webViewDidStartLoad:(UIWebView *)webView 
{
	_statusLabel.text = @"Loading...";
	[_progressIndicator startAnimating];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc 
{
	[_webView release];
	[_statusLabel release];
	[_progressIndicator release];
	
    [super dealloc];
}

@end