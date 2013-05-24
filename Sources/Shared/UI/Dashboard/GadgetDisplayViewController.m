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
#import "LanguageHelper.h"

@interface GadgetDisplayViewController (PrivateMethods)
@end



@implementation GadgetDisplayViewController

@synthesize gadget = _gadget;

- (void)dealloc {
    [_gadget release];
    [super dealloc];
}

// custom init method
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle gadget:(GadgetItem *)gadgetToLoad	
{
	if (self = [super initWithNibName:nibName bundle:nibBundle]) {
        [self setGadget:gadgetToLoad];
        _url = [[NSURL URLWithString:_gadget.gadgetUrl] retain];
	}
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    //Set the title of the controller
    self.title = _gadget.gadgetName;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
    
    //add the meta tag named 'viewport' to take the full device-width for webview to display gadgets (MOB-1420)
    NSString* js = @"var meta = document.createElement('meta'); " \
                    "meta.setAttribute( 'name', 'viewport' ); " \
                    "meta.setAttribute( 'content', 'initial-scale = 1.0, user-scalable = yes' ); " \
                    "document.getElementsByTagName('head')[0].appendChild(meta)";
    
    [webView stringByEvaluatingJavaScriptFromString: js];
}

@end