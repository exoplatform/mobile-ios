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


//--------------------------------------
//-        Actions Definition          -
//--------------------------------------

#define kFileProtocolForDelete @"DELETE"
#define kFileProtocolForUpload @"UPLOAD"
#define kFileProtocolForCopy @"COPY"
#define kFileProtocolForMove @"MOVE"


@interface FilesProxy : NSObject {
    
    AuthenticateProxy *_authenticateProxy;
    NSString *_strUserRepository;
}

+ (NSString*)stringEncodedWithBase64:(NSString*)str;
+ (NSString*)stringOfAuthorizationHeaderWithUsername:(NSString*)username password:(NSString*)password;	//Athentication encoding


// Use this method to create the first initial file
- (File *)initialFileForRootDirectory:(BOOL)isCompatibleWithPlatform35;

//Use this method to retrieve the content of a virtual drive
- (NSMutableArray*)getPersonalDriveContent:(File *)file;

//Use this method to do some actions over files (DELETE, PUT, COPY, PASTE...)
//Return en error Message
-(NSString *)fileAction:(NSString *)protocol source:(NSString *)source destination:(NSString *)destination data:(NSData *)data;

-(BOOL)createNewFolderWithURL:(NSString *)strUrl folderName:(NSString *)name;
-(BOOL)isExistedUrl:(NSString *)strUrl;

@end
