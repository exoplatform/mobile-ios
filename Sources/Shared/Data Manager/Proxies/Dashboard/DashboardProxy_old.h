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
