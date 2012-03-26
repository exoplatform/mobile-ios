//
//  SupportViewController.m
//  iTradeDirect
//
//  Created by Tran Hoai Son on 4/8/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SupportViewController.h"
#import "LoginViewController.h"

@implementation SupportViewController

@synthesize _delegate;
@synthesize _dictLocalize;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
        // Custom initialization
		_dictLocalize = [[NSDictionary alloc] init];
		_wvHelp = [[UIWebView alloc] init];
		[_wvHelp setOpaque:NO];
		[_wvHelp setBackgroundColor:[UIColor colorWithRed:0.95 green:1 blue:0.86 alpha:0.7]];
		
    }
    return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	[super loadView];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[self localize];
    [super viewDidLoad];
}

- (void)localize
{
	_dictLocalize = [_delegate getLocalization];
	_selectedLanguage = [_delegate getSelectedLanguage];
	[self setTitle:[_dictLocalize objectForKey:@"SupportViewTitle"]];
	
//	NSURLRequest* urlHelp;
//	if(_selectedLanguage == 0)
//	{
//		urlHelp = [NSURLRequest requestWithURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"HowtoUse-EN" ofType:@"htm"]]];		
//	}
//	else 
//	{
//		urlHelp = [NSURLRequest requestWithURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"HowtoUse-FR" ofType:@"htm"]]];
//	}
//	
//	[_wvHelp loadRequest:urlHelp];
//	[[self view] addSubview:_wvHelp];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [super dealloc];
}


- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
}

- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
	{
		[[self view] setFrame:CGRectMake(0, 0, 768, 1004)];
		[_wvHelp setFrame:CGRectMake(0, 44, 768, 960)];
	}
	
	if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{	
		[[self view] setFrame:CGRectMake(0, 0, 1024, 748)];
		[_wvHelp setFrame:CGRectMake(0, 44, 1024, 708)];		
	}
	
	NSURLRequest* urlHelp;
	
	_selectedLanguage = [_delegate getSelectedLanguage];
	
	if(_selectedLanguage == 0)
	{
		urlHelp = [NSURLRequest requestWithURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"HowtoUse_EN_iPad" ofType:@"html"]]];		
	}
	else 
	{
		urlHelp = [NSURLRequest requestWithURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"HowtoUse_FR_iPad" ofType:@"html"]]];
	}

	[_wvHelp loadRequest:urlHelp];
	[[self view] addSubview:_wvHelp];
	
}	

- (IBAction)close:(id)sender
{
	[_delegate onCloseBtn:self];
}

@end
