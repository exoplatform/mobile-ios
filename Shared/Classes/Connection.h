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

}
///test
- (NSString*)loginForStandaloneGadget:(NSString*)domain;
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

- (NSMutableArray*)getItemsInDashboard;
- (NSString *)getStringForGadget:(NSString *)gadgetStr startStr:(NSString *)startStr endStr:(NSString *)endStr;
- (NSMutableArray*)listOfGadgetsWithURL:(NSString *)url;
- (NSMutableArray*)listOfStandaloneGadgetsWithURL:(NSString *)url;
@end
