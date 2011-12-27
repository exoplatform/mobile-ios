//
//  AuthenticateUnitest.h
//  eXo Platform
//
//  Created by Mai Gia Thanh Xuyen on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticateUnitest : NSObject

- (NSString*)signInWithWhenNoNetworkConnection;
- (NSString*)signInWithInvalidURL;

- (NSString*)signInWithUserPassword:(NSString*)host userName:(NSString*)userName password:(NSString*)password;
- (NSString*)signInWithValidUserPassword;
- (NSString*)signInWithInValidUserPassword;

@end
