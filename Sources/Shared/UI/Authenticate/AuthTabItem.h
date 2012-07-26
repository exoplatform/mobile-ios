//
//  AuthTabItem.h
//  eXo Platform
//
//  Created by exoplatform on 7/23/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import "JMTabItem.h"

typedef enum {
    DeviceIphone = 0,
    DeviceIpad = 1
} DeviceType;

@interface AuthTabItem : JMTabItem {

    DeviceType _device;
}
@property (nonatomic,retain) UIImage * alternateIcon;

+ (AuthTabItem *)tabItemWithTitle:(NSString *)title icon:(UIImage *)icon alternateIcon:(UIImage *)icon device:(DeviceType)deviceType;
- (void) setDeviceType:(DeviceType)deviceType;
@end
