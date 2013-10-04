//
//  ExoWeemoHandler.h
//  eXo Platform
//
//  Created by vietnq on 10/3/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iOS-SDK/Weemo.h>

@interface ExoWeemoHandler : NSObject <WeemoDelegate>

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, assign) BOOL isAuthenticated;

+ (ExoWeemoHandler *)sharedInstance;
- (void) connect;

#pragma mark - optional delegate methods used
- (void)weemoContact:(NSString*)contact canBeCalled:(BOOL)can;
- (void)weemoDidDisconnect:(NSError*)error;
- (void)weemoCallCreated:(WeemoCall *)call;
- (void)weemoCallEnded:(WeemoCall *)call;

@end
