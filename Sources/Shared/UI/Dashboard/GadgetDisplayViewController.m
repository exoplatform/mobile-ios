//
//  GadgetDisplayViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 25/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "GadgetDisplayViewController.h"
#import "Gadget.h"
#import "AuthenticateProxy.h"

@implementation GadgetDisplayViewController

@synthesize _url;
@synthesize _webView;
@synthesize _statusLabel;
@synthesize _progressIndicator;

// custom init method to allow URL to be passed
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL 
{
	[super initWithNibName:nibName bundle:nibBundle];
	_url = defaultURL;
	_strBConnectStatus = @"NO";
	[_webView setDelegate:self];
	return self;
}

- (void)viewDidAppear:(BOOL)animated {
	if(_url != nil)
	{
		NSHTTPURLResponse* response;
		NSError* error;
		
		NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
		[request setURL:_url]; 

		
		NSRange rang = [[_url absoluteString] rangeOfString:@"standalone"];
		if (rang.length > 0) 
		{
			_strBConnectStatus = [[AuthenticateProxy sharedInstance] loginForStandaloneGadget:[_url absoluteString]];
		}
        
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		NSUInteger statusCode = [response statusCode];
		
		if(statusCode >= 200 && statusCode < 300)
		{
			[_webView loadRequest:request];
		}
		else
		{
            [_webView loadHTMLString:[NSString stringWithFormat:@"<html><body>%@</body></html>", @"ConnectionTimedOut"] 
                             baseURL:nil];
		}
		
        
        [request release];
        
	}
}

- (void)setUrl:(NSURL*)url
{
	_url = [url retain];
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