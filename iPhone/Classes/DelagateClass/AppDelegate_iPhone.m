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
#import "eXoSetting.h"

#import "eXoWebViewController.h"
#import "eXoSplash.h"
#import "defines.h"
#import "eXoUserClient.h"

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
	else if(selectedLanguage == 1)
	{	
		filePath = [[[NSBundle mainBundle] pathForResource:@"Localize_FR_iPhone" ofType:@"xml"] retain];
	}	
	else if(selectedLanguage == 2)
	{	
		filePath = [[[NSBundle mainBundle] pathForResource:@"LocalizeVN" ofType:@"xml"] retain];
	}
	
	_dictLocalize = [[NSDictionary alloc] initWithContentsOfFile:filePath];
	
	viewController = nil;
	applicationsViewController = nil;
	relationAndContactViewController = nil;
	settingViewController = nil;
	webViewController = nil;
	
	_splash = [[eXoSplash alloc] initWithNibName:@"eXoSplash" bundle:nil];
	_splash._dictLocalize = _dictLocalize;
	[window makeKeyAndVisible];
	[window addSubview:_splash.view];
	[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(splashScreen) userInfo:nil repeats:NO];
}

-(void)splashScreen {
	
	//[_splash.view removeFromSuperview];
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	BOOL autoLogin = [[userDefaults objectForKey:EXO_AUTO_LOGIN] boolValue];
	if(autoLogin)
	{
		
		NSThread *startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startLogin) object:nil];
		[startThread start];
		//[NSThread detachNewThreadSelector:@selector(startLogin) toTarget:self withObject:nil];
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
	
	eXoUserClient* exoUserClient = [eXoUserClient instance];
	
	NSString *_bSuccessful = [exoUserClient signInDomain:domain withUserName:username password:password];
	
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
	
	//_myCalendar = nil;
	//	[_myCalendar release];
	//	_myCalendar = [[eXoMyCalendar alloc] initWithNibName:@"eXoMyCalendar" bundle:nil];
	
	
	settingViewController = nil;
	[settingViewController release];
	settingViewController = [[eXoSetting alloc] initWithStyle:UITableViewStyleGrouped delegate:applicationsViewController];
	
	
	UINavigationController *applicationView = [[UINavigationController alloc] 
											   initWithRootViewController:applicationsViewController];
	applicationView.navigationBar.tintColor = [UIColor blackColor];
	
	//UINavigationController *myCalendarView = [[UINavigationController alloc] 
	//											   initWithRootViewController:_myCalendar];
	//	myCalendarView.navigationBar.tintColor = [UIColor blackColor];
	//	
	//	[myCalendarView.navigationBar addSubview:_myCalendar.btnToday];
	//	[myCalendarView.navigationBar addSubview:_myCalendar.segCalendartype];
	
	
	
	
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
	
	//[myCalendarView.navigationBar setBarStyle:UIBarStyleDefault];
	//	[myCalendarView.tabBarItem setTitle:[_dictLocalize objectForKey:@"ApplicationTitle"]];
	//	[myCalendarView.tabBarItem setImage:[UIImage imageNamed:@"application.png"]];
	//	_myCalendar.tabBarItem  = myCalendarView.tabBarItem; // is it need (to show badge)?
	
	
	[settingView.navigationBar setBarStyle:UIBarStyleDefault];
	//[settingView.tabBarItem setTitle:@"Setting"];
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

- (void)changeToEachGadgetViewController:(NSString*)urlStr
{
	//eachGadgetViewController = [[eXoEachGadgetViewController alloc] initWithNibName:@"eXoEachGadgetViewController" bundle:nil];
//	[eachGadgetViewController setUrl:urlStr];
//	[navigationController pushViewController:eachGadgetViewController animated:NO];
	
}

- (void)applicationWillTerminate:(UIApplication *)application {
	//NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	//	NSString *autoLogin = [userDefaults objectForKey:EXO_AUTO_LOGIN];
	//	NSLog(autoLogin);
}

- (void)dealloc {
	
    [viewController release];
	[applicationsViewController release];
	[gadgetsViewController release];
	//[eachGadgetViewController release];
    [window release];
    [super dealloc];
}

@end
