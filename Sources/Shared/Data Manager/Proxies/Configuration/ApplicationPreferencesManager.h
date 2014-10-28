//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import <Foundation/Foundation.h>
#import "CXMLDocument.h"
#import "CXMLNode.h"
#import "CXMLElement.h"

#pragma mark - Server Object Interface

@interface ServerObj : NSObject
 @property BOOL bSystemServer;
 @property (nonatomic, retain) NSString* accountName;
 @property (nonatomic, retain) NSString* serverUrl;
 @property (nonatomic, retain) NSString* avatarUrl;
 @property (nonatomic, retain) NSString* userFullname;
 @property (nonatomic, retain) NSString* username;
 @property (nonatomic, retain) NSString* password;
 @property (assign)            long      lastLoginDate; // # of seconds since Jan 1, 1970
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
- (ServerObj*)getSelectedAccount;
- (void)loadServerList;
- (BOOL)deleteServerObjAtIndex:(int)index;
- (BOOL)twoOrMoreAccountsExist;
//add a new server or save changes to an existed one
- (BOOL) addEditServerWithServerName:(NSString*) strServerName andServerUrl:(NSString*) strServerUrl withUsername:(NSString *)username andPassword:(NSString *)password atIndex:(int)index;
//if existed, return the server's index, otherwise return -1
- (int)checkServerAlreadyExistsWithName:(NSString*)strServerName andURL:(NSString*)strServerUrl andUsername:(NSString*)username ignoringIndex:(NSInteger) index;
- (void)persistServerList;
- (void) addAndSelectServer:(ServerObj*)account;

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

#pragma mark * Utils
- (void) loadReceivedUrlToPreference:(NSURL *)url;
@end
