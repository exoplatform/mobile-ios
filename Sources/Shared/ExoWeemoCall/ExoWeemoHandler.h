//
//  ExoWeemoHandler.h
//  eXo Platform
//
//  Created by vietnq on 10/3/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iOS-SDK/Weemo.h>
#import "CallViewController.h"
#import "AppDelegate_iPhone.h"
#import "DialViewController_iPhone.h"
#import "CallHistoryManager.h"
#import "CallHistory.h"
#import "LanguageHelper.h"

//the mobile app identifier provided by Weemo
#define URLReferer @"ecro7etqvzgnmc2e"

/*
 * A class to handle weemo call: connecting, authenticating,  
 * create/add/remove video call view controller
 */
@interface ExoWeemoHandler : NSObject <WeemoDelegate>

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, retain) CallViewController *activeCallVC;
@property (nonatomic, retain) UIViewController *updatedVC;
@property (nonatomic, assign) BOOL authenticated;

+ (ExoWeemoHandler *)sharedInstance;
- (void) connect;

- (void)addCallView;
- (void)removeCallView;

#pragma mark - optional delegate methods used
- (void)weemoContact:(NSString*)contact canBeCalled:(BOOL)can;
- (void)weemoDidDisconnect:(NSError*)error;
@end
