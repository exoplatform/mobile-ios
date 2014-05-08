//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
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
