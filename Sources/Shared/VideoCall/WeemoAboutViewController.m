//
//  WeemoAboutViewController.m
//  eXo Platform
//
//  Created by vietnq on 10/15/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "WeemoAboutViewController.h"

@interface WeemoAboutViewController ()

@end

@implementation WeemoAboutViewController
@synthesize webView = _webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"About";
        
        self.tabBarItem.title = @"Help";
        self.tabBarItem.image = [UIImage imageNamed:@"question"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    
    [_webView loadHTMLString:htmlString baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    [_webView release];
}
@end
