//
//  GadgetDisplayViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 25/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "GadgetDisplayViewController.h"
#import "GadgetItem.h"
#import "AuthenticateProxy.h"
#import "EmptyView.h"

@interface GadgetDisplayViewController (PrivateMethods)
- (void)showLoader;
- (void)hideLoader;
@end



@implementation GadgetDisplayViewController

@synthesize gadget = _gadget;
@synthesize _webView;

// custom init method
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle gadget:(GadgetItem *)gadgetToLoad	
{
	if (self = [super initWithNibName:nibName bundle:nibBundle]) {
        [_webView setDelegate:self];

        [self setGadget:gadgetToLoad];
	}
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //Add the loader
    _hudGadget = [[ATMHud alloc] initWithDelegate:self];
    [_hudGadget setAllowSuperviewInteraction:NO];
    [self setHudPosition];
	[self.view addSubview:_hudGadget.view];
    
    //Set the title of the controller
    self.title = _gadget.gadgetName;
    
    //Start loading the gadget
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_gadget.gadgetUrl]]];
    [self showLoader];
}


- (void)setGadget:(GadgetItem *)gadgetToLoad
{
	_gadget = [gadgetToLoad retain];    
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
	[_gadget release];	//Gadget URL
    _gadget = nil;
    
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