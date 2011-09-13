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
    window.rootViewController = navigationController;
	[window makeKeyAndVisible];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption {
    [self applicationDidFinishLaunching:application];
    return YES;
}


- (void)showHomeViewController {
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
}

@end
