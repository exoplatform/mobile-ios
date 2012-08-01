//
//  AuthTabItem.h
//  eXo Platform
//
//  Created by exoplatform on 7/23/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import "JMTabItem.h"

@interface AuthTabItem : JMTabItem

@property (nonatomic,retain) UIImage * alternateIcon;

+ (AuthTabItem *)tabItemWithTitle:(NSString *)title icon:(UIImage *)icon alternateIcon:(UIImage *)icon;

@end
