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
    
//    [[RKRequestQueue sharedQueue] abortRequestsWithDelegate:self];
    _delegate = nil;
}

#pragma mark - Call methods
- (void)retrieveGadgets {
    
    self.manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:_dashboard.link]];
    [self.manager.HTTPClient setAuthorizationHeaderWithUsername:[NSString stringWithFormat:@"%@", [UserPreferencesManager sharedInstance].username] password:[NSString stringWithFormat:@"%@", [UserPreferencesManager sharedInstance].password]];

    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[GadgetItem class]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"gadgetUrl":@"gadgetUrl",
     @"gadgetIcon":@"gadgetIcon",
     @"gadgetName":@"gadgetName",
     @"gadgetDescription":@"gadgetDescription"}
     ];
    
    RKResponseDescriptor * responseDescriptor  = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:@"" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [self.manager addResponseDescriptor:responseDescriptor];
    [self.manager getObjectsAtPath:@""  parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        _dashboard.arrayOfGadgets = [mappingResult array];
        //Ok response received, we can call the delegate to warn it that datas has been retrieved
        if (_delegate && [_delegate respondsToSelector:@selector(proxyDidFinishLoading:)]) {
            [_delegate proxyDidFinishLoading:self];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        //Need to prevent the delegate
        if (_delegate && [_delegate respondsToSelector:@selector(proxy:didFailWithError:)]) {
            [_delegate proxy:self didFailWithError:error];
        }
    }];
}



@end
