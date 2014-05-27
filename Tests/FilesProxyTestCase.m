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
    [super tearDown];
}

- (void)setPreferences
{
    ApplicationPreferencesManager *appPM = [ApplicationPreferencesManager sharedInstance];
    [appPM setJcrRepositoryName:@"repository" defaultWorkspace:@"collaboration" userHomePath:@"Users/johndoe"];
    [appPM addAndSetSelectedServer:TEST_SERVER_URL withName:TEST_SERVER_NAME];
    
    UserPreferencesManager *userPM = [UserPreferencesManager sharedInstance];
    userPM.showPrivateDrive = YES;
}

- (void)testCalculateAbsPath
{
    File *file = [[File alloc] init];
    file.path = @"";
    file.name = @"My-File.txt";
    file.workspaceName = @"collaboration";
    file.currentFolder = @"/";
    file.driveName = @"Personal";
    
    NSString *relativePath = [NSString stringWithFormat:@"/%@", file.name];
    NSString *expectedPath = [NSString stringWithFormat:@"%@/%@/%@", TEST_SERVER_URL, @"rest/private/jcr/repository/collaboration", file.name];
    
    [proxy calculateAbsPath:relativePath forItem:file];
    
    XCTAssertEqualObjects(file.path, expectedPath, @"Absolute path of the given file is not correct");
}

- (void)testGetDrives
{
    [httpHelper HTTPStubForGetDrives];
    
    NSArray *drives = [proxy getDrives:@"Group"];
    
    XCTAssertEqual([drives count], 9, @"List of drives retrieved is not correct");
}

- (void)testGetContentOfFolder
{
    
}

- (void)testCreatUserRepositoryHomeUrl
{
    
}

-(void)testFileAction
{
    
}

-(void)testCreateNewFolderWithURL
{
    
}

-(void)testIsExistedUrl
{
    
}


@end
