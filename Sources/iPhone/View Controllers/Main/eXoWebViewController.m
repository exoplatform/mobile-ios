//
//  eXoWebViewController.m
//  eXoApp
//
//  Created by Tran Hoai Son on 7/13/09.
//  Copyright 2009 home. All rights reserved.
//

#import "eXoWebViewController.h"
#import "CXMLDocument.h"
#import "defines.h"

@implementation eXoWebViewController

@synthesize _url;
@synthesize _webView;
@synthesize _statusLabel;
@synthesize _progressIndicator, _delegate;

// custom init method to allow URL to be passed
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL 
{
	[super initWithNibName:nibName bundle:nibBundle];
	_url = [defaultURL copy];

	return self;
}

// custom init method to allow URL to be passed
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL fileName:(NSString *)fileName
{
	[self initWithNibAndUrl:nibName bundle:nibBundle url:defaultURL]; 

	_fileName = [fileName copy];
    self.title = _fileName;

    
	return self;
}

- (void)viewDidAppear:(BOOL)animated 
{
	NSURLRequest* request;
	if(_url == nil)
	{
		NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
		int selectedLanguage = [[userDefaults objectForKey:EXO_PREFERENCE_LANGUAGE] intValue];
		if(selectedLanguage == 0)
			request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"HowtoUse_EN_iPhone" ofType:@"htm"]]];
		else
			request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"HowtoUse_FR_iPhone" ofType:@"htm"]]];
		
		self.title = @"UserGuide"; //[_delegate._dictLocalize objectForKey:@"UserGuide"];
		[_webView setScalesPageToFit:YES];
		[_webView loadRequest:request];
	}
	else
	{
		request = [[NSURLRequest alloc] initWithURL:_url];
		NSHTTPURLResponse* response;
		NSError* error;
		
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		NSUInteger statusCode = [response statusCode];
		
		if(statusCode >= 200 && statusCode < 300)
		{
			[_webView loadRequest:request];
		}
		else
		{
            [_webView loadHTMLString:[NSString stringWithFormat:@"<html><body>%@</body></html>", 
									  @"ConnectionTimedOut"] baseURL:nil];
            /*
			[_webView loadHTMLString:[NSString stringWithFormat:@"<html><body>%@</body></html>", 
									  [_delegate._dictLocalize objectForKey:@"ConnectionTimedOut"]] baseURL:nil];*/
		}
        [request release];
	}
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
    [_url release];
    [_fileName release];
	
    [super dealloc];
}

@end