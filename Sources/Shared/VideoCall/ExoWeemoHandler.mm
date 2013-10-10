//
//  ExoWeemoHandler.m
//  eXo Platform
//
//  Created by vietnq on 10/3/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "ExoWeemoHandler.h"
#import "CallViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "DialViewController_iPhone.h"
#import "CallHistoryManager.h"
#import "CallHistory.h"

@implementation ExoWeemoHandler {
    UIAlertView *incomingCall;
}
@synthesize userId = _userId;
@synthesize displayName = _displayName;
@synthesize activeCallVC = _activeCallVC;
@synthesize updatedVC = _updatedVC;

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
    NSError *error;
    [Weemo WeemoWithURLReferer:URLReferer andDelegate:self error:&error];
}

- (void)dealloc
{
    [super dealloc];
    [_displayName release];
    _displayName = nil;
}

- (void)addCallView
{
	NSLog(@">>>> addCallView ");
	[self createCallView];
    
    UIViewController *rootVC = [AppDelegate_iPhone instance].window.rootViewController;
    [rootVC addChildViewController:self.activeCallVC];
    
    self.activeCallVC.view.frame =  CGRectMake(0., 0., rootVC.view.frame.size.width, rootVC.view.frame.size.height);
    
    [rootVC addChildViewController:self.activeCallVC];
    
	[rootVC.view addSubview:self.activeCallVC.view];
}

- (void)removeCallView
{
	[self.activeCallVC removeFromParentViewController];
	[self.activeCallVC.view removeFromSuperview];
	self.activeCallVC = nil;
}

- (void)createCallView
{
	NSLog(@">>>> createCallView");
		
    //TODO: iPad
    self.activeCallVC = [[CallViewController_iPhone alloc] initWithNibName:@"CallViewController_iPhone" bundle:nil];
		
    [[[Weemo instance] activeCall] setDelegate:self.activeCallVC];
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
				[self addCallView];
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
        if(self.updatedVC && [self.updatedVC isKindOfClass:[DialViewController_iPhone class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DialViewController_iPhone *contactsVC = (DialViewController_iPhone *)self.updatedVC;
                [contactsVC.indicator stopAnimating];
                [contactsVC updateViewWithConnectionStatus:NO];
            });
        }
    } else {
        [[Weemo instance] authenticateWithToken:self.userId andType:USERTYPE_INTERNAL];
    }
    
}

- (void)weemoDidAuthenticate:(NSError *)error
{
    if(!error) {
        //TODO: set display name
        [[Weemo instance] setDisplayName:self.displayName];
        
        if(self.updatedVC && [self.updatedVC isKindOfClass:[DialViewController_iPhone class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DialViewController_iPhone *contactsVC = (DialViewController_iPhone *)self.updatedVC;
                [contactsVC.indicator stopAnimating];
                [contactsVC updateViewWithConnectionStatus:YES];
            });
        }
    } else {
        if(self.updatedVC && [self.updatedVC isKindOfClass:[DialViewController_iPhone class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DialViewController_iPhone *contactsVC = (DialViewController_iPhone *)self.updatedVC;
                [contactsVC.indicator stopAnimating];
                [contactsVC updateViewWithConnectionStatus:NO];
            });
        }
    }
}

- (void)weemoDidDisconnect:(NSError *)error
{
    NSLog(@"%@", [error description]);
}

- (void)weemoCallCreated:(WeemoCall*)call
{
	NSLog(@">>>> Controller callCreated: 0x%X", [call callStatus]);
    
    [self addToCallHistory:call];
	
    if ([call callStatus] == CALLSTATUS_INCOMING) {
        
		incomingCall = [[UIAlertView alloc]initWithTitle:@"Incoming Call"
                                                 message:[NSString stringWithFormat:@"%@ is calling", [call contactID]]
                                                delegate:self
                                       cancelButtonTitle:@"Pick-up"
                                       otherButtonTitles:@"Deny", nil];
        
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
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Not available" message:@"Please check the caller id or try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
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
    entry.direction = ([call callStatus] == CALLSTATUS_INCOMING) ? @"Incoming" : @"Outcoming";
    entry.caller = call.contactID;
    entry.date = [[NSDate alloc] init];
    
    CallHistoryManager *historyManager = [CallHistoryManager sharedInstance];
    [historyManager.history addObject:entry];
    [historyManager saveHistory];
}
@end
