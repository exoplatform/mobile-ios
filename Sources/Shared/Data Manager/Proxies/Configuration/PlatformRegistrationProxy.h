//
//  PlatformRegistrationProxy.h
//  eXo
//
//  Created by Work on 4/8/14.
//  Copyright (c) 2014 eXo Platform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface PlatformRegistrationProxy : NSObject <RKObjectLoaderDelegate>

@property (nonatomic, retain) NSString* username;

- (id)initWithUsername:(NSString*) user;
- (void)registerDeviceOnPlatform;

@end
