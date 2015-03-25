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

#import "LoginProxy.h"
#import "ApplicationPreferencesManager.h"
#import "defines.h"
#import "CloudUtils.h"
#import "AccountInfoUtils.h"
#import "UserPreferencesManager.h"
#import "AlreadyAccountViewController.h"
#import "OnPremiseViewController.h"
#import "URLAnalyzer.h"

@interface LoginProxy()
//private variables
@property (nonatomic,retain) NSString *username;
@property (nonatomic, retain) NSString *password;

@end
@implementation LoginProxy

@synthesize delegate = _delegate;
@synthesize username = _username;
@synthesize password = _password;
@synthesize serverUrl = _serverUrl;
- (instancetype)initWithDelegate:(id<LoginProxyDelegate>)delegate username:(NSString *)username password:(NSString *)password serverUrl:(NSString *)serverUrl
{
    if((self = [super init])) {
        self.delegate = delegate;
        self.username = username;
        self.password = password;
        self.serverUrl = serverUrl;
    }
return self;
}

-(instancetype)initWithDelegate:(id<LoginProxyDelegate>)delegate {
    if ((self = [super init])) {
        _delegate = delegate;
        self.serverUrl = [[ApplicationPreferencesManager sharedInstance] selectedDomain];
    }
    return self;
}
-(instancetype)initWithDelegate:(id<LoginProxyDelegate>)delegate username:(NSString *)userName password:(NSString *)passWord
{
    if((self = [super init])) {
        _delegate = delegate;
        self.username = userName;
        self.password = passWord;
        self.serverUrl = [[ApplicationPreferencesManager sharedInstance] selectedDomain];
    }
    return self;
}

+ (void)doLogout {
    // Persist the list of accounts
    [[ApplicationPreferencesManager sharedInstance] persistServerList];
    // Remove Cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    // reset the credentials cache...
    NSDictionary *credentialsDict = [[NSURLCredentialStorage sharedCredentialStorage] allCredentials];
    
    if ([credentialsDict count] > 0) {
        // the credentialsDict has NSURLProtectionSpace objs as keys and dicts of userName => NSURLCredential
        NSEnumerator *protectionSpaceEnumerator = [credentialsDict keyEnumerator];
        id urlProtectionSpace;
        
        // iterate over all NSURLProtectionSpaces
        while (urlProtectionSpace = [protectionSpaceEnumerator nextObject]) {
            NSEnumerator *userNameEnumerator = [credentialsDict[urlProtectionSpace] keyEnumerator];
            id userName;
            
            // iterate over all usernames for this protectionspace, which are the keys for the actual NSURLCredentials
            while (userName = [userNameEnumerator nextObject]) {
                NSURLCredential *cred = credentialsDict[urlProtectionSpace][userName];
                LogDebug(@"credential to be removed: %@", cred);
                [[NSURLCredentialStorage sharedCredentialStorage] removeCredential:cred forProtectionSpace:urlProtectionSpace];
            }
        }
    }
    [UserPreferencesManager sharedInstance].isUserLogged = NO;
}

#pragma mark - helper methods

//Helper to create the base URL
- (NSString *)createBaseURL {  
    return self.serverUrl ? [NSString stringWithFormat:@"%@/%@/",self.serverUrl, kRestContextName] : nil;
}



#pragma mark - Call methods

- (void)retrievePlatformInformations {
    // Load the object model via RestKit
    RKObjectManager* manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:[self createBaseURL]]];
    [RKObjectManager setSharedManager:manager];
        
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[PlatformServerVersion class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                   @"platformVersion":@"platformVersion",
                                                   @"platformRevision":@"platformRevision",
                                                   @"platformBuildNumber":@"platformBuildNumber",
                                                   @"isMobileCompliant":@"isMobileCompliant",
                                                   @"platformEdition":@"platformEdition",
                                                   @"currentRepoName":@"currentRepoName",
                                                   @"defaultWorkSpaceName":@"defaultWorkSpaceName",
                                                   @"userHomeNodePath":@"userHomeNodePath"
                                                   }];
    
//    [manager loadObjectsAtResourcePath:@"platform/info" objectMapping:mapping delegate:self];
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:@"platform/info" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [manager addResponseDescriptor:responseDescriptor];
    [manager getObjectsAtPath:@"platform/info" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self restKitDidLoadObjects:[mappingResult array]];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        //         Authenticate failed
        if (_delegate && [_delegate respondsToSelector:@selector(loginProxy:authenticateFailedWithError:)]) {
            [_delegate loginProxy:self authenticateFailedWithError:error];
        }
    }];
}

