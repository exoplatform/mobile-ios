//
//  AuthenticateProxy.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 22/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import <Foundation/Foundation.h>



// This class manage is a proxy to make all requests
// concerning the Authenticate over PLF 3.5 and PLF 3.0
//
// It's a singleton and is intanciate only one time


@interface AuthenticateProxy : NSObject {
    NSString* _username;
    NSString* _password;
    NSString* _firstLoginContent;
    NSString* _domainName;
}

@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* password;
@property (nonatomic, copy) NSString* firstLoginContent;
@property (nonatomic, copy) NSString* domainName;


+ (AuthenticateProxy*)sharedInstance;
- (BOOL)isReachabilityURL:(NSString *)urlStr userName:(NSString *)userName password:(NSString *)password;
- (NSString*)sendAuthenticateRequest:(NSString*)domain username:(NSString*)username password:(NSString*)password;	//Athenticate with server
- (NSString*)stringOfAuthorizationHeaderWithUsername:(NSString*)username password:(NSString*)password;

- (NSData*)sendRequestWithAuthorization:(NSString*)urlStr;	//Send athenticated request 
- (NSString*)loginForStandaloneGadget:(NSString*)domain;	//Get standalone gadget

@end
