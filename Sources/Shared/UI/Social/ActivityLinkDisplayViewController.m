//
//  ActivityLinkDisplayViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 10/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityLinkDisplayViewController.h"
#import "EmptyView.h"
#import "LanguageHelper.h"



@interface ActivityLinkDisplayViewController (PrivateMethods)
- (void)showLoader;
- (void)hideLoader;
@end


@implementation ActivityLinkDisplayViewController

@synthesize  titleForActivityLink;


// custom init method to allow URL to be passed
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL
{
	self = [super initWithNibName:nibName bundle:nibBundle];
    if(self){
        _url = [defaultURL retain];
        [_webView setDelegate:self];
        self.titleForActivityLink = [[_url absoluteString] retain];
    }
	return self;
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.title = [_url absoluteString];
}

@end