#pragma mark Methods for authentication
- (void)authenticate
{
    NSString *dest = [NSString stringWithFormat:@"%@/rest/private/",self.serverUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dest] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10.0];

    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self] ;
    
    [connection start];
}

- (void)getPlatformInfoAfterAuthenticate {

    NSString *baseURL = [self createBaseURL];
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    RKObjectManager* manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:baseURL]];
    

//TODO:    manager.HTTPClient.cachePolicy = RKRequestCachePolicyNone;
    
    [manager.HTTPClient setAuthorizationHeaderWithUsername:self.username password:self.password];

    [RKObjectManager setSharedManager:manager];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[PlatformServerVersion class]];
    [mapping addAttributeMappingsFromDictionary:@{     @"platformVersion":@"platformVersion",
                                                       @"platformRevision":@"platformRevision",
                                                       @"platformBuildNumber":@"platformBuildNumber",
                                                       @"isMobileCompliant":@"isMobileCompliant",
                                                       @"platformEdition":@"platformEdition",
                                                       @"currentRepoName":@"currentRepoName",
                                                       @"defaultWorkSpaceName":@"defaultWorkSpaceName",
                                                       @"userHomeNodePath":@"userHomeNodePath",
}];
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:@"private/platform/info#" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [manager addResponseDescriptor:responseDescriptor];
    [manager getObjectsAtPath:@"private/platform/info#"  parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self restKitDidLoadObjects:[mappingResult array]];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//         Authenticate failed
        if (_delegate && [_delegate respondsToSelector:@selector(loginProxy:authenticateFailedWithError:)]) {
            [_delegate loginProxy:self authenticateFailedWithError:error];
        }
    }];
     
     
}


#pragma mark - RKObjectLoaderDelegate methods

//- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
//    LogTrace(@"Loaded payload: %@", [response bodyAsString]);
//}


-(void) restKitDidLoadObjects:(NSArray *) objects {
    //NSLog(@"Loaded statuses: %@", objects);
    //We receive the response from the server
    //We now need to check if the version can run social features or not and set properties
    
    PlatformServerVersion *platformServerVersion = objects[0];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(platformServerVersion != nil && [platformServerVersion.isMobileCompliant boolValue]) {
        // get the 3 first chars of version, ex: 3.5, 4.0
        NSString *shortVersionStr = [platformServerVersion.platformVersion substringToIndex:3];
        float shortVersion = [shortVersionStr floatValue];
        
        BOOL isPlatformCompatibleWithSocialFeatures = (shortVersion < 3.5) ? NO : YES;
        
        if(self.username) { // only need when authenticating, it means self.username is not nil
            ApplicationPreferencesManager *appPref = [ApplicationPreferencesManager sharedInstance];
            if(isPlatformCompatibleWithSocialFeatures) {
                if([_delegate isKindOfClass:[AlreadyAccountViewController class]] || [_delegate isKindOfClass:[OnPremiseViewController class]]) {
                    // add the server url to server list
                    NSString* accountName = [AccountInfoUtils extractAccountNameFromURL:self.serverUrl];
                    ServerObj* account = [[[ServerObj alloc] init] autorelease];
                    account.accountName = accountName;
                    account.serverUrl = self.serverUrl;
                    account.username = self.username;
                    [appPref addAndSelectServer:account];
                }
                [UserPreferencesManager sharedInstance].username = self.username;
                [UserPreferencesManager sharedInstance].password = self.password;
                [[UserPreferencesManager sharedInstance] persistUsernameAndPasswod];
                [appPref setJcrRepositoryName:platformServerVersion.currentRepoName defaultWorkspace:platformServerVersion.defaultWorkSpaceName userHomePath:platformServerVersion.userHomeNodePath];
            }
            // Saving the user's username and current date in the ServerObj that represents him
            ServerObj* selectedAccount =  [appPref getSelectedAccount];
            selectedAccount.username = self.username;
            selectedAccount.lastLoginDate = [[NSDate date] timeIntervalSince1970];
            if (![selectedAccount.serverUrl isEqualToString:self.serverUrl]) {
                // Update the URL of the server with the new value,
                // probably retrieved when we handled the http redirection
                selectedAccount.serverUrl = self.serverUrl;
            }
        }
        
        [userDefaults setObject:platformServerVersion.platformVersion forKey:EXO_PREFERENCE_VERSION_SERVER];
        [userDefaults setObject:platformServerVersion.platformEdition forKey:EXO_PREFERENCE_EDITION_SERVER];
        
        // We need to prevent the caller.
        if (_delegate && [_delegate respondsToSelector:@selector(loginProxy:platformVersionCompatibleWithSocialFeatures:withServerInformation:)]) {
            [_delegate loginProxy:self platformVersionCompatibleWithSocialFeatures:isPlatformCompatibleWithSocialFeatures withServerInformation:platformServerVersion];
        }
    } else {
        [userDefaults setObject:@"" forKey:EXO_PREFERENCE_VERSION_SERVER];
        [userDefaults setObject:@"" forKey:EXO_PREFERENCE_EDITION_SERVER];
        
        NSError *error = [[NSError alloc] initWithDomain:EXO_NOT_COMPILANT_ERROR_DOMAIN code:nil userInfo:nil];
        [self.delegate loginProxy:self authenticateFailedWithError:error];
    }
    [userDefaults synchronize];
}


