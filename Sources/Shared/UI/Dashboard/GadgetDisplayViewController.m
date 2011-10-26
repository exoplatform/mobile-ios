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
#import "EmptyView.h"

@interface GadgetDisplayViewController (PrivateMethods)
- (void)showLoader;
- (void)hideLoader;
@end



@implementation GadgetDisplayViewController

@synthesize _url;
@synthesize _webView;

// custom init method to allow URL to be passed
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL 
{
	[super initWithNibName:nibName bundle:nibBundle];
	_url = defaultURL;
	_strBConnectStatus = @"NO";
	[_webView setDelegate:self];
	return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //Add the loader
    _hudGadget = [[ATMHud alloc] initWithDelegate:self];
    [_hudGadget setAllowSuperviewInteraction:NO];
    [self setHudPosition];
	[self.view addSubview:_hudGadget.view];
    
    [self showLoader];

    
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
    [self hideLoader];
    //add empty view to the view 
    EmptyView *emptyView = [[EmptyView alloc] initWithFrame:self.view.bounds withImageName:@"IconForUnreadableFile.png" andContent:Localize(@"UnreadableFile")];
    [self.view addSubview:emptyView];
    [emptyView release];
}

// Stop loading animation
- (void)webViewDidFinishLoad:(UIWebView *)aWebView 
{
    [self hideLoader];

}

// Start loading animation
- (void)webViewDidStartLoad:(UIWebView *)webView 
{
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
    
	[_hudGadget release];
    _hudGadget = nil;
	
    [super dealloc];
}



#pragma mark - Loader Management
- (void)setHudPosition {
    //Default implementation
    //Nothing keep the default position of the HUD
}

- (void)showLoader {
    [self setHudPosition];
    [_hudGadget setCaption:[NSString stringWithFormat:@"%@ %@", Localize(@"LoadingGadget"), self.title]];
    [_hudGadget setActivity:YES];
    [_hudGadget show];
}


- (void)hideLoader {
    //Now update the HUD
    //TODO Localize this string
    [self setHudPosition];
    [_hudGadget hide];
}

@end