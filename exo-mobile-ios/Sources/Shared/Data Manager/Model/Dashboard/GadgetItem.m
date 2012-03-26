//
//  GadgetItem.m
//  eXo Platform
//
//  Created by Stévan on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GadgetItem.h"

@implementation GadgetItem

@synthesize gadgetUrl = _gadgetUrl, gadgetIcon = _gadgetIcon, gadgetName = _gadgetName, gadgetDescription = _gadgetDescription;

- (void)dealloc {

    [_gadgetUrl release]; _gadgetUrl = nil;
    [_gadgetIcon release]; _gadgetIcon = nil;
    [_gadgetName release]; _gadgetName = nil;
    [_gadgetDescription release]; _gadgetDescription = nil;
    
    [super dealloc];
}


@end
