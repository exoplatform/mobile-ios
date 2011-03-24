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
		

		
		Connection* connection;
		NSRange rang = [[_url absoluteString] rangeOfString:@"standalone"];
		if (rang.length > 0) 
		{
			connection = [[Connection alloc] init];
			_strBConnectStatus = [connection loginForStandaloneGadget:[_url absoluteString]];
            [connection release];
		}

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
        
        [request release];

	}
}

- (void)setUrl:(NSURL*)url
{
	_url = [url retain];
}

- (void)startGadget:(Gadget_iPhone*)gadget
{
	
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
	[_url release];	//Gadget URL
    _url = nil;
    
	[_dictLocalize release];	//Language dictionary
    _dictLocalize = nil;
	
    _delegate = nil;	//main app view controller
	
    [_strBConnectStatus release];	//Network connection status
    _strBConnectStatus = nil;
    
	[_webView release];
    _webView = nil;
    
	[_statusLabel release];
    _statusLabel = nil;
    
	[_progressIndicator release];
    _progressIndicator = nil;
	
    [super dealloc];
}

@end