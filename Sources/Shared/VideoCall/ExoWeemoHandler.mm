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

//the mobile app identifier provided by Weemo
#define URLReferer @"ecro7etqvzgnmc2e"

@implementation ExoWeemoHandler {
    UIAlertView *incomingCall;
    UIViewController *appRootVC;
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
    NSLog(@">>>WeemoHandler: starting connecting");
    NSError *error = nil;
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
	if (!self.activeCallVC) [self createCallView];
    
    //TODO: iPad
    appRootVC = [AppDelegate_iPhone instance].window.rootViewController;
    
	if ([[[self.activeCallVC view] superview] isEqual:[appRootVC view]] )
	{
		return;
	}
    
	[[self.activeCallVC view] setFrame:CGRectMake(0., 0., [[appRootVC view]frame].size.width, [[appRootVC view] frame].size.height)];
	[[appRootVC view] addSubview:[self.activeCallVC view]];
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
	if (self.activeCallVC) {
        self.activeCallVC.call = [[Weemo instance] activeCall];
        return;
    }
	
    BOOL isIPhone = ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
	NSString *nibName = isIPhone?@"CallViewController_iPhone":@"CallViewController_iPad";
	
    //TODO: iPad
    self.activeCallVC = [[CallViewController_iPhone alloc] initWithNibName:nibName bundle:nil];
	self.activeCallVC.call = [[Weemo instance] activeCall];
	
    [[[Weemo instance] activeCall] setDelegate:self.activeCallVC];
	
    [[AppDelegate_iPhone instance].window.rootViewController addChildViewController:self.activeCallVC];
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
        NSLog(@">>>WeemoHandler: starting authenticating");
        [[Weemo instance] authenticateWithToken:self.userId andType:USERTYPE_INTERNAL];
    }
    
}

- (void)weemoDidAuthenticate:(NSError *)error
{
    if(!error) {
        NSLog(@">>>WeemoHandler: authenticated OK");
        
        if(self.updatedVC && [self.updatedVC isKindOfClass:[DialViewController_iPhone class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DialViewController_iPhone *contactsVC = (DialViewController_iPhone *)self.updatedVC;
                [contactsVC.indicator stopAnimating];
                [contactsVC updateViewWithConnectionStatus:YES];
            });
        }
        //TODO: set display name
    } else {
        NSLog(@">>>WeemoHandler: authenticated NOK");
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
    NSLog(@">>>>DISCONNECT<<<<<<");
    NSLog(@"%@", [error description]);
}

- (void)weemoCallCreated:(WeemoCall*)call
{
	NSLog(@">>>> Controller callCreated: 0x%X", [call callStatus]);
	if ([call callStatus] == CALLSTATUS_INCOMING)
	{
		incomingCall = [[UIAlertView alloc]initWithTitle:@"Incoming Call"
                                                 message:[NSString stringWithFormat:@"%@ is calling", [call contactID]]
                                                delegate:self
                                       cancelButtonTitle:@"Pick-up"
                                       otherButtonTitles:@"Deny", nil];
		dispatch_async(dispatch_get_main_queue(), ^{
			[incomingCall show];
		});
	}
	[self setCallStatus:[call callStatus]];
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
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Not available" message:@"This user is not availble now. Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
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

@end