- (void) dealloc {
    _delegate = nil;
    [self.username release];
    [self.password release];
    [self.serverUrl release];
    [super dealloc];
}

#pragma mark NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if([challenge previousFailureCount] == 0) {
        
        NSURLCredential *credential = [NSURLCredential credentialWithUser:self.username password:self.password persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
        
    } else {
        //alert to user that he entered incorrect username/password
        [self.delegate loginProxy:self authenticateFailedWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUserCancelledAuthentication userInfo:nil]];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self getPlatformInfoAfterAuthenticate];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegate loginProxy:self authenticateFailedWithError:error];
}

- (NSURLRequest*)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    NSHTTPURLResponse* httpResp = (NSHTTPURLResponse*)response;
    if (response && httpResp.statusCode == 301) {
        // E.g http://community.exoplatform.com/rest/private
        NSString* location = [httpResp.allHeaderFields objectForKey:@"Location"];
        NSString* domain = [URLAnalyzer extractDomainFromURL:location];
        self.serverUrl = domain;
    }
    return request;
}

@end

#pragma mark Builder of UIAlertView when login failed

@implementation LoginProxyAlert

+ (UIAlertView*) alertWithError:(NSError *)error andDelegate:(id)delegate
{
    UIAlertView *alert = nil;
    
    if([error.domain isEqualToString:NSURLErrorDomain] && error.code == kCFURLErrorNotConnectedToInternet) {
        // network connection problem
        alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Authorization")
                                            message:Localize(@"NetworkConnectionFailed")
                                           delegate:delegate
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil] autorelease];
    } else if ([error.domain isEqualToString:NSURLErrorDomain] && (error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorCannotFindHost || error.code == kCFURLErrorTimedOut)) {
        // cant connect to server
        alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Authorization")
                                            message:Localize(@"InvalidServer")
                                           delegate:delegate
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil] autorelease];
    } else if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorUserCancelledAuthentication) {
        // wrong username/password
        alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Authorization")
                                            message:Localize(@"WrongUserNamePassword")
                                           delegate:delegate
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil] autorelease];
//    } else if ([error.domain isEqualToString:RKErrorDomain] && error.code == RKRequestBaseURLOfflineError) {
//        // error getting platform info by restkit
//        alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Authorization")
//                                            message:Localize(@"NetworkConnectionFailed")
//                                           delegate:delegate
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles: nil] autorelease];
    } else if([error.domain isEqualToString:EXO_NOT_COMPILANT_ERROR_DOMAIN]) {
        // target version of Platform is not mobile compliant
        alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Error")
                                            message:Localize(@"NotCompliant")
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] autorelease];
        
//    } else if([error.domain isEqualToString:RKErrorDomain] && error.code == RKObjectLoaderUnexpectedResponseError) {
//        // incorrect server error response
//        alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Authorization")
//                                            message:Localize(@"ServerNotAvailable")
//                                           delegate:delegate
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles: nil] autorelease];
    } else {
        alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Authorization")
                                            message:@""
                                           delegate:delegate
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil] autorelease];
    }
    
    return [alert retain];
}

@end
