//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
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

@synthesize fullscreen, webView, url, fileName, rect, navigationBar, loadingIndicator;


// custom init method to allow URL to be passed
- (instancetype)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle 
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
    [self.webView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    self.webView.delegate = self;
    self.webView.opaque = NO;
    [self.webView setScalesPageToFit:YES];
    if(self.url != nil)
	{
        NSURLRequest* request = [NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
        [self.webView loadRequest:request];
    }
}

- (void)fullScreen {
    eXoFullScreenView *viewController = [[eXoFullScreenView alloc] initWithNibName:nil bundle:nil];
    
    self.navigationBar = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                                        initWithTitle:Localize(@"Close") 
                                                        style:UIBarButtonItemStylePlain 
                                                        target:self 
                                                        action:@selector(close)];
    
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.webView.alpha = 0;

                     } 
                     completion:^(BOOL finished){
                         if(self.webView.superview != nil){
                            [self.webView removeFromSuperview];
                         }
                         [viewController.view addSubview:self.webView];

                         [[AppDelegate_iPad instance].rootViewController
                            presentViewController:self.navigationBar animated:YES completion:nil];
                         
                         CGRect frame = self.webView.frame;
                         frame.origin.y -= self.navigation.frame.size.height;
                         frame.size.height = self.navigationBar.view.bounds.size.height;
                         frame.size.width = self.navigationBar.view.bounds.size.width;
                         self.webView.frame = frame;
                         
                         [UIView animateWithDuration:0.3
                                          animations:^{
                                              self.webView.alpha = 1;
                                          } 
                                          completion:^(BOOL finished){
                                          }];
                     }];
}


-(void)close {
    [self.navigationBar dismissViewControllerAnimated:YES completion:nil];

    [UIView animateWithDuration:0.3
                     animations:^{
                         self.webView.alpha = 0;

                     } 
                     completion:^(BOOL finished){
                         

                         
                         if(self.webView.superview != nil){
                             [self.webView removeFromSuperview];
                         }
                         [self.view addSubview:self.webView];
                         
                         CGRect frame = self.webView.frame;
                         frame.origin.y += self.navigation.frame.size.height;
                         frame.size.width = self.view.bounds.size.width;
                         frame.size.height = self.view.bounds.size.height;
                         self.webView.frame = frame;
                                                   
                         [UIView animateWithDuration:0.3
                                          animations:^{
                                              self.webView.alpha = 1;
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
        self.navigation.topItem.rightBarButtonItem = nil;
        self.navigation.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:Localize(@"Fullscreen") style:UIBarButtonItemStylePlain target:self action:@selector(fullScreen)];
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
        self.navigation.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.loadingIndicator];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        JTNavigationBar* _iPhoneNavBar = [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar;
        _iPhoneNavBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.loadingIndicator];
    }
    // Start the animation
    [self.loadingIndicator startAnimating];
}

- (void)viewDidUnload
{
    [self.webView setDelegate:nil];
    self.webView = nil;
    [super viewDidUnload];
}

- (void)dealloc 
{
    [self.webView setDelegate:nil];
    [self.webView stopLoading];
    self.webView = nil;
    self.url = nil;
    self.fileName = nil;
    self.navigationBar = nil;
    self.loadingIndicator = nil;
    self.fullscreen = nil;
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
    self.navigation.topItem.rightBarButtonItem.title = Localize(@"Fullscreen");
    [self.view setNeedsDisplay];
}

@end
