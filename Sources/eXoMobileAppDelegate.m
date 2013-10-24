//
//  eXoMobileAppDelegate.m
//  eXoMobile
//
//  Created by Stévan on 02/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "eXoMobileAppDelegate.h"
#import "LanguageHelper.h"
#import "ApplicationPreferencesManager.h"
#import "ExoWeemoHandler.h"

@implementation eXoMobileAppDelegate

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
        
    [[LanguageHelper sharedInstance] loadLocalizableStringsForCurrentLanguage];
    
    //add chat server by default to test Weemo. TODO: remove after finishing the POC
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"HAD_CHAT_SERVER"]) {
        NSString *chatServerURL = @"http://addonchat-4.0.x-pkg-develop-snapshot.acceptance.exoplatform.org";
        NSString *chatServerName = @"Weemo Test";
        [[ApplicationPreferencesManager sharedInstance] addAndSetSelectedServer:chatServerURL withName:chatServerName];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HAD_CHAT_SERVER"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    ApplicationPreferencesManager *appPrefManage = [ApplicationPreferencesManager sharedInstance];
    [appPrefManage loadReceivedUrlToPreference:url];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    [[Weemo instance] background];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    [[Weemo instance] foreground];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //pick up the call when in background mode
    NSLog(@"receive notification");
    [[ExoWeemoHandler sharedInstance] receiveCall];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[super dealloc];
}


@end

