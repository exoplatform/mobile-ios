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
#import "CallHistoryManager.h"
#import "CallHistory.h"
#import "LanguageHelper.h"

//the mobile app identifier provided by Weemo
#define MOBILEAPPID @"ecro7etqvzgnmc2e"

@class ExoWeemoHandler;
@protocol ExoWeemoHandlerDelegate <NSObject>

- (void)weemoHandler:(ExoWeemoHandler *)weemoHandler updateUIWithStatus:(BOOL)canBeCalled ofContact:(NSString*)contactID;

@end

/*
 * A class to handle weemo call: connecting, authenticating,  
 * create/add/remove video call view controller
 */

@interface ExoWeemoHandler : NSObject <WeemoDelegate>

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, retain) CallViewController *activeCallVC;

//is user logged in to eXo Platform
@property (nonatomic, assign) BOOL isConnectedToExo;
@property (nonatomic, retain) id<ExoWeemoHandlerDelegate> delegate;
+ (ExoWeemoHandler *)sharedInstance;
- (void) connect;
- (void) disconnect;
- (void)addCallView;
- (void)removeCallView;
- (void)receiveCall;
@end


