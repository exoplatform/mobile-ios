//
//  FilesProxy.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 22/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthenticateProxy.h"
#import "File.h"


@interface FilesProxy : NSObject {
    
    AuthenticateProxy *_authenticateProxy;
    
}

+ (NSString*)stringEncodedWithBase64:(NSString*)str;
+ (NSString*)stringOfAuthorizationHeaderWithUsername:(NSString*)username password:(NSString*)password;	//Athentication encoding


// Use this method to create the first initial file
- (File *)initialFileForRootDirectory;

//Use this method to retrieve the content of a virtual drive
- (NSMutableArray*)getPersonalDriveContent:(File *)file;



@end
