//
//  eXoAccount.h
//  eXoApp
//
//  Created by Tran Hoai Son on 5/9/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eXoUserClient.h"

@interface eXoAccount : NSObject<eXoUserClientDelegate> {

}
+ (id)instance;
+ (id)newInstance;

- (NSString*)userName;
- (NSString*)password;
- (NSString*)userId;

- (void)setUsername:(NSString*)username;
- (void)setPassword:(NSString*)password;

- (BOOL)valid;

- (void)getUserId;
- (void)getUserId:(NSString*)userName;

@end

