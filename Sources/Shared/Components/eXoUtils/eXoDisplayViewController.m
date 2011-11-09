//
//  eXoDisplayViewController.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "eXoDisplayViewController.h"
#import "EmptyView.h"

#define TAG_EMPTY 500
@interface eXoDisplayViewController (PrivateMethods)
- (void)showLoader;
- (void)hideLoader;
@end


@implementation eXoDisplayViewController

@synthesize _url, _webView;

// custom init method to allow URL to be passed
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle 
{
	if(self = [super initWithNibName:nibName bundle:nibBundle]){
        
    }
	return self;
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    hide = NO;

    //Add the loader
    _hudView = [[ATMHud alloc] initWithDelegate:self];
    [_hudView setAllowSuperviewInteraction:NO];
    [self setHudPosition];
    [self.view addSubview:_hudView.view];
    
    [self showLoader];
    
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];    
    
    if(_url != nil)
	{
		NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
		[request setURL:_url]; 
        [_webView loadRequest:request];
        [request release];
    }
    mWindow = (eXoTapDetectingWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0];
    mWindow.viewToObserve = _webView;
    mWindow.controllerThatObserves = [self retain];
    //self.navigationController.navigationBar.isTranslucent = YES;
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

    _navigation.barStyle = UIBarStyleBlackTranslucent;
    _navigation.translucent = YES;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    _navigation.barStyle = UIBarStyleDefault;
    _navigation.translucent = NO;
}
- (void)userDidTapWebView:(id)tapPoint{
    hide = !hide;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(hide){
            _navigation.hidden = YES;
            
        } else {
            _navigation.hidden = NO;
        }
    } else {
        if(hide){
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            
        } else {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            _navigation.hidden = NO;
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    
    [_hudView release];
    
    [mWindow release];
	
    [super dealloc];
}

- (void)setUrl:(NSURL*)url
{
	_url = [url retain];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
    [self hideLoader];
    NSLog(@"%@\n %@",[error description], [[error userInfo] description]);
    //add empty view to the view 
    NSUInteger statusCode = [error code];
	if(!(statusCode >= 200 && statusCode < 300))
	{
        EmptyView *emptyView = [[EmptyView alloc] initWithFrame:self.view.bounds withImageName:@"IconForUnreadableFile.png" andContent:Localize(@"UnreadableFile")];
        emptyView.tag = TAG_EMPTY;
        [self.view addSubview:emptyView];
        [emptyView release];
        
    }
}

// Stop loading animation
- (void)webViewDidFinishLoad:(UIWebView *)aWebView 
{
    [self hideLoader];
    EmptyView *emptyview = (EmptyView *)[self.view viewWithTag:TAG_EMPTY];
    if(emptyview != nil){
        [emptyview removeFromSuperview];
    }
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
//    [self setHudPosition];
//    [_hudDocument setCaption:[NSString stringWithFormat:@"%@: %@", Localize(@"LoadingDocument"), _fileName]];
//    [_hudDocument setActivity:YES];
//    [_hudDocument show];
}


- (void)hideLoader {
    //Now update the HUD
    //TODO Localize this string
    [self setHudPosition];
    [_hudView hide];
}



@end
