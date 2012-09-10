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

#pragma mark - Server Object Interface

@interface ServerObj : NSObject {
    NSString*   _strServerName;
    NSString*   _strServerUrl;
    BOOL        _bSystemServer;
}
@property BOOL _bSystemServer;
@property (nonatomic, retain) NSString* _strServerName;
@property (nonatomic, retain) NSString* _strServerUrl;
@end

#pragma mark - Application Prefs Interface

@interface ApplicationPreferencesManager : NSObject {
    NSMutableArray*        _arrServerList;
}

#pragma mark - Properties
#pragma mark * Server management
@property (nonatomic, assign) int selectedServerIndex;
@property (nonatomic, readonly) NSString *selectedDomain;

#pragma mark * JCR storage
/* current jcr repository. Return "repository" if cannot retrieve it from the server */
@property (nonatomic, readonly) NSString *currentRepository;
/* default jcr workspace. Return "collaboration" if cannot retrieve it from the server */
@property (nonatomic, readonly) NSString *defaultWorkspace;
/* home user jcr path. Return nil if cannot retrieve it from the server */
@property (nonatomic, readonly) NSString *userHomeJcrPath;

#pragma mark - Methods
+ (ApplicationPreferencesManager*)sharedInstance;

#pragma mark * Server management
- (NSMutableArray *)serverList;
- (void)loadServerList;

#pragma mark * Read/Write data
- (CXMLNode*) getNode: (CXMLNode*) element withName: (NSString*) name;
- (NSString*) getNodeValue: (CXMLNode*) node withName: (NSString*) name;
- (NSMutableArray*)parseConfiguration:(NSData*)data withBSystemSever:(BOOL)bSystemServer;
- (NSData*)createXmlDataWithServerList:(NSMutableArray*)arrServerList;
- (NSMutableArray*)loadSystemConfiguration;
- (NSMutableArray*)loadDeletedSystemConfiguration;
- (NSMutableArray*)loadUserConfiguration;
- (NSData*)readFileWithName:(NSString*)strFileName;
//Save the deleted system Configuration to the /app/documents
- (void)writeSystemConfiguration:(NSMutableArray*)arrSystemServerList;
- (void)writeDeletedSystemConfiguration:(NSMutableArray*)arrDeletedSystemServerList;
- (BOOL)writeUserConfiguration:(NSMutableArray*)arrUserSystemServerList;
- (BOOL)writeData:(NSData*)data toFile:(NSString*)strFileName;

#pragma mark * JCR storage
- (void)setJcrRepositoryName:(NSString *)repositoryName defaultWorkspace:(NSString *)defaultWorkspace userHomePath:(NSString *)userHomePath;

@end
