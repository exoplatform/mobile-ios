//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import "eXoMobileAppDelegate.h"
#import "LanguageHelper.h"
#import "UserPreferencesManager.h"
#import "ApplicationPreferencesManager.h"

@implementation eXoMobileAppDelegate



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    [[LanguageHelper sharedInstance] loadLocalizableStringsForCurrentLanguage];
    
    // register only UIRemoteNotificationTypeNewsstandContentAvailability to intercept the notification and display it if we want
    // cf didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler below
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeNewsstandContentAvailability];
    
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
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
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

#pragma mark -
#pragma mark Remote Notifications registration and handling

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"Successfully registered device for remote notifications.");
    [[ApplicationPreferencesManager sharedInstance] saveDeviceToken:[deviceToken description]];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Could not register device for remote notifications. Error: %@", error);
}

// trick to intercept the remote notification and display it under certain conditions
// cf http://stackoverflow.com/questions/24269950/ios-intercept-push-notification/24438178
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSString* user = [userInfo objectForKey:@"user"];
    NSString* title = [userInfo objectForKey:@"title"];
    NSString* message = [userInfo objectForKey:@"message"];
    
    NSString* currentUser = [UserPreferencesManager sharedInstance].username;
    if ([currentUser isEqualToString:user])
    {
        // Raise the local notification a second after received
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        localNotification.alertBody = [NSString stringWithFormat:@"%@: %@", title, message];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    else
    {
        NSLog(@"Notification for user '%@' was ignored because he was not logged-in.", user);
    }
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

