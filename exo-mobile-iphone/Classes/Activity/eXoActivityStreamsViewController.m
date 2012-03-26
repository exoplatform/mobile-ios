//
//  eXoActivityStreamsViewController.m
//  eXoApp
//
//  Created by Tran Hoai Son on 7/8/09.
//  Copyright 2009 home. All rights reserved.
//

#import "eXoActivityStreamsViewController.h"
#import "eXoWebViewController.h"
#import "eXoApplicationsViewController.h"
#import "XMPPClient.h"
#import "defines.h"
#import "httpClient.h"
#import "eXoAccount.h"

@implementation eXoActivityStreamsViewController

@synthesize _url;
@synthesize _webView;
@synthesize _statusLabel;
//@synthesize _progressIndicator;

// custom init method to allow URL to be passed
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL 
{
	[super initWithNibName:nibName bundle:nibBundle];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *urlStr = [NSString stringWithFormat:@"%@/portal/private/classic/mydashboard", [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN]];
	_url = [[NSURL URLWithString:urlStr] retain];

	return self;
	
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	NSString *domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
	NSMutableString *htmlStr = [[NSMutableString alloc] init];
	[htmlStr appendFormat:@"%@/eXoGadgetServer/gadgets/"
	 "ifr?container=default&mid=0&nocache=0&country=ALL&lang=en&view=home&parent=%@&st=default:", domain, domain];
	
	NSData* dataReply = [httpClient sendRequest:[_url absoluteString]];
	
	NSString* strContent = [[NSString alloc] initWithData:dataReply encoding:NSISOLatin1StringEncoding];
	//NSString* strContent = [NSString stringWithContentsOfURL:_url];
	
	NSRange range = [strContent rangeOfString:@"eXo.gadget.UIGadget.createGadget"];
	
	if(range.length > 0) {
		NSMutableString *gadgetsString = [NSMutableString stringWithString:[strContent substringFromIndex:range.location]];
		do {
			range = [gadgetsString rangeOfString:@"eXo.gadget.UIGadget.confirmDeleteGadget = 'Are you sure to delete this gadget?';"];
			if(range.length > 0) {
				NSString *tmpStr = [gadgetsString substringToIndex:range.location];

				NSRange tmpRange = [tmpStr rangeOfString:@"\"title\":\"Status updates\""];
				if(tmpRange.length > 0) {
					
					NSRange startTokenRange = [tmpStr rangeOfString:@"\"secureToken\":\"default:"];
					NSRange endTokenRange = [tmpStr rangeOfString:@"==\""];
					NSMutableString *tmp = [NSMutableString stringWithString:[tmpStr substringWithRange:NSMakeRange(startTokenRange.location + startTokenRange.length, 
																													endTokenRange.location - startTokenRange.location - startTokenRange.length)]];
					
					
					//[tmp replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tmp length])];
//					[tmp replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tmp length])];
					[htmlStr appendString:tmp];
					[htmlStr appendFormat:@"==&url=%@/rest/jcr/repository/gadgets/gadgets/activities.xml", domain];
					[htmlStr replaceOccurrencesOfString:@"&" withString:@"&amp;" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [htmlStr length])];
					//NSLog(htmlStr);
					//htmlStr = (NSMutableString *)[htmlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				}
				
				gadgetsString = (NSMutableString *)[gadgetsString substringFromIndex:range.location + range.length];
			}
			
			
		} while (range.length > 0);
		
		_webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, 320, 480)];
		_webView.delegate = self;
		
		
		NSMutableURLRequest* loginRequest = [[NSMutableURLRequest alloc] init];	
		[loginRequest setURL:[NSURL URLWithString:htmlStr]];
		
		eXoAccount* account = [eXoAccount instance];
		
		//NSURL* url = [NSURL URLWithString:htmlStr];
		//NSString *tmp = [NSString stringWithString:@"http://localhost:8080/eXoGadgetServer/gadgets/ifr?container=default&mid=2&nocache=0&country=ALL&lang=en&view=home&parent=http://localhost:8080&st=default:gl2EXzU6wMdvbwqQ0GfTUBdrVvwY8eT9QbZX0rFDBXCPfJECJvh5vTJOqANpdaxA87d4NlBcC5OfQgKS6cqQoVs7KxlaN4WIJ4mTpOB5q5/C21ZKs52K2e51KC1DePKnYMxcFQC98sKn1iqzOrcMBszZvxGZo5yQ1DC40tI3RoWA9eCrFL+5SGeOlImQxwG19KbyGNHHGfvgw/aL6VchlmgsMWFGAYWkRdke++5HdhzEEV4SCjJNRSOpb0nZh3sfNmb0Ise97GExm5UCKipnGTIRrrB8tIP197VC1ZLN2x3PP5hmFdJI7DZyu0oPmmkihgsVIg==&url=http://localhost:8080/rest/jcr/repository/gadgets/Calendar/Calendar.xml"];
		NSString *tmp = @"http://localhost:8080/eXoGadgetServer/gadgets/ifr?container=default&mid=2&nocache=0&country=ALL&lang=en&view=home&parent=http%3A%2F%2Flocalhost%3A8080&st=default%3Agl2EXzU6wMdvbwqQ0GfTUBdrVvwY8eT9QbZX0rFDBXCPfJECJvh5vTJOqANpdaxA87d4NlBcC5OfQgKS6cqQoVs7KxlaN4WIJ4mTpOB5q5%2FC21ZKs52K2e51KC1DePKnYMxcFQC98sKn1iqzOrcMBszZvxGZo5yQ1DC40tI3RoWA9eCrFL%2B5SGeOlImQxwG19KbyGNHHGfvgw%2FaL6VchlmgsMWFGAYWkRdke%2B%2B5HdhzEEV4SCjJNRSOpb0nZh3sfNmb0Ise97GExm5UCKipnGTIRrrB8tIP197VC1ZLN2x3PP5hmFdJI7DZyu0oPmmkihgsVIg%3D%3D&url=http%3A%2F%2Flocalhost%3A8080%2Frest%2Fjcr%2Frepository%2Fgadgets%2FCalendar%2FCalendar.xml";
		//NSLog(tmp);
		//NSLog([tmp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
