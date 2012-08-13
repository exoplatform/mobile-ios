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

/*
 * @Getter: Return 0 if user doesn't choose to remember selected stream, else return value read at the user preference property "selected_stream"
 * @Setter: if user doesn't choose to remember selected stream, keep this value temporary to reserve for method "setrememberSelectedSocialStream:". Else the value is saved to "selected_stream". 
 */
@property (nonatomic, assign) int selectedSocialStream;

/*
 * @Getter: Returns true if the user preference property "selected_stream" doesn't exist or its value is greater than 0, else return false.
 * @Setter: If it's set true, value kepted by "setSelectedSocialStream:" is used to saved into "selected_stream", else a negative number is saved.
 */
@property (nonatomic, assign) BOOL rememberSelectedSocialStream;

/* current jcr repository. Return "repository" if cannot retrieve it from the server */
@property (nonatomic, readonly) NSString *currentRepository;
/* default jcr workspace. Return "collaboration" if cannot retrieve it from the server */
@property (nonatomic, readonly) NSString *defaultWorkspace;
/* home user jcr path. Return nil if cannot retrieve it from the server */
@property (nonatomic, readonly) NSString *userHomeJcrPath;

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
- (void)setJcrRepositoryName:(NSString *)repositoryName defaultWorkspace:(NSString *)defaultWorkspace userHomePath:(NSString *)userHomePath;

@end
