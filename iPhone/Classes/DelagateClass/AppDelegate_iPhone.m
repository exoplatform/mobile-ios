//
//  AppDelegate_iPhone.m
//  eXo Platform
//
//  Created by Mai Gia on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPhone.h"

#import "eXoAppViewController.h"
#import "eXoApplicationsViewController.h"
#import "eXoSettingViewController.h"
#import "eXoWebViewController.h"
#import "eXoSplashViewController.h"
#import "defines.h"
#import "Connection.h"

@implementation AppDelegate_iPhone

@synthesize window;
@synthesize viewController;
@synthesize applicationsViewController;
@synthesize gadgetsViewController;
@synthesize navigationController;
@synthesize tabBarController;
@synthesize settingViewController;
@synthesize webViewController;


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
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	int selectedLanguage = [[userDefaults objectForKey:EXO_PREFERENCE_LANGUAGE] intValue];
	NSString* filePath;
	if(selectedLanguage == 0)
	{
		filePath = [[[NSBundle mainBundle] pathForResource:@"Localize_EN_iPhone" ofType:@"xml"] retain];
	}	
	else
	{	
		filePath = [[[NSBundle mainBundle] pathForResource:@"Localize_FR_iPhone" ofType:@"xml"] retain];
	}
	
	_dictLocalize = [[NSDictionary alloc] initWithContentsOfFile:filePath];
	
	viewController = nil;
	applicationsViewController = nil;
	settingViewController = nil;
	webViewController = nil;
	
	_splash = [[eXoSplashViewController alloc] initWithNibName:@"eXoSplashViewController" bundle:nil];
	_splash._dictLocalize = _dictLocalize;
	[window makeKeyAndVisible];
	[window addSubview:_splash.view];
	[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(splashScreen) userInfo:nil repeats:NO];
}

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
		viewController = [[eXoAppViewController alloc] initWithNibName:@"eXoAppViewController" bundle:nil];
		navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
		[window addSubview:[navigationController view]];
	}
}

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
-(void)login 
{
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
	NSString *username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
	NSString *password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
	
	Connection* conn = [[Connection alloc] init];
	
	NSString *_bSuccessful = [conn sendAuthenticateRequest:domain username:username password:password];
	
	if(_bSuccessful == @"YES")
	{
		[_splash.view removeFromSuperview];
		viewController = [[eXoAppViewController alloc] initWithNibName:@"eXoAppViewController" bundle:nil];
		navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
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
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	viewController = [[eXoAppViewController alloc] initWithNibName:@"eXoAppViewController" bundle:nil];
	navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	[window addSubview:[navigationController view]];
	
}

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

- (void)changeToGadgetsViewController
{
	// view for loading gadgets
	[navigationController pushViewController:gadgetsViewController animated:NO];	
}


- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)dealloc {
	
    [viewController release];
	[applicationsViewController release];
	[gadgetsViewController release];
    [window release];
    [super dealloc];
}

@end
