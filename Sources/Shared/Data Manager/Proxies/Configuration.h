//
//  Configuration.h
//  eXoPlatform
//
//  Created by Tran Hoai Son on 3/21/11.
//  Copyright 2011 home. All rights reserved.
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
@interface Configuration : NSObject {
    NSMutableArray*        _arrServerList;
}

+ (Configuration*)sharedInstance;
- (NSMutableArray*)getServerList;
- (CXMLNode*) getNode: (CXMLNode*) element withName: (NSString*) name;
- (NSString*) getNodeValue: (CXMLNode*) node withName: (NSString*) name;
- (NSMutableArray*)parseConfiguration:(NSData*)data withBSystemSever:(BOOL)bSystemServer;
- (NSData*)createXmlDataWithServerList:(NSMutableArray*)arrServerList;
- (NSMutableArray*)loadSystemConfiguration;
- (NSMutableArray*)loadDeletedSystemConfiguration;
- (NSMutableArray*)loadUserConfiguration;
- (NSData*)readFileWithName:(NSString*)strFileName;
//Saved the deleted system configuration to the /app/documents
- (void)writeSystemConfiguration:(NSMutableArray*)arrSystemServerList;
- (void)writeDeletedSystemConfiguration:(NSMutableArray*)arrDeletedSystemServerList;
- (void)writeUserConfiguration:(NSMutableArray*)arrUserSystemServerList;
- (void)writeData:(NSData*)data toFile:(NSString*)strFileName;
@end
