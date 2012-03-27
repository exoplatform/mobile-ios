//
//  httpClient.h
//  eXoApp
//
//  Created by Tran Hoai Son on 5/9/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface httpClient : NSObject {
    NSURLConnection*		_connection;
    NSMutableData*			_receivedData;
	int						_statusCode;	
	BOOL					_isXmlTypeContent;

	BOOL					endGetData;

}

@property (readonly) NSMutableData*	_receivedData;
@property (readonly) int _statusCode;

+ (NSString*)getFirstLoginContent;
+ (NSString*)getFullDomainStr;
- (void)requestGET:(NSString*)url;
- (void)requestGET:(NSString*)url username:(NSString*)username password:(NSString*)password;
- (void)requestPOST:(NSString*)url body:(NSString*)body username:(NSString*)login password:(NSString*)password;
- (void)cancel;
- (void)requestSucceeded;
- (void)requestFailed:(NSError*)error;
//- (BOOL)sendAuthenticateRequest:(NSString*)urlStr username:(NSString*)username password:(NSString*)password;
//- (NSString*)sendAuthenticateRequest:(NSString*)urlStr username:(NSString*)username password:(NSString*)password;
- (NSString*)sendAuthenticateRequest:(NSString*)domain username:(NSString*)username password:(NSString*)password;
+ (NSString*)URLForEXOWithAccount;
+ (NSString*)stringEncodedWithBase64:(NSString*)str;
+ (NSString*)stringOfAuthorizationHeaderWithUsername:(NSString*)username password:(NSString*)password;
+ (NSData*)sendRequest:(NSString*)urlStr;
+ (NSData*)sendRequestWithAuthorization:(NSString*)urlStr;
+ (NSData*)sendRequestToGetGadget:(NSString*)urlStr username:(NSString*)username password:(NSString*)password;
@end
