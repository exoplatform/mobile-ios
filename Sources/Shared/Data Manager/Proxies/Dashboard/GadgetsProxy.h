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
#import "DashboardItem.h"

@protocol GadgetsProxyDelegate;


@interface GadgetsProxy : NSObject  {

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
