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
#import "eXoApplicationsViewController.h"

@implementation eXoWebViewController

@synthesize _url;
@synthesize _webView;
@synthesize _statusLabel;
@synthesize _progressIndicator, _delegate;

// custom init method to allow URL to be passed
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL 
{
	[super initWithNibName:nibName bundle:nibBundle];
	_url = defaultURL;

	return self;
}

- (void)viewWillAppear:(BOOL)animated 
{
	NSURLRequest* request;
	if(_url == nil)
	{
		NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
		int selectedLanguage = [[userDefaults objectForKey:EXO_LANGUAGE] intValue];
		if(selectedLanguage == 0)
			request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"HowtoUse-EN" ofType:@"htm"]]];
		else
			request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"HowtoUse-FR" ofType:@"htm"]]];
		
		self.title = [_delegate._dictLocalize objectForKey:@"UserGuide"];
	}
	else
	{
		request = [[NSURLRequest alloc] initWithURL:_url];
		self.title = [_delegate._dictLocalize objectForKey:@"FileViewer"];
	}

	[_webView loadRequest:request];
	//[request release];
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