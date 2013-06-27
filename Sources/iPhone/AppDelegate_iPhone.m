//
//  AppDelegate_iPhone.m
//  eXo Platform
//
//  Created by Mai Gia on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPhone.h"

#import "defines.h"
#import "FilesProxy.h"
#import "HomeStyleSheet.h"
#import <Crashlytics/Crashlytics.h>
#import "UserPreferencesManager.h"
#import "WelcomeViewController_iPhone.h"


@implementation AppDelegate_iPhone

@synthesize window;
@synthesize authenticateViewController = _authenticateViewController;
@synthesize navigationController;
@synthesize homeViewController_iPhone;
@synthesize isCompatibleWithSocial = _isCompatibleWithSocial;
@synthesize homeSidebarViewController_iPhone = _homeSidebarViewController_iPhone;
@synthesize welcomeViewController = _welcomeViewController;

+ (AppDelegate_iPhone *) instance {
    return (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];    
}

- (id)init {
	if ((self = [super init])) {
	}
	return self;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application { 
    //Add Crashlytics
    [Crashlytics startWithAPIKey:@"b8421f485868032ad402cef01a4bd7c70263d97e"];
    
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] forKey:EXO_PREFERENCE_VERSION_APPLICATION];
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_4_3    
    //Configuring the Navigation Bar for iOS 5
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavbarBg.png"] 
                                           forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTintColor:[UIColor darkGrayColor]];
        
//        [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:0.47f green:0.23f blue:0.61f alpha:1.0f]];
        UIImage *barButton = [UIImage imageNamed:@"NavbarBackButton.png"];
        barButton = [barButton stretchableImageWithLeftCapWidth:barButton.size.width / 2 topCapHeight:0];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:barButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        UIImage *barActionButton = [UIImage imageNamed:@"NavbarActionButton.png"];
        barActionButton = [barActionButton stretchableImageWithLeftCapWidth:barButton.size.width / 2 topCapHeight:0];
        [[UIBarButtonItem appearance] setBackgroundImage:barActionButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    if ([[UIToolbar class] respondsToSelector:@selector(appearance)]) {
        [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"NavbarBg.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    
#endif
    
    BOOL accountConfigured = [[NSUserDefaults standardUserDefaults] objectForKey:EXO_CLOUD_ACCOUNT_CONFIGURED];
    
    if(accountConfigured) { //if one account is configured, display Authenticate screen
        window.rootViewController = navigationController;
    } else {
        _welcomeViewController = [[WelcomeViewController_iPhone alloc] initWithNibName:@"WelcomeViewController_iPhone" bundle:nil];
        window.rootViewController = _welcomeViewController;
        
    }

	[window makeKeyAndVisible];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption {
    [super application:application didFinishLaunchingWithOptions:launchOption];
    [self applicationDidFinishLaunching:application];
    return YES;
}



- (void)showHomeSidebarViewController {
    // Login is successfully
    [TTStyleSheet setGlobalStyleSheet:[[[HomeStyleSheet alloc] init] autorelease]];

    
    [[FilesProxy sharedInstance] creatUserRepositoryHomeUrl];
    [[SocialRestConfiguration sharedInstance] updateDatas];
    
    
    [UserPreferencesManager sharedInstance].isUserLogged = YES;
    
    _homeSidebarViewController_iPhone = [[HomeSidebarViewController_iPhone alloc] initWithNibName:nil bundle:nil];
    
    window.rootViewController = _homeSidebarViewController_iPhone;
}



- (void)showHomeViewController {
    // Login is successfully
    
    [TTStyleSheet setGlobalStyleSheet:[[[HomeStyleSheet alloc] init] autorelease]];

    
    [[FilesProxy sharedInstance] creatUserRepositoryHomeUrl];
    [[SocialRestConfiguration sharedInstance] updateDatas];
    
    
    [UserPreferencesManager sharedInstance].isUserLogged = YES;
    
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
    
    [_welcomeViewController release];
    _welcomeViewController = nil;
    
    [window release];
    window = nil;
    
    [super dealloc];
}

- (void)onBtnSigtOutDelegate {
    
    // Disable Auto Login so user won't be signed in automatically after
    if(![UserPreferencesManager sharedInstance].rememberMe) {
        [_authenticateViewController disableAutoLogin:YES];
    }
    [_authenticateViewController updateLabelAfterLogOut];
    
    window.rootViewController = navigationController;
    
    [UserPreferencesManager sharedInstance].isUserLogged = NO;

    
    [LoginProxy doLogout];
}

@end
