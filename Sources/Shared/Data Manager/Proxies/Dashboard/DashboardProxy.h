//
//  DashboardProxy.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 23/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "defines.h"

@interface DashboardProxy : NSObject {
    NSString *_localDashboardGadgetsString;
}

+ (DashboardProxy*)sharedInstance;
- (NSMutableArray*)getItemsInDashboard;	//Get dashboard


@end
