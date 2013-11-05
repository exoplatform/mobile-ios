//
//  ExoWeemoUtils.m
//  eXo Platform
//
//  Created by vietnq on 10/17/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "ExoWeemoUtils.h"
#import "ExoWeemoHandler.h"

@implementation ExoWeemoUtils

+ (UIView *)offlineView
{
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor redColor];
    label.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"Offline";
    label.tag = OFFLINE_VIEW_TAG;
    
    return label;
}

@end
