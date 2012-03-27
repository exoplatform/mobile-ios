//
//  GadgetDisplayController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/14/10.
//  Copyright 2010 home. All rights reserved.
//

#import "GadgetDisplayController.h"
#import "MainViewController.h"
#import "Gadget.h"

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
	}
	return self;
}

//- (id)initWithNibAndUrl:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSURL *)defaultURL 
//{
//	[super initWithNibName:nibName bundle:nibBundle];
//	_url = defaultURL;
//	
//	return self;
//}

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

//- (void)startGadget:(NSURL*)gadgetUrl
//{
//	NSURLRequest* request = [[NSURLRequest alloc] initWithURL:gadgetUrl];
//	[_wvGadgetDisplay  setDelegate:self];
//	[_wvGadgetDisplay loadRequest:request];
//}

- (void)startGadget:(Gadget*)gadget
{
	_nvTitle.topItem.title = [gadget name];
	NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[gadget urlContent]];
	[_wvGadgetDisplay  setDelegate:self];
	[_wvGadgetDisplay loadRequest:request];
}

@end
