//
//  CallHistory.h
//  eXo Platform
//
//  Created by vietnq on 10/9/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExoContact.h"

@interface CallHistory : NSObject <NSCoding>
@property (nonatomic, copy) NSString *caller;
@property (nonatomic, assign) int direction ; //incoming = 0|| outcoming = 1
@property (nonatomic, retain) NSDate *date;
@end
