//
//  LoginProxy.m
//  eXo Platform
//
//  Created by Le Thanh Quang on 26/07/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "LoginProxy.h"
#import "ApplicationPreferencesManager.h"
#import "defines.h"
#import "CloudUtils.h"
#import "UserPreferencesManager.h"
#import "AlreadyAccountViewController.h"
#import "OnPremiseViewController.h"
#import "ExoWeemoHandler.h"

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
- (id)initWithDelegate:(id<LoginProxyDelegate>)delegate username:(NSString *)username password:(NSString *)password serverUrl:(NSString *)serverUrl
{
    if((self = [super init])) {
        self.delegate = delegate;
        self.username = username;
        self.password = password;
        self.serverUrl = serverUrl;
    }
return self;
}

-(id)initWithDelegate:(id<LoginProxyDelegate>)delegate {
    if ((self = [super init])) {
        _delegate = delegate;
        self.serverUrl = [[ApplicationPreferencesManager sharedInstance] selectedDomain];
    }
    return self;
}
-(id)initWithDelegate:(id<LoginProxyDelegate>)delegate username:(NSString *)userName password:(NSString *)passWord
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
            NSEnumerator *userNameEnumerator = [[credentialsDict objectForKey:urlProtectionSpace] keyEnumerator];
            id userName;
            
            // iterate over all usernames for this protectionspace, which are the keys for the actual NSURLCredentials
            while (userName = [userNameEnumerator nextObject]) {
                NSURLCredential *cred = [[credentialsDict objectForKey:urlProtectionSpace] objectForKey:userName];
                LogDebug(@"credential to be removed: %@", cred);
                [[NSURLCredentialStorage sharedCredentialStorage] removeCredential:cred forProtectionSpace:urlProtectionSpace];
            }
        }
    }
}

#pragma mark - helper methods

//Helper to create the base URL
- (NSString *)createBaseURL {  
    return self.serverUrl ? [NSString stringWithFormat:@"%@/%@/",self.serverUrl, kRestContextName] : nil;
}



#pragma mark - Call methods

- (void)retrievePlatformInformations {
    // Load the object model via RestKit
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL]];
    [RKObjectManager setSharedManager:manager];
        
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[PlatformServerVersion class]];
    [mapping mapKeyPathsToAttributes:
     @"platformVersion",@"platformVersion",
     @"platformRevision",@"platformRevision",
     @"platformBuildNumber",@"platformBuildNumber",
     @"isMobileCompliant",@"isMobileCompliant",
     @"platformEdition",@"platformEdition",
     @"currentRepoName",@"currentRepoName",
     @"defaultWorkSpaceName",@"defaultWorkSpaceName",
     @"userHomeNodePath",@"userHomeNodePath",
     nil];
    
    [manager loadObjectsAtResourcePath:@"platform/info" objectMapping:mapping delegate:self];          
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
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:baseURL];
    manager.client.username = self.username;
    manager.client.password = self.password;
    manager.client.cachePolicy = RKRequestCachePolicyNone;

    [RKObjectManager setSharedManager:manager];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[PlatformServerVersion class]];
    [mapping mapKeyPathsToAttributes:
     @"platformVersion",@"platformVersion",
     @"platformRevision",@"platformRevision",
     @"platformBuildNumber",@"platformBuildNumber",
     @"isMobileCompliant",@"isMobileCompliant",
     @"platformEdition",@"platformEdition",
     @"currentRepoName",@"currentRepoName",
     @"defaultWorkSpaceName",@"defaultWorkSpaceName",
     @"userHomeNodePath",@"userHomeNodePath",
     nil];
    // add '#' into the link to prevent caching result
    [manager loadObjectsAtResourcePath:@"private/platform/info#" objectMapping:mapping delegate:self];
    
}


#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    LogTrace(@"Loaded payload: %@", [response bodyAsString]);
}

//Login sucessful
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    //NSLog(@"Loaded statuses: %@", objects);    
    //We receive the response from the server
    //We now need to check if the version can run social features or not and set properties
    
    PlatformServerVersion *platformServerVersion = [objects objectAtIndex:0];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(platformServerVersion != nil && [platformServerVersion.isMobileCompliant boolValue]) {
        // get the 3 first chars of version, ex: 3.5, 4.0
        NSString *shortVersionStr = [platformServerVersion.platformVersion substringToIndex:3];
        float shortVersion = [shortVersionStr floatValue];
        
        BOOL isPlatformCompatibleWithSocialFeatures = (shortVersion < 3.5) ? NO : YES;
        
        if(self.username) { //only need when authenticating, it means self.username is not nil
            if(isPlatformCompatibleWithSocialFeatures) {
                if([_delegate isKindOfClass:[AlreadyAccountViewController class]] || [_delegate isKindOfClass:[OnPremiseViewController class]]) {
                    //add the server url to server list
                    ApplicationPreferencesManager *appPref = [ApplicationPreferencesManager sharedInstance];
                    [appPref addAndSetSelectedServer:self.serverUrl withName:@"My intranet"];
                }
                
                [UserPreferencesManager sharedInstance].username = self.username;
                [UserPreferencesManager sharedInstance].password = self.password;
                [[UserPreferencesManager sharedInstance] persistUsernameAndPasswod];
                
                [[ApplicationPreferencesManager sharedInstance] setJcrRepositoryName:platformServerVersion.currentRepoName defaultWorkspace:platformServerVersion.defaultWorkSpaceName userHomePath:platformServerVersion.userHomeNodePath];
            }
            
            //connect and authenticate to Weemo cloud
            [ExoWeemoHandler sharedInstance].userId = self.username;
            [ExoWeemoHandler sharedInstance].displayName = self.username;
            [[ExoWeemoHandler sharedInstance] connect];
            
            //set userId for CallHistoryManager
            [CallHistoryManager sharedInstance].userId = self.username;
        }
        
        [userDefaults setObject:platformServerVersion.platformVersion forKey:EXO_PREFERENCE_VERSION_SERVER];
        [userDefaults setObject:platformServerVersion.platformEdition forKey:EXO_PREFERENCE_EDITION_SERVER];
        
        //We need to prevent the caller.
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

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	// Authenticate failed
    if (_delegate && [_delegate respondsToSelector:@selector(loginProxy:authenticateFailedWithError:)]) {
        [_delegate loginProxy:self authenticateFailedWithError:error];
    }
}

- (void) dealloc {
    _delegate = nil;
    [[RKRequestQueue sharedQueue] abortRequestsWithDelegate:self];
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

@end
