//
//  eXoPlatformUnitTests.m
//  eXoPlatformUnitTests
//
//  Created by Mai Gia Thanh Xuyen on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "eXoPlatformUnitTests.h"
#import "AuthenticateUnitest.h"
#import "SettingUnitest.h"

@implementation eXoPlatformUnitTests

- (void)setUp
{

}

- (void)tearDown
{


}

- (void)testAuthenticate
{
    AuthenticateUnitest *authenticateU = [[AuthenticateUnitest alloc] init]; 
    
    NSString *strNoNetworkConnection = [authenticateU signInWithWhenNoNetworkConnection];
    NSString *strInvalidUrl = [authenticateU signInWithInvalidURL];
    NSString *strInvalidCredentials = [authenticateU signInWithInValidUserPassword];
    NSString *strValidCredentials = [authenticateU signInWithValidUserPassword];
    
    STAssertTrue([strNoNetworkConnection isEqualToString:@"ERROR"], @"NetworkConnectionFailed");
    STAssertTrue([strInvalidUrl isEqualToString:@"ERROR"], @"NetworkConnectionFailed");
    STAssertTrue([strInvalidCredentials isEqualToString:@"NO"], @"WrongUserNamePassword");
    STAssertTrue([strValidCredentials isEqualToString:@"YES"], @"OK");
    
    [authenticateU release];
                                                      
}

- (void)testSetting {
    
    SettingUnitest *settingU = [[SettingUnitest alloc] init];
    
//    Parse given url
    NSString *expectedUrl = @"http://demo.platform.exo.org";
    
    STAssertTrue([[settingU parseURL:@"demo.platform.exo.org/portal"] isEqualToString:expectedUrl], @"Failed");
    STAssertTrue([[settingU parseURL:@"http://demo.platform.exo.org"] isEqualToString:expectedUrl], @"Failed");
    STAssertTrue([[settingU parseURL:@"demo.platform.exo.org/"] isEqualToString:expectedUrl], @"Failed");
    STAssertTrue([[settingU parseURL:@"http://demo.platform.exo.org/portal"] isEqualToString:expectedUrl], @"Failed");
    
//     Get server list
    NSArray *serverList = [settingU getServerList];
    STAssertTrue([serverList count] > 0, @"Failed");
    
//    Add new server
    STAssertTrue([settingU addNewServer:@"" URL:@""], @"Failed");
    
//    Edit server
    STAssertTrue([settingU editServer:@"" urlNew:@""], @"Failed");
    
//    Delete server
    STAssertTrue([settingU deleteServer], @"Failed");
    
}

@end
