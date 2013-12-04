//
//  eXoDisplayViewController.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "eXoDisplayViewController.h"
#import "EmptyView.h"
#import "defines.h"
#import "AppDelegate_iPad.h"
#import "AppDelegate_iPhone.h"
#import "RootViewController.h"


#define TAG_WEBVIEW 10000
#define TAG_VIEW 10001
#define activityIndicatorRightMargin 10.

@interface eXoDisplayViewController (PrivateMethods)

@end


@implementation eXoDisplayViewController

@synthesize _webView;
@synthesize loadingIndicator = _loadingIndicator;

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
    [_webView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    _webView.delegate = self;
    _webView.opaque = NO;
    [_webView setScalesPageToFit:YES];
    if(_url != nil)
	{
        NSURLRequest* request = [NSURLRequest requestWithURL:_url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];	
        [_webView loadRequest:request];
    }
}

-(void)fullScreen {
    eXoFullScreenView *viewController = [[eXoFullScreenView alloc] initWithNibName:nil bundle:nil];
    
    

    navigationBar = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                                        initWithTitle:Localize(@"Close") 
                                                        style:UIBarButtonItemStylePlain 
                                                        target:self 
                                                        action:@selector(close)];

    
    
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    viewController.wantsFullScreenLayout = YES;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _webView.alpha = 0;

                     } 
                     completion:^(BOOL finished){
                         if(_webView.superview != nil){
                            [_webView removeFromSuperview];
                         }
                         [viewController.view addSubview:_webView];

                         [[AppDelegate_iPad instance].rootViewController presentModalViewController:navigationBar animated:YES];
                         
                         CGRect frame = _webView.frame;
                         frame.origin.y -= _navigation.frame.size.height;
                         frame.size.height = navigationBar.view.bounds.size.height;
                         frame.size.width = navigationBar.view.bounds.size.width;
                         _webView.frame = frame;
                         
                         [UIView animateWithDuration:0.3
                                          animations:^{
                                              
                                              
                                              _webView.alpha = 1;
                                          } 
                                          completion:^(BOOL finished){
                                              

                                          }];
                     }];
    
    
    
    
    
    [viewController release];
}


-(void)close {
    [navigationBar dismissModalViewControllerAnimated:YES];

    [UIView animateWithDuration:0.3
                     animations:^{
                         _webView.alpha = 0;

                     } 
                     completion:^(BOOL finished){
                         

                         
                         if(_webView.superview != nil){
                             [_webView removeFromSuperview];
                         }
                         [self.view addSubview:_webView];
                         
                         CGRect frame = _webView.frame;
                         frame.origin.y += _navigation.frame.size.height;
                         frame.size.width = self.view.bounds.size.width;
                         frame.size.height = self.view.bounds.size.height;
                         _webView.frame = frame;
                                                   
                         [UIView animateWithDuration:0.3
                                          animations:^{
                                              
                                              _webView.alpha = 1;
                                          } 
                                          completion:^(BOOL finished){
                                              [self stopLoadingAnimation];
                                          }];
                     }];
}

// Stop the animation on the activity indicator
- (void)stopLoadingAnimation{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        // Fullscreen feature is available only on iPad
        // So we must display the fullscreen button instead of the indicator
        _navigation.topItem.rightBarButtonItem = nil;
        _navigation.topItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:Localize(@"Fullscreen") style:UIBarButtonItemStylePlain target:self action:@selector(fullScreen)] autorelease];
    } else if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        // On iPhone we just remove the indicator
        JTNavigationBar* _iPhoneNavBar = [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar;
        _iPhoneNavBar.topItem.rightBarButtonItem = nil;
    }
    // Stop the animation
    [self.loadingIndicator stopAnimating];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)startLoadingAnimation{
    // Add the loader indicator
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    // Position the indicator at the right of the navigation bar
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _navigation.topItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.loadingIndicator] autorelease];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        JTNavigationBar* _iPhoneNavBar = [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar;
        _iPhoneNavBar.topItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.loadingIndicator] autorelease];
    }
    // Start the animation
    [self.loadingIndicator startAnimating];
}

- (void)viewDidUnload
{
    [_webView setDelegate:nil];
    [_webView stopLoading];
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning 
{
    
    [super didReceiveMemoryWarning];
}

- (void)dealloc 
{

    [_loadingIndicator release];
    [_url release];
    [_webView setDelegate:nil];
    [_webView stopLoading];
    [_webView release];
    [_fileName release];
    [navigationBar release];
    [super dealloc];
}

//Test for rotation management
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    CGRect tmpRect = self.view.frame;

    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) { 
        if (tmpRect.size.width != WIDTH_LANDSCAPE_WEBVIEW) {
            tmpRect.size.width = WIDTH_LANDSCAPE_WEBVIEW;
            tmpRect.origin.x = DISTANCE_LANDSCAPE;
            self.view.frame = tmpRect;
        }
    } else {
        if (tmpRect.size.width != WIDTH_PORTRAIT_WEBVIEW) {
            tmpRect.size.width = WIDTH_PORTRAIT_WEBVIEW;
            tmpRect.origin.x = DISTANCE_PORTRAIT;
            self.view.frame = tmpRect;
        }
    }
    
    
    EmptyView *emptyview = (EmptyView *)[self.view viewWithTag:TAG_EMPTY];
    if(emptyview != nil){
        [emptyview changeOrientation];
    }
}

- (void)setUrl:(NSURL*)url
{
    [_url release];
	_url = [url copy];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
    [self stopLoadingAnimation];
    LogDebug(@"%@\n %@",[error description], [[error userInfo] description]);
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

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self startLoadingAnimation];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView 
{
    [self stopLoadingAnimation];
}

#pragma mark - change language management

- (void)updateLabelsWithNewLanguage{
    _navigation.topItem.rightBarButtonItem.title = Localize(@"Fullscreen");
    [self.view setNeedsDisplay];
}

@end
