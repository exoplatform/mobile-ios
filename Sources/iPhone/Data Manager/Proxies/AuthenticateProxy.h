//
//  AuthenticateProxy.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 22/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AuthenticateProxy : NSObject {
    
    
    
}

///---------------------------------------------------///
///      AUTHENTICATE METHODS USED BY FilesProxy      ///
///---------------------------------------------------///

- (NSData*)sendRequestWithAuthorization:(NSString*)urlStr;	//Send athenticated request (used 

@end
