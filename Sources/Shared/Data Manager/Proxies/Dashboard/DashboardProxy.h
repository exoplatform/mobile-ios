//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "SocialRestConfiguration.h"
#import "GadgetsProxy.h"

@protocol DashboardProxyDelegate;


@interface DashboardProxy : NSObject<GadgetsProxyDelegate> {
    
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
