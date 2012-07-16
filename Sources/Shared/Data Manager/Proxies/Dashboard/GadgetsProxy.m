//
//  GadgetsProxy.m
//  eXo Platform
//
//  Created by Stévan on 26/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GadgetsProxy.h"
#import "GadgetItem.h"
#import "ServerPreferencesManager.h"

@interface GadgetsProxy () 

@property (nonatomic, retain) RKObjectManager *manager;

- (void)retrieveGadgets;

@end


@implementation GadgetsProxy

@synthesize dashboard = _dashboard, delegate=_delegate;
@synthesize manager = _manager;

-(id)initWithDashboardItem:(DashboardItem *)dashboardItem andDelegate:(id<GadgetsProxyDelegate>)delegateForProxy {

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
    self.manager.client.username = [NSString stringWithFormat:@"%@", [ServerPreferencesManager sharedInstance].username];
    self.manager.client.password = [NSString stringWithFormat:@"%@", [ServerPreferencesManager sharedInstance].password];    
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
