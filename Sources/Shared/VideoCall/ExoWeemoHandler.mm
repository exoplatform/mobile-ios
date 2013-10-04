//
//  ExoWeemoHandler.m
//  eXo Platform
//
//  Created by vietnq on 10/3/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "ExoWeemoHandler.h"
#define URLReferer @"ecro7etqvzgnmc2e"

@implementation ExoWeemoHandler
@synthesize userId = _userId;
@synthesize displayName = _displayName;

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

#pragma mark WeemoDelegate methods

- (void)weemoDidConnect:(NSError *)error
{
    if(error) {
        NSLog(@">>>WeemoHandler: %@", [error description]);
    } else {
        NSLog(@">>>WeemoHandler: starting authenticating");
        [[Weemo instance] authenticateWithToken:self.userId andType:USERTYPE_INTERNAL];
    }
    
}

- (void)weemoDidAuthenticate:(NSError *)error
{
    if(!error) {
        NSLog(@">>>WeemoHandler: authenticated OK");
        self.isAuthenticated = YES;
        //TODO: set display name
    } else {
        NSLog(@">>>WeemoHandler: authenticated NOK");
        self.isAuthenticated = NO;
    }
}

- (void)weemoDidDisconnect:(NSError *)error
{
    NSLog(@">>>>DISCONNECT<<<<<<");
    NSLog(@"%@", [error description]);
}
- (void)weemoCallCreated:(WeemoCall *)call
{
    NSLog(@">>>WeemoHandler: call created");
}

- (void)weemoCallEnded:(WeemoCall *)call
{
    NSLog(@">>>WeemoHandler: call ended");
}

- (void)weemoContact:(NSString *)contactID canBeCalled:(BOOL)canBeCalled
{
    if(canBeCalled) {
        NSLog(@">>>WeemoHandler: %@ can be called", contactID);
    } else {
        NSLog(@">>>WeemoHandler: %@ cannot be called", contactID);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not available" message:@"This user is not availble now. Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        });
    }
}
@end
