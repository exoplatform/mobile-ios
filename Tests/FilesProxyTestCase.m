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


#import <XCTest/XCTest.h>
#import "ExoTestCase.h"
#import <OHHTTPStubs.h>
#import "HTTPStubsHelper.h"
#import "FilesProxy.h"
#import "File.h"
#import "ApplicationPreferencesManager.h"
#import "UserPreferencesManager.h"

@interface FilesProxyTestCase : ExoTestCase {
    FilesProxy *proxy;
    HTTPStubsHelper *httpHelper;
}

@end

@implementation FilesProxyTestCase

- (void)setUp
{
    [super setUp];
    proxy = [FilesProxy sharedInstance];
    httpHelper = [HTTPStubsHelper getInstance];
    [self setPreferences];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [OHHTTPStubs removeAllStubs];
    [self clearPreferences];
    [super tearDown];
}

- (void)setPreferences
{
    ApplicationPreferencesManager *appPM = [ApplicationPreferencesManager sharedInstance];
    [appPM setJcrRepositoryName:@"repository" defaultWorkspace:@"collaboration" userHomePath:@"/Users/johndoe"];
    ServerObj * account = [[ServerObj alloc] init];
    account.accountName = TEST_SERVER_NAME;
    account.serverUrl = TEST_SERVER_URL;
    [appPM addAndSelectServer:account];
    
    UserPreferencesManager *userPM = [UserPreferencesManager sharedInstance];
    userPM.showPrivateDrive = YES;
}

- (void)clearPreferences
{
    ApplicationPreferencesManager *appPM = [ApplicationPreferencesManager sharedInstance];
    if ([[appPM serverList] count] > 0)
        [appPM deleteServerObjAtIndex:0];
    
}

- (File*)createFile
{
    File *file = [[File alloc] init];
    file.path = @".";
    file.name = @"My-File.txt";
    file.workspaceName = @"collaboration";
    file.currentFolder = @"/";
    file.driveName = @"Personal";
    
    return file;
}

- (void)testCalculateAbsPath
{
    File *file = [self createFile];
    
    NSString *relativePath = [NSString stringWithFormat:@"/%@", file.name];
    NSString *expectedPath = [NSString stringWithFormat:@"%@/%@/%@", TEST_SERVER_URL, @"rest/private/jcr/repository/collaboration", file.name];
    
    [proxy calculateAbsPath:relativePath forItem:file];
    
    XCTAssertEqualObjects(file.path, expectedPath, @"Absolute path of the given file is not correct");
}

- (void)testGetDrives
{
    [httpHelper HTTPStubForGetDrives];
    [httpHelper logWhichStubsAreRegistered];
    
    NSArray *drives = [proxy getDrives:@"Group"];
    
    // There are 9 drives listed in GetDrivesResponse-4.0.xml
    XCTAssertEqual([drives count], 9, @"List of drives is not correct");
}

- (void)testGetContentOfFolder
{
    [httpHelper HTTPStubForGetFoldersAndFiles];
    [httpHelper logWhichStubsAreRegistered];
    
    File *root = [self createFile];
    root.isFolder = YES;
    root.hasChild = YES;
    NSArray *contents = [proxy getContentOfFolder:root];
    
    int nbFol = 0;
    int nbFil = 0;
    for (File *f in contents) {
        if (f.isFolder) nbFol++;
        else nbFil++;
    }
    // There are 5 folders and 2 files listed in GetFoldersAndFilesResponse-4.0.xml
    XCTAssertEqual([contents count], 7, @"List of folders and files is not correct");
    XCTAssertEqual(nbFol, 5, @"There should be 5 folders in the list");
    XCTAssertEqual(nbFil, 2, @"There should be 2 files in the list");
}

- (void)testCreatUserRepositoryHomeUrl
{
    [proxy creatUserRepositoryHomeUrl];
    
    NSString *url = proxy._strUserRepository;
    
    NSString *expectedUrl = [NSString stringWithFormat:@"%@%@",
                             TEST_SERVER_URL,
                             @"/rest/private/jcr/repository/collaboration/Users/johndoe"];
    
    XCTAssertEqualObjects(url, expectedUrl, @"Users JCR home path is not correct");
}

