//
//  Connection.h
//  GateInMobile-iPad
//
//  Created by Tran Hoai Son on 5/27/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>

//Interact with server: Athentication, get data...
@interface Connection : NSObject 
{
	NSString *localDashboardGadgetsString_;
}

- (NSString*)stringEncodedWithBase64:(NSString*)str;	//Convert NSString to String64 
- (NSString*)stringOfAuthorizationHeaderWithUsername:(NSString*)username password:(NSString*)password;	//Athentication encoding
- (NSString*)getExtend:(NSString*)domain;	//Get sub URL path
- (NSString*)getFirstLoginContent;	//Get data for fisrt time logined
- (NSString*)sendAuthenticateRequest:(NSString*)domain username:(NSString*)username password:(NSString*)password;	//Athenticate with server
- (NSData*)sendRequestToGetGadget:(NSString*)urlStr;	//Send request to get gadget data
- (NSData*)sendRequestWithAuthorization:(NSString*)urlStr;	//Send athenticated request 
- (NSData*)sendRequest:(NSString*)urlStr;	//Send request
- (NSData*)sendRequestWithAuthorization:(NSString*)urlStr;	//Send athenticated request
- (NSString*)loginForStandaloneGadget:(NSString*)domain;	//Get standalone gadget
- (NSMutableArray*)getItemsInDashboard;	//Get dashboard
- (NSString *)getStringForGadget:(NSString *)gadgetStr startStr:(NSString *)startStr endStr:(NSString *)endStr;	//Parser gadget data
- (NSMutableArray*)listOfGadgetsWithURL:(NSString *)url;	//List of gadget
@end
