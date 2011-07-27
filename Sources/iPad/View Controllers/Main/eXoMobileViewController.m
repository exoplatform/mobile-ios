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
#import "HomeViewController_iPad.h"
#import "MenuViewController.h"
#import "AppDelegate_iPad.h"

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
	
	[[self view] addSubview:[_loginViewController view]];
    
    [super viewDidLoad];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	_interfaceOrientation = interfaceOrientation;
	CGRect rect;

	if((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
	{
		rect = CGRectMake(0, 0, SCR_WIDTH_PRTR_IPAD, SCR_HEIGHT_PRTR_IPAD);
	}
	if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{			
		rect = CGRectMake(0, 0, SCR_WIDTH_LSCP_IPAD, SCR_HEIGHT_LSCP_IPAD);
	}
	
	[[_loginViewController view] setFrame:rect];
	[_loginViewController changeOrientation:interfaceOrientation];
	
//	[[_mainViewController view] setFrame:rect];
//	[_mainViewController changeOrientation:interfaceOrientation];
    
    if (_homeViewController_iPad) 
    {
        //[_homeViewController_iPad.navigationController.view setFrame:rect];
        [[_homeViewController_iPad view] setFrame:rect];
        [_homeViewController_iPad changeOrientation:interfaceOrientation];
    }

    
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
    if (_homeViewController_iPad) 
    {
        [_homeViewController_iPad release];
    }
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

- (void)showHomeViewController:(BOOL)isCompatibleWithSocial
{
    
    
    [[AppDelegate_iPad instance] showHome:self isCompatibleWithSocial:isCompatibleWithSocial];
    
    /*
    [_loginViewController.view setHidden:YES];
    CGRect rect;
    if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
	{
		rect = CGRectMake(0, 0, SCR_WIDTH_PRTR_IPAD, SCR_HEIGHT_PRTR_IPAD);
	}
	if((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{			
		rect = CGRectMake(0, 0, SCR_WIDTH_LSCP_IPAD, SCR_HEIGHT_LSCP_IPAD);
	}
    
    if (_homeViewController_iPad == nil) 
    {
        _homeViewController_iPad = [[HomeViewController_iPad alloc] initWithNibName:nil bundle:nil];
        [_homeViewController_iPad changeOrientation:_interfaceOrientation];
        [_homeViewController_iPad setDelegate:self];
    }
    
    if (_menuViewController == nil) 
    {
        _menuViewController = [[MenuViewController alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    }
    
    if (_navigationController == nil) 
    {
        _navigationController = [[UINavigationController alloc] 
                                                   initWithRootViewController:_menuViewController];
        _navigationController.navigationBar.tintColor = [UIColor blackColor];
        
        [_navigationController.view setFrame:rect];
    }
    [[self view] addSubview:_navigationController.view];    
    
//    UINavigationController *applicationView = [[UINavigationController alloc] 
//											   initWithRootViewController:_homeViewController_iPad];
//	applicationView.navigationBar.tintColor = [UIColor blackColor];
//    
//    [applicationView.view setFrame:rect];
//    [[self view] addSubview:applicationView.view];
     */
}

- (void)onBtnSigtOutDelegate
{
    [_navigationController.view removeFromSuperview];
}

@end
