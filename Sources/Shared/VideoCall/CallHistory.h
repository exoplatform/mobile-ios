//
//  CallHistory.h
//  eXo Platform
//
//  Created by vietnq on 10/9/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeemoContact.h"

@interface CallHistory : NSObject <NSCoding>
@property (nonatomic, copy) NSString *caller;
@property (nonatomic, copy) NSString *direction ; //incoming || outcoming
@property (nonatomic, retain) NSDate *date;
@end
