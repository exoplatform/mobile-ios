//
//  eXoMobileViewController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 5/31/10.
//  Copyright home 2010. All rights reserved.
//

#import "eXoMobileViewController.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "defines.h"
#import "Connection.h"

@implementation eXoMobileViewController

@synthesize _connection;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
        // Custom initialization
		
    }
    return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	_connection = [[Connection alloc] init];
	_intSelectedLanguage = 0;
	_loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];	
	[_loginViewController setDelegate:self];
	_mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
	[_mainViewController setDelegate:self];
	[super loadView];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString* strLanguageId = [userDefaults objectForKey:EXO_PREFERENCE_LANGUAGE];
	if(strLanguageId)
	{
		_intSelectedLanguage = [strLanguageId intValue];
	}
	[self setSelectedLanguage:_intSelectedLanguage];
	
	//[[self view] addSubview:[_loginViewController view]];
    //[self.navigationController pushViewController:_loginViewController animated:YES];
    
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:_loginViewController];
    [self.view addSubview:[navigationController view]];
	
    [super viewDidLoad];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	CGRect rect;

	if((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
	{
		rect = CGRectMake(0, 0, 768, 1024);
	}
	if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{			
		rect = CGRectMake(0, 0, 1024, 768);
	}
	
	[[_loginViewController view] setFrame:rect];
	[_loginViewController changeOrientation:interfaceOrientation];
	[_loginViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
	
	[[_mainViewController view] setFrame:rect];
	[_mainViewController changeOrientation:interfaceOrientation];
    return YES;
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

- (void)setSelectedLanguage:(int)languageId
{
	NSString* strLocalizeFilePath;
	
	_intSelectedLanguage = languageId;
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:[NSString stringWithFormat:@"%d", _intSelectedLanguage] forKey:EXO_PREFERENCE_LANGUAGE];
	
	if(_intSelectedLanguage == 0)
	{
		strLocalizeFilePath = [[[NSBundle mainBundle] pathForResource:@"Localize_EN" ofType:@"xml"] retain];
	}	
	else
	{	
		strLocalizeFilePath = [[[NSBundle mainBundle] pathForResource:@"Localize_FR" ofType:@"xml"] retain];
	}
	
	_dictLocalize = [[NSDictionary alloc] initWithContentsOfFile:strLocalizeFilePath];
	
	[self localize];
}

- (void)localize
{
	[_loginViewController localize];
	[_mainViewController localize];
}

- (NSDictionary*)getLocalization
{
	return _dictLocalize;
}

- (int)getSelectedLanguage
{
	return _intSelectedLanguage;
}

- (Connection*)getConnection
{
	return _connection;
}

- (void)showLoginViewController
{
	[[self view] addSubview:[_loginViewController view]];
}

- (void)showMainViewController
{
	[[_loginViewController view] removeFromSuperview];
	[_mainViewController loadGadgets];
	[_mainViewController onHomeBtn:nil];
	[[self view] addSubview:[_mainViewController view]];
}

@end
