//
//  AppDelegate_iPhone.m
//  eXo Platform
//
//  Created by Mai Gia on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPhone.h"

#import "AuthenticateViewController.h"
#import "eXoApplicationsViewController.h"
#import "eXoSettingViewController.h"
#import "eXoWebViewController.h"
#import "eXoSplashViewController.h"
#import "defines.h"
#import "Connection.h"

#import "HomeViewController_iPhone.h"

@implementation AppDelegate_iPhone

@synthesize window;
@synthesize authenticateViewController;
@synthesize applicationsViewController;
@synthesize gadgetsViewController;
@synthesize navigationController;
@synthesize tabBarController;
@synthesize settingViewController;
@synthesize webViewController;
@synthesize isCompatibleWithSocial = _isCompatibleWithSocial;

@synthesize dictLocalize = _dictLocalize;



+ (AppDelegate_iPhone *) instance {
    return (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    
}



- (id)init
{
	self = [super init];
	if(self)
	{
		_selectedLanguage = 0;
	}
	return self;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{    
	//[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    
    applicationsViewController = [[eXoApplicationsViewController alloc] initWithNibName:@"eXoApplicationsViewController" bundle:nil];


	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	int selectedLanguage = [[userDefaults objectForKey:EXO_PREFERENCE_LANGUAGE] intValue];
	NSString* filePath;
	if(selectedLanguage == 0)
	{
		filePath = [[[NSBundle mainBundle] pathForResource:@"Localize_EN" ofType:@"xml"] retain];
	}	
	else
	{	
		filePath = [[[NSBundle mainBundle] pathForResource:@"Localize_FR" ofType:@"xml"] retain];
	}
	
	_dictLocalize = [[NSDictionary alloc] initWithContentsOfFile:filePath];
	
    //FilePath not needed any more, so release it
    [filePath release];
    
    window.rootViewController = navigationController;
	[window makeKeyAndVisible];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption {
    [self applicationDidFinishLaunching:application];
    return YES;
}

/*
-(void)splashScreen {
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	BOOL autoLogin = [[userDefaults objectForKey:EXO_AUTO_LOGIN] boolValue];
	if(autoLogin)
	{
		
		NSThread *startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startLogin) object:nil];
		[startThread start];
		[self login];
		[startThread release];
	}
	else 
	{
		authenticateViewController = [[AuthenticateViewController alloc] initWithNibName:@"AuthenticateViewController" bundle:nil];
		navigationController = [[UINavigationController alloc] initWithRootViewController:authenticateViewController];
		[window addSubview:[navigationController view]];
	}
}
 */
/*
-(void)startLogin
{
	
	[_splash.view addSubview:_splash.activity];
	[_splash.view addSubview:_splash.lDomain];
	[_splash.view addSubview:_splash.lUserName];
	[_splash.view addSubview:_splash.lDomainStr];
	[_splash.view addSubview:_splash.lUserNameStr];
	[_splash.view addSubview:_splash.label];
	[_splash.view addSubview:_splash.autoLoginImg];
}
 */

/*
- (void)login 
{
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
	NSString *username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
	NSString *password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
	
	Connection* conn = [[Connection alloc] init];
	
	NSString *_bSuccessful = [[conn sendAuthenticateRequest:domain username:username password:password] copy];
    
    [conn release];
	
	if(_bSuccessful == @"YES")
	{
		[_splash.view removeFromSuperview];
		authenticateViewController = [[AuthenticateViewController alloc] initWithNibName:@"AuthenticateViewController" bundle:nil];
		navigationController = [[UINavigationController alloc] initWithRootViewController:authenticateViewController];
		[window addSubview:[navigationController view]];
		
		
		[self changeToActivityStreamsViewController:_dictLocalize];
	}
	else if(_bSuccessful == @"NO")
	{
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[_dictLocalize objectForKey:@"Authorization"]
														message:[_dictLocalize objectForKey:@"WrongUserNamePassword"]
													   delegate:self 
											  cancelButtonTitle:@"OK"
											  otherButtonTitles: nil];
		
		[alert show];
		[alert release];
		
		
	}
	else if(_bSuccessful == @"ERROR")
	{
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[_dictLocalize objectForKey:@"NetworkConnection"]
														message:[_dictLocalize objectForKey:@"NetworkConnectionFaile"]
													   delegate:self 
											  cancelButtonTitle:@"OK"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		
	}
    
    [_bSuccessful release];
}
 */

/*

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	authenticateViewController = [[AuthenticateViewController alloc] initWithNibName:@"AuthenticateViewController" bundle:nil];
	navigationController = [[UINavigationController alloc] initWithRootViewController:authenticateViewController];
	[window addSubview:[navigationController view]];
	
}
 */

- (void)showHomeViewController
{
    
    if (_homeViewController_iPhone == nil) 
    {
        _homeViewController_iPhone = [[HomeViewController_iPhone alloc] initWithNibName:nil bundle:nil];
        [_homeViewController_iPhone setDelegate:self];
    }
    
    _homeViewController_iPhone._isCompatibleWithSocial = _isCompatibleWithSocial;
    
    [self.navigationController pushViewController:_homeViewController_iPhone animated:YES];
    
}

/*
- (void)changeToActivityStreamsViewController:(NSDictionary *)dic
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	applicationsViewController = nil;
	[applicationsViewController release];
	applicationsViewController = [[eXoApplicationsViewController alloc] initWithNibName:@"eXoApplicationsViewController" bundle:nil];
	applicationsViewController.navigationItem.rightBarButtonItem = applicationsViewController._btnSignOut;
	applicationsViewController._dictLocalize = dic;
	
	settingViewController = nil;
	[settingViewController release];
	settingViewController = [[eXoSettingViewController alloc] initWithStyle:UITableViewStyleGrouped delegate:applicationsViewController];
	
	
	UINavigationController *applicationView = [[UINavigationController alloc] 
											   initWithRootViewController:applicationsViewController];
	applicationView.navigationBar.tintColor = [UIColor blackColor];
	
	UINavigationController *settingView = [[UINavigationController alloc]
										   initWithRootViewController:settingViewController];
	settingView.navigationBar.tintColor = [UIColor blackColor];
	
	
	[tabBarController setViewControllers:
	 [NSArray arrayWithObjects:applicationView, settingView, nil]];
	
	
	[tabBarController.view addSubview:applicationsViewController._btnNotificationRecievedMessage];
	
	_dictLocalize = dic;	
	
	[applicationView.navigationBar setBarStyle:UIBarStyleDefault];
	[applicationView.tabBarItem setTitle:[_dictLocalize objectForKey:@"ApplicationTitle"]];
	[applicationView.tabBarItem setImage:[UIImage imageNamed:@"application.png"]];
	applicationsViewController.tabBarItem  = applicationView.tabBarItem; // is it need (to show badge)?
	
	[settingView.navigationBar setBarStyle:UIBarStyleDefault];
	[settingView.tabBarItem setTitle:[_dictLocalize objectForKey:@"Settings"]];
	[settingView.tabBarItem setImage:[UIImage imageNamed:@"setting.png"]];
	settingViewController.tabBarItem  = settingView.tabBarItem; // is it need (to show badge)?
	
	[window addSubview:tabBarController.view];	
	
	[pool release];
}
*/

/*
- (void)changeToGadgetsViewController
{
	// view for loading gadgets
	//[navigationController pushViewController:gadgetsViewController animated:NO];	
}*/


- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)dealloc {
	
	[navigationController release];
    navigationController = nil;
    
	[tabBarController release];
	tabBarController = nil;
    
	[settingViewController release];	//Setting page
    settingViewController = nil;
    
	[webViewController release];	//Display help or file content
    webViewController = nil;
    
	[_splash release];	//Splash view
    _splash = nil;
	
	[_dictLocalize release];
    _dictLocalize = nil;
    
    [authenticateViewController release];
    authenticateViewController = nil;
    
	[applicationsViewController release];
    applicationsViewController = nil;
    
	[gadgetsViewController release];
    gadgetsViewController = nil;
    
    if (_homeViewController_iPhone)
    {
        [_homeViewController_iPhone release];
    }
    
    if (_navigationController)
    {
        [_navigationController release];
    }
    
    [window release];
    window = nil;
    
    [super dealloc];
}

- (void)onBtnSigtOutDelegate
{
    //Ask the controller Login to do some things if needed
    //window.rootViewController = authenticateViewController;
}

@end
