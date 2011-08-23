//
//  AppDelegate_iPhone.m
//  eXo Platform
//
//  Created by Mai Gia on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPhone.h"

#import "AuthenticateViewController.h"
#import "eXoSettingViewController.h"
#import "eXoWebViewController.h"
#import "defines.h"

#import "HomeViewController_iPhone.h"

@implementation AppDelegate_iPhone

@synthesize window;
@synthesize authenticateViewController;
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


- (void)showHomeViewController
{
    [_homeViewController_iPhone release];
    _homeViewController_iPhone = nil;   
    
    _homeViewController_iPhone = [[HomeViewController_iPhone alloc] initWithNibName:nil bundle:nil];
    [_homeViewController_iPhone setDelegate:self];
    
    _homeViewController_iPhone._isCompatibleWithSocial = _isCompatibleWithSocial;
    
    [self.navigationController pushViewController:_homeViewController_iPhone animated:YES];
    
}


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
	
	[_dictLocalize release];
    _dictLocalize = nil;
    
    [authenticateViewController release];
    authenticateViewController = nil;
    
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
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"NO" forKey:EXO_AUTO_LOGIN];
}

@end