//		tmp = [tmp stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
//		tmp = [tmp stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
//		tmp = [tmp stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
		NSURL* url = [NSURL URLWithString: tmp];
		//NSLog(tmp);
		NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];	
		[request setURL:url]; 
		[request setTimeoutInterval:5.0];
		[request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
		[request setHTTPShouldHandleCookies:YES];	
		[request setHTTPMethod:@"GET"];
		[request setValue:[httpClient stringOfAuthorizationHeaderWithUsername:[account userName] password:[account password]] 
																						forHTTPHeaderField:@"Authorization"];		
		[_webView loadRequest:request];
		[self.view addSubview:_webView];
	}
	
	
}
/*
- (void)viewWillAppear:(BOOL)animated 
{
	//NSURLRequest* request = [[NSURLRequest alloc] initWithURL:_url];
//	[_webView loadRequest:request];
//	[request release];
//	
//	
//    NSMutableString *jsCode = [NSString stringWithContentsOfURL:[NSURL URLWithString:path]];
	

	//NSLog(jsCode);
//	
//    [_webView stringByEvaluatingJavaScriptFromString:jsCode];
//	
//	NSString *tmp = [_webView stringByEvaluatingJavaScriptFromString:@"StatusUpdate.prototype.postNewActivity()"];
//	NSLog(tmp);
	
	
	//NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//	NSString* domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
//	
//	NSString *homeURL = [domain stringByAppendingString:@"/portal/private/classic/mydashboard"];
	if([[_url absoluteString] isEqualToString:@""])
		return;
	NSData* dataReply = [httpClient sendRequest:[_url absoluteString]];
	NSString* strContent = [[NSString alloc] initWithData:dataReply encoding:NSISOLatin1StringEncoding];
	
	//NSLog(strContent);
	NSRange cssRange = [strContent rangeOfString:@"/eXoGadgetServer/gadgets/concat?rewriteMime=text/css&gadget"];
	
	NSString *htmlStr1 = [NSString stringWithFormat:@"%@%@%@", [strContent substringToIndex:cssRange.location], 
						 @"http://localhost:8080", [strContent substringFromIndex:cssRange.location]];
	
	NSRange jsRange = [htmlStr1 rangeOfString:@"<script src=\"/eXoGadgetServer/gadgets/concat?rewriteMime=text/javascript&gadget="];

	NSRange tmp1 = [htmlStr1 rangeOfString:@"<script type=\"text/javascript\">"];
	
	NSString *scriptStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"script" ofType:@"txt"]]; 
	
	NSString *htmlStr2 = [NSString stringWithFormat:@"%@%@", [htmlStr1 substringToIndex:jsRange.location], 
						  [htmlStr1 substringFromIndex:tmp1.location]];
	
	NSRange tmp2 = [htmlStr2 rangeOfString:@"var statusUpdates"];
	
	
	NSLog(htmlStr3);
	[_webView loadHTMLString:htmlStr3 baseURL:nil];
	//[_webView stringByEvaluatingJavaScriptFromString:@"eXo.social.statusUpdate.postNewActivity();"];
	[_webView stringByEvaluatingJavaScriptFromString:test];
	//[_webView loadHTMLString:filePath baseURL:nil];
}
*/

