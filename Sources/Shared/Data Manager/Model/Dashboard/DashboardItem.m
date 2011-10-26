//
//  DashboardItem.m
//  eXo Platform
//
//  Created by Stévan on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashboardItem.h"

@implementation DashboardItem

@synthesize idDashboard = _idDashboard, link=_link, html=_html, label=_label, arrayOfGadgets=_arrayOfGadgets;

- (void)dealloc {
    
    [_idDashboard release]; _idDashboard = nil;
    [_link release]; _link = nil;
    [_html release]; _html = nil;
    [_label release]; _label = nil;
    [_arrayOfGadgets release]; _arrayOfGadgets = nil;
    
    [super dealloc];
}


@end
