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
#import "ChatProxy.h"
#import <dispatch/dispatch.h>
#import <Crashlytics/Crashlytics.h>


@implementation AppDelegate_iPad

@synthesize window, viewController, rootViewController, isCompatibleWithSocial=_isCompatibleWithSocial;

+ (AppDelegate_iPad *) instance {
    return (AppDelegate_iPad *) [[UIApplication sharedApplication] delegate];

}



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    //Add Crashlytics
    [Crashlytics startWithAPIKey:@"b8421f485868032ad402cef01a4bd7c70263d97e"];
    
    
    
    // Override point for customization after application launch.
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    // version application
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
    
    window.rootViewController = viewController;
	[window addSubview:viewController.view];
    [window makeKeyAndVisible];
                
    return YES;
}



-(void)showHome
{
    
    [TTStyleSheet setGlobalStyleSheet:[[[HomeStyleSheet alloc] init] autorelease]];

    
    [[FilesProxy sharedInstance] creatUserRepositoryHomeUrl];
    [[SocialRestConfiguration sharedInstance] updateDatas];

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"YES" forKey:EXO_IS_USER_LOGGED];
    
    if (rootViewController == nil){
        rootViewController = [[RootViewController alloc] initWithNibName:nil bundle:nil isCompatibleWithSocial:_isCompatibleWithSocial];
    } else {
        [rootViewController resetComponent];
    }
    
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

    //[[ChatProxy sharedInstance] disconnect];
    
    //Prevent any problems with Autologin, if the user want to go back to the authenticate screen
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:@"NO" forKey:EXO_AUTO_LOGIN];
    [userDefaults setObject:@"NO" forKey:EXO_IS_USER_LOGGED];
    [userDefaults setObject:@"-1" forKey:EXO_PREFERENCE_SELECTED_SEVER];
    
    //Display the eXoMobileView Controller
    [UIView transitionWithView:self.window
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{ 
                        self.window.rootViewController = viewController;
                    }
                    completion:^(BOOL finished){
                    }];
    
    
    //Need to remove Cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
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
    [window release];
    [super dealloc];
}


@end
