//
//  DashboardProxy.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 23/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "defines.h"

@protocol DashboardProxyDelegate;


@interface DashboardProxy : NSObject {
    NSString *_localDashboardGadgetsString;
    NSObject<DashboardProxyDelegate> *proxyDelegate;
}

@property (nonatomic, retain) id<DashboardProxyDelegate> proxyDelegate;


+ (DashboardProxy*)sharedInstance;
- (void)startRetrievingGadgets;	//Get dashboard

@end


@protocol DashboardProxyDelegate<NSObject>
//Method called when gadgets has been retrieved
-(void)didFinishLoadingGadgets:(NSMutableArray *)arrGadgets;
//Method called when no gadgets has been found or error
-(void)didFailLoadingGadgetsWithError:(NSError *)error;
@end