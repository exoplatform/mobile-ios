//
//  AppDelegate_iPhone.m
//  eXo Platform
//
//  Created by Mai Gia on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPhone.h"

#import "defines.h"
#import "ChatProxy.h"
#import "FilesProxy.h"
#import "HomeStyleSheet.h"


@implementation AppDelegate_iPhone

@synthesize window;
@synthesize authenticateViewController = _authenticateViewController;
@synthesize navigationController;
@synthesize homeViewController_iPhone;
@synthesize isCompatibleWithSocial = _isCompatibleWithSocial;


+ (AppDelegate_iPhone *) instance {
    return (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];    
}

- (id)init {
	if ((self = [super init])) {
	}
	return self;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {   
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] forKey:EXO_PREFERENCE_VERSION_APPLICATION];
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_4_3    
    //Configuring the Navigation Bar for iOS 5
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavBar-FullWidth.png"] 
                                           forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTintColor:[UIColor darkGrayColor]];

        [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:113./255 green:113./255 blue:113./255 alpha:113./255]];
    }
#endif
    
    window.rootViewController = navigationController;
	[window makeKeyAndVisible];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption {
    [self applicationDidFinishLaunching:application];
    return YES;
}


- (void)showHomeViewController {
    // Login is successfully
    
    [TTStyleSheet setGlobalStyleSheet:[[[HomeStyleSheet alloc] init] autorelease]];

    
    [[FilesProxy sharedInstance] creatUserRepositoryHomeUrl];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"YES" forKey:EXO_IS_USER_LOGGED];
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
    
    [_authenticateViewController release];
    _authenticateViewController = nil;
    
    
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

- (void)onBtnSigtOutDelegate {
    
    [[ChatProxy sharedInstance] disconnect];
    
    //Ask the controller Login to do some things if needed
    //window.rootViewController = authenticateViewController;
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"NO" forKey:EXO_AUTO_LOGIN];
    [userDefaults setObject:@"NO" forKey:EXO_IS_USER_LOGGED];
}

@end
