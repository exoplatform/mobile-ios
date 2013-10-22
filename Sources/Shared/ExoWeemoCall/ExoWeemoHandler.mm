//
//  ExoWeemoHandler.m
//  eXo Platform
//
//  Created by vietnq on 10/3/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "ExoWeemoHandler.h"
#import "AppDelegate_iPad.h"
#import "MenuViewController.h"
#import "RootViewController.h"
#import "AppDelegate_iPhone.h"

@implementation ExoWeemoHandler {
    UIAlertView *incomingCall;
}
@synthesize userId = _userId;
@synthesize displayName = _displayName;
@synthesize activeCallVC = _activeCallVC;
@synthesize authenticated = _authenticated;

+ (ExoWeemoHandler*)sharedInstance
{
	static ExoWeemoHandler *sharedInstance;
	@synchronized(self)
	{
		if(!sharedInstance)
		{
			sharedInstance = [[ExoWeemoHandler alloc] init];
        }
		return sharedInstance;
	}
	return sharedInstance;
}


- (void)connect
{
    self.authenticated = NO;
    NSError *error;
    [Weemo WeemoWithURLReferer:URLReferer andDelegate:self error:&error];
}

- (void)dealloc
{
    [super dealloc];
    [_displayName release];
    _displayName = nil;
    [_activeCallVC release];
    _activeCallVC = nil;
}

- (void)addCallView
{
	NSLog(@">>>> addCallView ");
	if(!_activeCallVC) {
        [self createCallView];
    }
    
    UIViewController *rootVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    if(_activeCallVC.view.superview == rootVC.view) {
        return;
    }
        
    _activeCallVC.view.frame =  CGRectMake(0., 0., rootVC.view.frame.size.width, rootVC.view.frame.size.height);
    
	[rootVC.view addSubview:_activeCallVC.view];
    
    
}

- (void)removeCallView
{
    [_activeCallVC removeFromParentViewController];
    [_activeCallVC.view removeFromSuperview];
    _activeCallVC = nil;
}

- (void)createCallView
{
	NSLog(@">>>> createCallView");
		
    if(_activeCallVC) {
        _activeCallVC.call = [[Weemo instance] activeCall];
        return;
    }
    
    BOOL isIpad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;

    _activeCallVC = [[CallViewController alloc] initWithNibName:isIpad ? @"CallViewController_iPad" : @"CallViewController_iPhone" bundle:nil];
	
    _activeCallVC.call = [[Weemo instance] activeCall];
    
    [[[Weemo instance] activeCall] setDelegate:_activeCallVC];
    
    UIViewController *rootVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    [rootVC addChildViewController:_activeCallVC];

}

- (void)setCallStatus:(int)newStatus
{
	dispatch_async(dispatch_get_main_queue(), ^{
		switch (newStatus) {
			case CALLSTATUS_ACTIVE:
			{
				NSLog(@">>> Call Active");
				[self createCallView];
				[self addCallView];
			}break;
			case CALLSTATUS_PROCEEDING:
			{
				NSLog(@">>>> Call Proceeding");
				[self createCallView];
			}break;
			case CALLSTATUS_INCOMING:
			{
				NSLog(@">>>> Call Incoming");
				[self createCallView];
//				[self addCallView];
			}break;
			case CALLSTATUS_ENDED:
			{
				[self removeCallView];
				
			}break;
			default:
			{
				
			}
            break;
		}
	});
}

#pragma mark WeemoDelegate methods

- (void)weemoDidConnect:(NSError *)error
{
    if(error) {
        NSLog(@">>>WeemoHandler: %@", [error description]);
    } else {
        [[Weemo instance] authenticateWithToken:self.userId andType:USERTYPE_INTERNAL];
    }
}

- (void)weemoDidAuthenticate:(NSError *)error
{
    if(!error) {
        //TODO: set display name
        [[Weemo instance] setDisplayName:self.displayName];
        self.authenticated = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateMenuView]; //update the indicator for authentication status
        });
        
    } else {
        NSLog(@"%@", [error description]);
    }
}

- (void)weemoDidDisconnect:(NSError *)error
{
    if(error) {
      NSLog(@">>>WeemoHandler: %@", [error description]);
    } else {
        NSLog(@">>>WeemoHandler: weemo did disconnect");
    }
    
}

- (void)weemoCallCreated:(WeemoCall*)call
{
	NSLog(@">>>> Controller callCreated: 0x%X", [call callStatus]);
    
    [self addToCallHistory:call];
	
    if ([call callStatus] == CALLSTATUS_INCOMING) {
        
		incomingCall = [[UIAlertView alloc]initWithTitle:Localize(@"Incoming Call")
                                                 message:[NSString stringWithFormat:Localize(@"Someone is calling"), [call contactID]]
                                                delegate:self
                                       cancelButtonTitle:Localize(@"Pick-up")
                                       otherButtonTitles:Localize(@"Deny"), nil];
        
		dispatch_async(dispatch_get_main_queue(), ^{
			[incomingCall show];
		});
    } else {
        [self setCallStatus:[call callStatus]];
    }
}


- (void)weemoCallEnded:(WeemoCall *)call
{
    dispatch_async(dispatch_get_main_queue(), ^{
		[self removeCallView];
		[incomingCall dismissWithClickedButtonIndex:1 animated:YES];
		incomingCall = nil;
	});
}

- (void)weemoContact:(NSString *)contactID canBeCalled:(BOOL)canBeCalled
{
    if(canBeCalled) {
        NSLog(@">>>WeemoHandler: %@ can be called", contactID);
    } else {
        NSLog(@">>>WeemoHandler: %@ cannot be called", contactID);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *message = [NSString stringWithFormat:Localize(@"ContactNotAvailableMessage"), contactID];
            
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:Localize(@"ContactNotAvailableTitle") message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
            [alert show];
        });
    }
}

#pragma mark - dealing with the incoming call
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == incomingCall) {
        if (buttonIndex == 0)
        {
            //user took the call
            [self createCallView];
            [self addCallView];
            [self setCallStatus:[[[Weemo instance] activeCall]callStatus]];
            [[[Weemo instance] activeCall]resume];
        } else {
            //user hangup
            [self removeCallView];
            [[[Weemo instance] activeCall]hangup];
        }
    }
}

- (void) addToCallHistory:(WeemoCall *)call
{
    //save call history
    CallHistory *entry = [[CallHistory alloc] init];
    entry.direction = ([call callStatus] == CALLSTATUS_INCOMING) ? 0 : 1;
    entry.caller = call.contactID;
    entry.date = [[NSDate alloc] init];
    
    CallHistoryManager *historyManager = [CallHistoryManager sharedInstance];
    [historyManager.history addObject:entry];
    [historyManager saveHistory];
}

- (void) updateMenuView
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        AppDelegate_iPad *ipadDelegate = [AppDelegate_iPad instance];
        
        RootViewController *rootVC = ipadDelegate.rootViewController;
        if(rootVC) {
            MenuViewController *menuVC = rootVC.menuViewController;
            
            [menuVC updateCellForVideoCall];
        }
    } else {
        AppDelegate_iPhone *iphoneDelegate = [AppDelegate_iPhone instance];
        HomeSidebarViewController_iPhone *homeVC = iphoneDelegate.homeSidebarViewController_iPhone;
        if(homeVC) {
            [homeVC updateCellForVideoCall];
        }
    }
}
@end
