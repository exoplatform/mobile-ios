//
//  AppDelegate_iPad.m
//  eXo Platform
//
//  Created by Mai Gia on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPad.h"
#import "RootViewController.h"
#import "MenuViewController.h"
#import "defines.h"
#import "FilesProxy.h"
#import "HomeStyleSheet.h"
#import <dispatch/dispatch.h>
#import <Crashlytics/Crashlytics.h>
#import "UserPreferencesManager.h"


@implementation AppDelegate_iPad

@synthesize window, viewController, rootViewController, isCompatibleWithSocial=_isCompatibleWithSocial;
@synthesize welcomeVC;

+ (AppDelegate_iPad *) instance {
    return (AppDelegate_iPad *) [[UIApplication sharedApplication] delegate];

}



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    //Add Crashlytics
    [Crashlytics startWithAPIKey:@"b8421f485868032ad402cef01a4bd7c70263d97e"];
    
    
    
    // Override point for customization after application launch.
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    // version application
    [userDefaults setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] forKey:EXO_PREFERENCE_VERSION_APPLICATION];
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_4_3
    //Configuring the Navigation Bar for iOS 5
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavbarBg.png"] 
                                           forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTintColor:[UIColor darkGrayColor]];
        UIImage *barButton = [UIImage imageNamed:@"NavbarBackButton.png"];
        barButton = [barButton stretchableImageWithLeftCapWidth:barButton.size.width / 2 topCapHeight:0];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:barButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        UIImage *barActionButton = [UIImage imageNamed:@"NavbarActionButton.png"];
        barActionButton = [barActionButton stretchableImageWithLeftCapWidth:barButton.size.width / 2 topCapHeight:0];
        [[UIBarButtonItem appearance] setBackgroundImage:barActionButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    if ([[UIToolbar class] respondsToSelector:@selector(appearance)]) {
        [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"NavbarBg.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        [[UIToolbar appearance] setTintColor:[UIColor darkGrayColor]];
    }
#endif
    
    
    BOOL isAccountConfigured = [[NSUserDefaults standardUserDefaults] boolForKey:EXO_CLOUD_ACCOUNT_CONFIGURED];
    
    if([[ApplicationPreferencesManager sharedInstance].serverList count] > 0) {
        isAccountConfigured = YES; // case upgrade, there were already servers
    }
    
    if(isAccountConfigured) {
        window.rootViewController = viewController;
    } else {
        welcomeVC = [[WelcomeViewController_iPad alloc] initWithNibName:@"WelcomeViewController_iPad" bundle:nil];
        window.rootViewController = welcomeVC;
    }
    
    [window makeKeyAndVisible];
                
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [super application:application handleOpenURL:url];
    self.window.rootViewController = viewController;// display authenticate screen
    return YES;
}

-(void)showHome
{
    
    [TTStyleSheet setGlobalStyleSheet:[[[HomeStyleSheet alloc] init] autorelease]];

    
    [[FilesProxy sharedInstance] creatUserRepositoryHomeUrl];
    [[SocialRestConfiguration sharedInstance] updateDatas];

    
    [UserPreferencesManager sharedInstance].isUserLogged = YES;
    self.rootViewController = [[[RootViewController alloc] initWithNibName:nil bundle:nil isCompatibleWithSocial:_isCompatibleWithSocial] autorelease];
    [UIView transitionWithView:self.window
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{ 
                        self.window.rootViewController = rootViewController;
                    }
                    completion:^(BOOL finished){
                    }];
}


-(void)backToAuthenticate{    
    //Prevent any problems with Autologin, if the user want to go back to the authenticate screen
    [UserPreferencesManager sharedInstance].autoLogin = NO;
    [UserPreferencesManager sharedInstance].isUserLogged = NO;
    // Disable Auto Login so user won't be signed in automatically after
    if(![UserPreferencesManager sharedInstance].rememberMe) {
        [viewController disableAutoLogin:YES];
    }

    [viewController updateLabelAfterLogOut];
    
    // execute Logout
    [LoginProxy doLogout];
    
    //Display the eXoMobileView Controller
    [UIView transitionWithView:self.window
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        self.window.rootViewController = viewController;
                    }
                    completion:^(BOOL finished){
                    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [rootViewController release];
    [welcomeVC release];
    [window release];
    [super dealloc];
}


@end
