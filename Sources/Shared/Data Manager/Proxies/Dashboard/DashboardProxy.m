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
    [[RKRequestQueue sharedQueue] abortRequestsWithDelegate:self];
    [_gadgetsProxy release];
    [_setOfDashboardsToRetrieveGadgets release];
    [super dealloc];
}


#pragma mark - helper methods

//Helper to create the base URL
- (NSString *)createBaseURL {    
    return [NSString stringWithFormat:@"%@/%@/",[SocialRestConfiguration sharedInstance].domainName,kRestContextName]; 
}



#pragma mark - Call methods

- (void)retrieveDashboards {
    // Load the object model via RestKit
    RKObjectManager* manager = [RKObjectManager sharedManager];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[DashboardItem class]];
    [mapping mapKeyPathsToAttributes:
     @"id",@"idDashboard",
     @"link",@"link",
     @"html",@"html",
     @"label",@"label",
     nil];
    
    [manager loadObjectsAtResourcePath:@"private/dashboards" objectMapping:mapping delegate:self];          
}



#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    LogTrace(@"Loaded payload: %@", [response bodyAsString]);
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    LogTrace(@"Loaded statuses: %@", objects);    
    //We receive the response from the server
    
    //Store dahsboards collected
    self.arrayOfDashboards = objects;
    
    //Prepare the set of dashboard where we will need to make request to retrieve gadgets
    _setOfDashboardsToRetrieveGadgets = [[NSMutableSet alloc] initWithArray:objects];
    
    [self loadGadgetsFromSet];
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    //We need to prevent the caller
    if (_delegate && [_delegate respondsToSelector:@selector(dashboardProxy:didFailWithError:)]) {
        [_delegate dashboardProxy:self didFailWithError:error];
    }
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
