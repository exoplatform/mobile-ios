//
//  CallHistoryManager.h
//  eXo Platform
//
//  Created by vietnq on 10/9/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallHistoryManager : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, retain) NSMutableArray *history;
- (void) loadHistory;
- (void) saveHistory;
+ (CallHistoryManager *)sharedInstance;
@end
