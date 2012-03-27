//
//  eXoEachGadgetViewController.m
//  eXoApp
//
//  Created by Tran Hoai Son on 5/18/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import "eXoEachGadgetViewController.h"
#import "eXoUserClient.h"
#import "eXoIconRepository.h"
#import "CXMLDocument.h"

static eXoEachGadgetViewController *_instance;

@implementation eXoEachGadgetViewController
@synthesize _url;

+ (id)instance
{
    if (!_instance) 
	{
        return [eXoEachGadgetViewController newInstance];
    }
    return _instance;
}

+ (id)newInstance
{
    if(_instance)
	{
        [_instance release];
        _instance = nil;
    }
    
    _instance = [[eXoEachGadgetViewController alloc] init];
    return _instance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
    }
    return self;
}

- (void)dealloc
{
	[_webvGadgetView release];
	[super dealloc];
}

- (void)setUrl:(NSString*)urlStr
{
	_url = urlStr;
}

- (void)setGadgetIcon:(UIImage*)image
{
	[_imgBtn setImage:image forState:UIControlStateNormal];
	[self viewDidAppear:YES];
}

- (void)loadView
{	
	[super loadView];
	_webvGadgetView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	_webvGadgetView.backgroundColor = [UIColor whiteColor];
	_webvGadgetView.scalesPageToFit = NO;
	_webvGadgetView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	_webvGadgetView.delegate = self;
	self.view = _webvGadgetView;
}

#pragma mark UIWebView delegate methods

- (void)viewWillDisappear:(BOOL)animated 
{
	[_webvGadgetView loadHTMLString:nil baseURL:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidAppear:(BOOL)animated 
{
	NSError* error;
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *urlStr = [NSString stringWithFormat:@"%@/rest/jcr/repository/gadgets/Calendar.xml", [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN]];
	NSURL* myBaseURL = [NSURL URLWithString:urlStr];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:myBaseURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];			
	NSData *htmlData;
	NSURLResponse *response;		

	htmlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	CXMLDocument *document = [[CXMLDocument alloc] initWithData:htmlData options:1 << 9 error:&error];
	NSString* content = [document description];
	content = [content stringByReplacingOccurrencesOfString:@"<![CDATA[:" withString:@""]; 
	content = [content stringByReplacingOccurrencesOfString:@"]]>" withString:@""]; 
	content = [content stringByReplacingOccurrencesOfString:@"__BIDI_START_EDGE__" withString:@"right"];  
	
	NSData* data = [content dataUsingEncoding:NSUTF8StringEncoding];
	[_webvGadgetView loadData:data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:myBaseURL];
}

@end
