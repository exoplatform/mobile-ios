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

#import "GadgetsProxy.h"
#import "GadgetItem.h"
#import "UserPreferencesManager.h"

@interface GadgetsProxy () 

@property (nonatomic, retain) RKObjectManager *manager;

- (void)retrieveGadgets;

@end


@implementation GadgetsProxy

@synthesize dashboard = _dashboard, delegate=_delegate;
@synthesize manager = _manager;

-(instancetype)initWithDashboardItem:(DashboardItem *)dashboardItem andDelegate:(id<GadgetsProxyDelegate>)delegateForProxy {

    if ((self = [super init])) {
    
        self.dashboard = dashboardItem;
        self.delegate = delegateForProxy;
        
        //Start retrieve gadgets
        [self retrieveGadgets];
    
    }

    return self;
}


-(void)retrieveGadgetsForDashboardItem:(DashboardItem *)dashboardItem {

    
    self.dashboard = dashboardItem;
    
    //Start retrieve gadgets
    [self retrieveGadgets];
}


-(void)dealloc {
    
    [[RKRequestQueue sharedQueue] abortRequestsWithDelegate:self];
    [_dashboard release];
    _delegate = nil;
    [_manager release];
    [super dealloc];
}

#pragma mark - Call methods
- (void)retrieveGadgets {
    // Load the object model via RestKit
    self.manager = [RKObjectManager objectManagerWithBaseURL:_dashboard.link];
    self.manager.client.username = [NSString stringWithFormat:@"%@", [UserPreferencesManager sharedInstance].username];
    self.manager.client.password = [NSString stringWithFormat:@"%@", [UserPreferencesManager sharedInstance].password];    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[GadgetItem class]];
    [mapping mapKeyPathsToAttributes:
     @"gadgetUrl",@"gadgetUrl",
     @"gadgetIcon",@"gadgetIcon",
     @"gadgetName",@"gadgetName",
     @"gadgetDescription",@"gadgetDescription",
     nil];
    
    [self.manager loadObjectsAtResourcePath:@"" objectMapping:mapping delegate:self];          
}



#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    LogTrace(@"Loaded payload: %@", [response bodyAsString]);
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {    
    //Add gadgets into the dashboard
    _dashboard.arrayOfGadgets = objects;
    
    //Ok response received, we can call the delegate to warn it that datas has been retrieved
    if (_delegate && [_delegate respondsToSelector:@selector(proxyDidFinishLoading:)]) {
        [_delegate proxyDidFinishLoading:self];
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {    
    //Need to prevent the delegate
    if (_delegate && [_delegate respondsToSelector:@selector(proxy:didFailWithError:)]) {
        [_delegate proxy:self didFailWithError:error];
    }
    
}



@end