// Handle Error
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
	//_statusLabel.text = @"";
	//[_progressIndicator stopAnimating];
}

// Stop loading animation
- (void)webViewDidFinishLoad:(UIWebView *)aWebView 
{
	//_statusLabel.text = @"";
	

	//[_progressIndicator stopAnimating];
}

// Start loading animation
- (void)webViewDidStartLoad:(UIWebView *)webView 
{
	//_statusLabel.text = @"Loading...";
	//[_progressIndicator startAnimating];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc 
{
	[_webView release];
	[_statusLabel release];
	//[_progressIndicator release];
	
    [super dealloc];
}

@end


//@implementation eXoActivityStreamsViewController
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
//{
//    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
//	{
//		self.title = @"Activity Streams";
//    }
//    return self;
//}
//
//
//- (void)loadView 
//{
//	[super loadView];
//}
//
//- (void)viewDidLoad 
//{
//    [super viewDidLoad];	
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//- (void)viewDidUnload 
//{
//
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//	[NSThread detachNewThreadSelector:@selector(getActivityStreamThread) toTarget:self withObject:nil];
//}
//
//- (void)getActivityStreamThread
//{
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    [NSThread sleepForTimeInterval:5];
//    [self performSelectorOnMainThread:@selector(showActivityStream) withObject:nil waitUntilDone:NO];
//    [pool release];
//}
//
//- (void)showActivityStream
//{
//	int i = 1;
//	BOOL t = [xmppClient isConnected];
////	NSURL* url;
////	NSMutableArray* arrGadgets = [[NSMutableArray alloc] init];
////	arrGadgets = [eXoApplicationsViewController listOfGadgets];
////	if([arrGadgets count] > 0)
////	{
////		for(int i = [arrGadgets count] - 1; i>=0; i--)
////		{
////			NSString* tmpStr = [[arrGadgets objectAtIndex:i] name];
////			if([tmpStr compare:@"Status updates"] == NSOrderedSame)
////			{
////				url = [[arrGadgets objectAtIndex:i] urlContent];
////				break;
////			}
////		}
////	}
//// 
////	eXoWebViewController* tmpView = [[eXoWebViewController alloc] initWithNibAndUrl:@"eXoWebViewController" bundle:nil url:url];
////	[[self navigationController] pushViewController:tmpView animated:YES];
//
////	NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
////	UIWebView* _webvGadgetView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
////	_webvGadgetView.backgroundColor = [UIColor whiteColor];
////	_webvGadgetView.scalesPageToFit = NO;
////	_webvGadgetView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
////	_webvGadgetView.delegate = self;
////	self.view = _webvGadgetView;
////	[_webvGadgetView loadRequest:request];
//}
//
//- (void)dealloc 
//{
//    [super dealloc];
//}
//@end
