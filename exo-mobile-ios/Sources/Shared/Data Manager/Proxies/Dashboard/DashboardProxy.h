//
//  DashboardProxy.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 26/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "SocialRestConfiguration.h"
#import "GadgetsProxy.h"

@protocol DashboardProxyDelegate;


@interface DashboardProxy : NSObject<RKObjectLoaderDelegate, GadgetsProxyDelegate> {
    
    BOOL _isPlatformCompatibleWithSocialFeatures;
    
    id<DashboardProxyDelegate> _delegate;
    
    NSArray *_arrayOfDashboards; //Array of dashboards retrieved
    
    NSMutableSet *_setOfDashboardsToRetrieveGadgets; //Set used to make request to retrieve gadgets
    
    GadgetsProxy *_gadgetsProxy;
    
}

@property (nonatomic, retain) NSArray *arrayOfDashboards;
@property (nonatomic, assign) id<DashboardProxyDelegate> delegate;

-(id)initWithDelegate:(id<DashboardProxyDelegate>)delegate;
- (void)retrieveDashboards;

@end


@protocol DashboardProxyDelegate<NSObject>
- (void)dashboardProxyDidFinish:(DashboardProxy *)proxy; //Method called when all dashboards has been retrieved
- (void)dashboardProxy:(DashboardProxy *)proxy didFailWithError:(NSError *)error; //Error method called when the dahsboard call has failed
- (void)dashboardProxyDidFailForDashboard:(DashboardItem *)dashboard; //Error to load gadgets from one specific dashboard
@end