//
//  AuthenticateUnitest.m
//  eXo Platform
//
//  Created by Mai Gia Thanh Xuyen on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthenticateUnitest.h"
#import "AuthenticateProxy.h"

@implementation AuthenticateUnitest

#define HOST @"http://192.168.1.124:8080"
#define INVALIDDATA @"test"
#define USER_NAME @"demo"
#define PASSWORD @"gtn"

//Make sure that you don't connect to internet
- (NSString*)signInWithWhenNoNetworkConnection {
    
    return [self signInWithUserPassword:HOST userName:INVALIDDATA password:INVALIDDATA];
}

- (NSString*)signInWithInvalidURL {
    return [self signInWithUserPassword:INVALIDDATA userName:INVALIDDATA password:INVALIDDATA];
}

- (NSString*)signInWithUserPassword:(NSString*)host userName:(NSString*)userName password:(NSString*)password; {
    return [[AuthenticateProxy sharedInstance] 
                                    sendAuthenticateRequest:host username:userName password:password];
}

- (NSString*)signInWithValidUserPassword {
    return [self signInWithUserPassword:HOST userName:USER_NAME password:PASSWORD];
}

- (NSString*)signInWithInValidUserPassword {
    return [self signInWithUserPassword:HOST userName:@" " password:@" "];
}


@end
