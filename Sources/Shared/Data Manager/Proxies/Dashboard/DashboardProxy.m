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

#import "DashboardProxy.h"
#import "defines.h"
#import "DashboardItem.h"

@interface DashboardProxy (PrivateMethods)
-(void)loadGadgetsFromSet;
@end


@implementation DashboardProxy

@synthesize delegate = _delegate;
@synthesize arrayOfDashboards = _arrayOfDashboards;


-(instancetype)initWithDelegate:(id<DashboardProxyDelegate>)delegate {
    if ((self = [super init])) {
        _delegate = delegate;
    }
    return self;
}

- (void) dealloc {
        
    _delegate = nil;
    _gadgetsProxy.delegate = nil;
}


#pragma mark - Call methods

- (void)retrieveDashboards {
    // Load the object model via RestKit
    RKObjectManager* manager = [RKObjectManager sharedManager];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[DashboardItem class]];
    [mapping addAttributeMappingsFromDictionary:@{ @"id": @"idDashboard", @"link": @"link", @"html": @"html",@"label": @"label" }];
    
    RKResponseDescriptor* responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:@"private/dashboards" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];

    [manager addResponseDescriptor:responseDescriptor];
    
    [manager getObjectsAtPath:@"private/dashboards" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
    {
        self.arrayOfDashboards = [mappingResult array];
        _setOfDashboardsToRetrieveGadgets = [[NSMutableSet alloc] initWithArray: [mappingResult array]];
        [self loadGadgetsFromSet];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(dashboardProxy:didFailWithError:)]) {
            [_delegate dashboardProxy:self didFailWithError:error];
        }
    }];

}



- (void)finishLoadingGadgets {
    
    //We complete the loading of Gadgets, so now we need to prevent the controller
    if (_delegate && [_delegate respondsToSelector:@selector(dashboardProxyDidFinish:)]) {
        [_delegate dashboardProxyDidFinish:self];
    }
}


#pragma mark - GadgetsProxy Management

- (void)loadGadgetsFromSet {
    if ([_setOfDashboardsToRetrieveGadgets count] != 0) {
        
        DashboardItem *tmpDashboard = [_setOfDashboardsToRetrieveGadgets anyObject];
        
        if (_gadgetsProxy == nil) {
            _gadgetsProxy = [[GadgetsProxy alloc] initWithDashboardItem:tmpDashboard andDelegate:self];
        } else {
            [_gadgetsProxy retrieveGadgetsForDashboardItem:tmpDashboard];
        }
        
        [_setOfDashboardsToRetrieveGadgets removeObject:tmpDashboard];

    }
    else
    {
        [self finishLoadingGadgets];
    }
}



#pragma mark - GadgetsProxy Delegates methods

- (void)proxyDidFinishLoading:(GadgetsProxy *)proxy {
    if ([_setOfDashboardsToRetrieveGadgets count] == 0) {
        [self finishLoadingGadgets];
    } else {
        [self loadGadgetsFromSet];
    }
}



- (void)proxy:(GadgetsProxy *)proxy didFailWithError:(NSError *)error {
    
    //We encounter an error for retrieving gadgets from one dashboard
    //We need to raise an alert and prevent the controller for that
    if (_delegate && [_delegate respondsToSelector:@selector(dashboardProxyDidFailForDashboard:)]) {
        [_delegate dashboardProxyDidFailForDashboard:proxy.dashboard];
    }
    
    //Continue to retrieve other dashboards
    if ([_setOfDashboardsToRetrieveGadgets count] == 0) {
        [self finishLoadingGadgets];
    } else {
        [self loadGadgetsFromSet];
    }
}



@end
