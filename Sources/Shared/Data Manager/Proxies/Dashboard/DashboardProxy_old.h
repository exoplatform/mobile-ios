//
//  DashboardProxy_old.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 23/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "defines.h"

@protocol DashboardProxyDelegate_old;


@interface DashboardProxy_old : NSObject {
    NSString *_localDashboardGadgetsString;
    NSObject<DashboardProxyDelegate_old> *proxyDelegate;
}

@property (nonatomic, retain) id<DashboardProxyDelegate_old> proxyDelegate;


+ (DashboardProxy_old*)sharedInstance;
- (void)startRetrievingGadgets;	//Get dashboard

@end


@protocol DashboardProxyDelegate_old<NSObject>
//Method called when gadgets has been retrieved
-(void)didFinishLoadingGadgets:(NSMutableArray *)arrGadgets;
//Method called when no gadgets has been found or error
-(void)didFailLoadingGadgetsWithError:(NSError *)error;
@end
