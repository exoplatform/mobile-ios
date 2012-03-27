//
//  Connection.h
//  GateInMobile-iPad
//
//  Created by Tran Hoai Son on 5/27/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Connection : NSObject 
{
	NSString*				_strUsername;
	NSString*				_strPassword;
	NSString*				_strFirstLoginContent;
}

@property (nonatomic, retain) NSString* _strUsername;
@property (nonatomic, retain) NSString* _strPassword;

- (NSString*)stringEncodedWithBase64:(NSString*)str;
- (NSString*)stringOfAuthorizationHeaderWithUsername:(NSString*)username password:(NSString*)password;
- (NSString*)getExtend:(NSString*)domain;
- (NSString*)getFirstLoginContent;
- (NSString*)sendAuthenticateRequest:(NSString*)domain username:(NSString*)username password:(NSString*)password;
- (NSData*)sendRequestToSocialToGetGadget:(NSString*)urlStr;
- (NSData*)sendRequestToGetGadget:(NSString*)urlStr;
- (NSData*)sendRequestWithAuthorization:(NSString*)urlStr;
- (NSData*)sendRequest:(NSString*)urlStr;
- (NSData*)sendRequestWithAuthorization:(NSString*)urlStr;
@end
