//
//  GadgetsProxy.h
//  eXo Platform
//
//  Created by Stévan on 26/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "DashboardItem.h"

@protocol GadgetsProxyDelegate;


@interface GadgetsProxy : NSObject<RKObjectLoaderDelegate>  {

    DashboardItem *_dashboard;
    
    id<GadgetsProxyDelegate> _delegate;
    
}

@property (retain, nonatomic) DashboardItem *dashboard;
@property (nonatomic, assign) id<GadgetsProxyDelegate> delegate;

-(id)initWithDashboardItem:(DashboardItem *)dashboardItem andDelegate:(id<GadgetsProxyDelegate>)delegateForProxy;
-(void)retrieveGadgetsForDashboardItem:(DashboardItem *)dashboardItem;

@end



@protocol GadgetsProxyDelegate<NSObject>
- (void)proxyDidFinishLoading:(GadgetsProxy *)proxy;
- (void)proxy:(GadgetsProxy *)proxy didFailWithError:(NSError *)error;	
@end