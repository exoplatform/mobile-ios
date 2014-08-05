//
//  PlatformRegistration.h
//  eXo
//
//  Created by Work on 4/8/14.
//  Copyright (c) 2014 eXo Platform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlatformRegistration : NSObject

@property (nonatomic, retain) NSString *deviceToken;
@property (nonatomic, retain) NSString *platform;
@property (nonatomic, retain) NSString *username;

@end
