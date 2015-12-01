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

#import "AppDelegate_iPad.h"
#import "RootViewController.h"
#import "MenuViewController.h"
#import "defines.h"
#import "FilesProxy.h"
#import <dispatch/dispatch.h>
#import "UserPreferencesManager.h"
#import "UINavigationBar+ BackButtonDisplayFix.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

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
    [Fabric with:@[CrashlyticsKit]];
    
    application.statusBarHidden = YES;
        
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_4_3
    //Configuring the Navigation Bar for iOS 5
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavbarBg.png"] 
                                           forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
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
    [self.viewController doneWithSettings]; // refresh the list of accounts and display the tab item
    [self.viewController setPreferenceValues]; // display the username (if any) in the username text field
    self.window.rootViewController = viewController;// display authenticate screen
    return YES;
}

-(void)showHome
{
    [[FilesProxy sharedInstance] creatUserRepositoryHomeUrl];
    [[SocialRestConfiguration sharedInstance] updateDatas];

    
    [UserPreferencesManager sharedInstance].isUserLogged = YES;
    self.rootViewController = [[RootViewController alloc] initWithNibName:nil bundle:nil isCompatibleWithSocial:_isCompatibleWithSocial];
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

    [viewController updateAfterLogOut];
    [viewController autoFillCredentials];
    
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


@end
