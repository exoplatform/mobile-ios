//
//  GadgetsProxy.m
//  eXo Platform
//
//  Created by Stévan on 26/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GadgetsProxy.h"
#import "GadgetItem.h"


@interface GadgetsProxy (privateMethods) 
- (void)retrieveGadgets;
@end


@implementation GadgetsProxy

@synthesize dashboard = _dashboard, delegate=_delegate;


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

    [super dealloc];
}







#pragma mark - Call methods

- (void)retrieveGadgets {
    // Load the object model via RestKit
    if ([RKObjectManager sharedManager] == nil) {
        RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:_dashboard.link];  
        [RKObjectManager setSharedManager:manager];
    } else {
        [RKObjectManager sharedManager].client = [RKClient clientWithBaseURL:_dashboard.link];
    }
    RKObjectManager* manager = [RKObjectManager sharedManager];

        
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[GadgetItem class]];
    [mapping mapKeyPathsToAttributes:
     @"gadgetUrl",@"gadgetUrl",
     @"gadgetIcon",@"gadgetIcon",
     @"gadgetName",@"gadgetName",
     @"gadgetDescription",@"gadgetDescription",
     nil];
    
    [manager loadObjectsAtResourcePath:@"" objectMapping:mapping delegate:self];          
}



#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Loaded statuses: %@", objects);
    
    //Add gadgets into the dashboard
    _dashboard.arrayOfGadgets = objects;
    
    //Ok response received, we can call the delegate to warn it that datas has been retrieved
    if (_delegate && [_delegate respondsToSelector:@selector(proxyDidFinishLoading:)]) {
        [_delegate proxyDidFinishLoading:self];
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	//Error to retrieve 
    //Need to prevent the delegate
    if (_delegate && [_delegate respondsToSelector:@selector(proxy:didFailWithError:)]) {
        [_delegate proxy:self didFailWithError:error];
    }
    
}



@end
