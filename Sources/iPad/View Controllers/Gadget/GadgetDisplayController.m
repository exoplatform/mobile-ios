//
//  GadgetDisplayController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/14/10.
//  Copyright 2010 home. All rights reserved.
//

#import "GadgetDisplayController.h"
#import "MainViewController.h"
#import "Gadget_iPad.h"
#import "Connection.h"

@implementation GadgetDisplayController

@synthesize _wvGadgetDisplay;
@synthesize _actiLoading;
@synthesize _lbStatus;
@synthesize _btnLeftEdgeNavigation;
@synthesize _btnRightEdgeNavigation;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		// Custom initialization
		_strBConnectStatus = @"NO";
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	[super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	_wvGadgetDisplay.userInteractionEnabled = YES;
	_wvGadgetDisplay.scalesPageToFit = YES;
	[self localize];
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
    _delegate = nil;
    
    [_dictLocalize release];
    _dictLocalize = nil;
    
    [_nvTitle release];
    _nvTitle = nil;
    
    [_wvGadgetDisplay release];
    _wvGadgetDisplay = nil;
    
    [_actiLoading release];
    _actiLoading = nil;
    
    [_lbStatus release];
    _lbStatus = nil;
    
    [_btnLeftEdgeNavigation release];
    _btnLeftEdgeNavigation = nil;
    
    [_btnRightEdgeNavigation release];
    _btnRightEdgeNavigation = nil;
    
    [_strBConnectStatus release];
    _strBConnectStatus = nil;
    
    [super dealloc];
}


- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
}

- (void)localize
{
	
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
	_lbStatus.text = @"";
	[_actiLoading stopAnimating];
	[_actiLoading setHidden:YES];
}

// Stop loading animation
- (void)webViewDidFinishLoad:(UIWebView *)aWebView 
{
	_lbStatus.text = @"";
	[_actiLoading stopAnimating];
	[_actiLoading setHidden:YES];
}

// Start loading animation
- (void)webViewDidStartLoad:(UIWebView *)webView 
{
	_lbStatus.text = @"Loading...";
	[_actiLoading setHidden:NO];
	[_actiLoading startAnimating];
}



- (void)startGadget:(Gadget_iPad*)gadget
{
	[_wvGadgetDisplay  setDelegate:self];
	_nvTitle.topItem.title = [gadget name];
	
	NSHTTPURLResponse* response;
	NSError* error;
	
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
	[request setURL:[gadget urlContent]]; 
	
	NSRange rang = [[[gadget urlContent] absoluteString] rangeOfString:@"standalone"];
	if (rang.length > 0) 
	{
		_strBConnectStatus = [[_delegate getConnection] loginForStandaloneGadget:[[gadget urlContent] absoluteString]];
	}
	
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSUInteger statusCode = [response statusCode];
	if(statusCode >= 200 && statusCode < 300)
	{
		[_wvGadgetDisplay loadRequest:request];
	}
	else
	{
		[_wvGadgetDisplay loadHTMLString:[NSString stringWithFormat:@"<html><body>%@</body></html>", 
										  [_dictLocalize objectForKey:@"ConnectionTimedOut"]] baseURL:nil];
		 
	}	
    
}

@end
