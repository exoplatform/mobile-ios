//
//  Configuration.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXMLDocument.h"
#import "CXMLNode.h"
#import "CXMLElement.h"

@interface ServerObj : NSObject {
    NSString*   _strServerName;
    NSString*   _strServerUrl;
    BOOL        _bSystemServer;
}
@property BOOL _bSystemServer;
@property (nonatomic, retain) NSString* _strServerName;
@property (nonatomic, retain) NSString* _strServerUrl;
@end

//======================================================================
@interface ServerPreferencesManager : NSObject {
    NSMutableArray*        _arrServerList;
}

@property (nonatomic, assign) int selectedServerIndex;
@property (nonatomic, readonly) NSString *selectedDomain;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

+ (ServerPreferencesManager*)sharedInstance;
- (NSMutableArray *)serverList;
- (void)loadServerList;
- (CXMLNode*) getNode: (CXMLNode*) element withName: (NSString*) name;
- (NSString*) getNodeValue: (CXMLNode*) node withName: (NSString*) name;
- (NSMutableArray*)parseConfiguration:(NSData*)data withBSystemSever:(BOOL)bSystemServer;
- (NSData*)createXmlDataWithServerList:(NSMutableArray*)arrServerList;
- (NSMutableArray*)loadSystemConfiguration;
- (NSMutableArray*)loadDeletedSystemConfiguration;
- (NSMutableArray*)loadUserConfiguration;
- (NSData*)readFileWithName:(NSString*)strFileName;
//Saved the deleted system Configuration to the /app/documents
- (void)writeSystemConfiguration:(NSMutableArray*)arrSystemServerList;
- (void)writeDeletedSystemConfiguration:(NSMutableArray*)arrDeletedSystemServerList;
- (BOOL)writeUserConfiguration:(NSMutableArray*)arrUserSystemServerList;
- (BOOL)writeData:(NSData*)data toFile:(NSString*)strFileName;
// Save username and password to the user preference.
- (void)persistUsernameAndPasswod;
// Reload username and password from user preference
- (void)reloadUsernamePassword;
@end