-(void)testFileDeleteAction
{
    [httpHelper HTTPStubForAnyRequestWithSuccess:YES];
    [httpHelper logWhichStubsAreRegistered];
    
    NSString *fileUrl = [NSString stringWithFormat:@"%@%@",
                         TEST_SERVER_URL,
                         @"/rest/private/jcr/repository/collaboration/Users/johndoe/Documents/My-File.txt"];
    NSString *result = [proxy fileAction:kFileProtocolForDelete source:fileUrl destination:nil data:nil];
    
    // the proxy returns nil when the request is successful, and an error message otherwise
    XCTAssertNil(result, @"Delete File Action failed");
}

-(void)testFileMoveAction
{
    [httpHelper HTTPStubForAnyRequestWithSuccess:YES];
    [httpHelper logWhichStubsAreRegistered];
    
    NSString *srcUrl = [NSString stringWithFormat:@"%@%@",
                         TEST_SERVER_URL,
                         @"/rest/private/jcr/repository/collaboration/Users/johndoe/Documents/My-File.txt"];
    NSString *destUrl = [NSString stringWithFormat:@"%@%@",
                         TEST_SERVER_URL,
                         @"/rest/private/jcr/repository/collaboration/Users/johndoe/Documents/My-File-New.txt"];
    
    NSString *result = [proxy fileAction:kFileProtocolForMove source:srcUrl destination:destUrl data:nil];
    
    // the proxy returns nil when the request is successful, and an error message otherwise
    XCTAssertNil(result, @"Move File Action failed");
}

-(void)testFileMoveActionFailsWhenSourceEqualsDestination
{
    [httpHelper HTTPStubForAnyRequestWithSuccess:YES];
    [httpHelper logWhichStubsAreRegistered];
    
    NSString *srcUrl = [NSString stringWithFormat:@"%@%@",
                        TEST_SERVER_URL,
                        @"/rest/private/jcr/repository/collaboration/Users/johndoe/Documents/My-File.txt"];
    
    NSString *result = [proxy fileAction:kFileProtocolForMove source:srcUrl destination:srcUrl data:nil];
    
    // the proxy returns nil when the request is successful, and an error message otherwise
    XCTAssertNotNil(result, @"Move File Action should have failed because source = destination");
}

-(void)testFileCopyAction
{
    [httpHelper HTTPStubForAnyRequestWithSuccess:YES];
    [httpHelper logWhichStubsAreRegistered];
    
    NSString *srcUrl = [NSString stringWithFormat:@"%@%@",
                        TEST_SERVER_URL,
                        @"/rest/private/jcr/repository/collaboration/Users/johndoe/Documents/My-File.txt"];
    NSString *destUrl = [NSString stringWithFormat:@"%@%@",
                         TEST_SERVER_URL,
                         @"/rest/private/jcr/repository/collaboration/Users/johndoe/Documents/My-File-New.txt"];
    
    NSString *result = [proxy fileAction:kFileProtocolForCopy source:srcUrl destination:destUrl data:nil];
    
    // the proxy returns nil when the request is successful, and an error message otherwise
    XCTAssertNil(result, @"Copy File Action failed");
}

-(void)testFileUploadAction
{
    [httpHelper HTTPStubForAnyRequestWithSuccess:YES];
    [httpHelper logWhichStubsAreRegistered];
    
    NSString *srcUrl = [NSString stringWithFormat:@"%@%@",
                        TEST_SERVER_URL,
                        @"/rest/private/jcr/repository/collaboration/Users/johndoe/Documents/"];
    
    const char *utfString = [@"ABCDEFG" UTF8String];
    NSData *data = [NSData dataWithBytes:utfString length:strlen(utfString)];
    
    NSString *result = [proxy fileAction:kFileProtocolForUpload source:srcUrl destination:nil data:data];
    
    // the proxy returns nil when the request is successful, and an error message otherwise
    XCTAssertNil(result, @"Upload File Action failed");
}

- (void)testFileActionWithError
{
    [httpHelper HTTPStubForAnyRequestWithSuccess:NO];
    [httpHelper logWhichStubsAreRegistered];
    
    NSString *srcUrl = [NSString stringWithFormat:@"%@%@",
                        TEST_SERVER_URL,
                        @"/rest/private/jcr/repository/collaboration/Users/johndoe/Documents/My-File.txt"];
    
    NSString *result = [proxy fileAction:kFileProtocolForDelete source:srcUrl destination:nil data:nil];
    
    // the proxy returns nil when the request is successful, and an error message otherwise
    XCTAssertNotNil(result, @"File Action should have failed");
}

-(void)testCreateNewFolderWithURL
{
    
}

-(void)testIsExistedUrl
{
    
}


@end
