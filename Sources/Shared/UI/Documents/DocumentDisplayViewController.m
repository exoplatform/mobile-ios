//
//  DocumentDisplayViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 10/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DocumentDisplayViewController.h"
#import "EmptyView.h"


@interface DocumentDisplayViewController (PrivateMethods)
- (void)showLoader;
- (void)hideLoader;
@end


@implementation DocumentDisplayViewController

@synthesize _url, _webView;


// custom init method to allow URL to be passed
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL fileName:(NSString *)fileName
{
	[super initWithNibName:nibName bundle:nibBundle];
	_url = [defaultURL retain];
    _fileName = [fileName retain];
    
	[_webView setDelegate:self];
	return self;
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc 
{
	[_url release];	//Gadget URL
    _url = nil;
    
	[_webView release];
    _webView = nil;
    
    [_fileName release];
    _fileName = nil;
    
	[_hudDocument release];
    _hudDocument = nil;
	
    [super dealloc];
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //Add the loader
    _hudDocument = [[ATMHud alloc] initWithDelegate:self];
    [_hudDocument setAllowSuperviewInteraction:NO];
    [self setHudPosition];
    [self.view addSubview:_hudDocument.view];
    
    [self showLoader];
    
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    
    //Set the title of the navigation bar
    [self setTitle:_fileName];
}

- (void)viewDidAppear:(BOOL)animated {
	if(_url != nil)
	{
		NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
		[request setURL:_url]; 
        [_webView loadRequest:request];
        [request release];
    }
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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




#pragma mark - Loader Management
- (void)setHudPosition {
    //Default implementation
    //Nothing keep the default position of the HUD
}

- (void)showLoader {
    [self setHudPosition];
    [_hudDocument setCaption:[NSString stringWithFormat:@"Loading Document %@", self.title]];
    [_hudDocument setActivity:YES];
    [_hudDocument show];
}


- (void)hideLoader {
    //Now update the HUD
    //TODO Localize this string
    [self setHudPosition];
    [_hudDocument hide];
}




@end
