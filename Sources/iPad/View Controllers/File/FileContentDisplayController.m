//
//  FileContentDisplayController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/14/10.
//  Copyright 2010 home. All rights reserved.
//

#import "FileContentDisplayController.h"
#import "MainViewController.h"

@implementation FileContentDisplayController

@synthesize _wvFileContentDisplay;
@synthesize _actiLoading;
@synthesize _lbStatus;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		// Custom initialization
		
		_wvFileContentDisplay.userInteractionEnabled = YES;
		_wvFileContentDisplay.scalesPageToFit = YES;
		_wvFileContentDisplay.clearsContextBeforeDrawing = YES;
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
	[super viewDidLoad];
	[self localize];
	
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
    
    [_wvFileContentDisplay release];
    _wvFileContentDisplay = nil;
    
    [_actiLoading release];
    _actiLoading = nil;
    
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

- (void)startDisplayFileContent:(NSURL*)url
{
	NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
	[_wvFileContentDisplay  setDelegate:self];
	[_wvFileContentDisplay loadRequest:request];
}

@end
