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

@interface LoginProxy()
//private variables
@property (nonatomic,retain) NSString *username;
@property (nonatomic, retain) NSString *password;

@end
@implementation LoginProxy

@synthesize delegate = _delegate;
@synthesize username;
@synthesize password;

-(id)initWithDelegate:(id<LoginProxyDelegate>)delegate {
    if ((self = [super init])) {
        _delegate = delegate;
    }
    return self;
}
-(id)initWithDelegate:(id<LoginProxyDelegate>)delegate username:(NSString *)userName password:(NSString *)passWord
{
    if((self = [super init])) {
        _delegate = delegate;
        self.username = userName;
        self.password = passWord;
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
    NSString *domainName = [[ApplicationPreferencesManager sharedInstance] selectedDomain];
    return domainName ? [NSString stringWithFormat:@"%@/%@/",domainName, kRestContextName] : nil;
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
    NSString *dest = [NSString stringWithFormat:@"%@/rest/private/",[[ApplicationPreferencesManager sharedInstance] selectedDomain]];
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


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    //NSLog(@"Loaded statuses: %@", objects);    
    //We receive the response from the server
    //We now need to check if the version can run social features or not and set properties
    
    PlatformServerVersion *platformServerVersion = [objects objectAtIndex:0];
    
    // get the 3 first chars of version, ex: 3.5, 4.0
    NSString *shortVersionStr = [platformServerVersion.platformVersion substringToIndex:3];
    float shortVersion = [shortVersionStr floatValue];
    
    BOOL isPlatformCompatibleWithSocialFeatures = YES;
    
    if(shortVersion < 3.5) { // if version is before 3.5, plf is not compliant with social
        isPlatformCompatibleWithSocialFeatures = NO;
    }
    
    //We need to prevent the caller.
    if (_delegate && [_delegate respondsToSelector:@selector(platformVersionCompatibleWithSocialFeatures:withServerInformation:)]) {
        [_delegate platformVersionCompatibleWithSocialFeatures:isPlatformCompatibleWithSocialFeatures withServerInformation:platformServerVersion];
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	// Authenticate failed
    if (_delegate && [_delegate respondsToSelector:@selector(authenticateFailedWithError:)]) {
        [_delegate authenticateFailedWithError:error];
    }

}

- (void) dealloc {
    _delegate = nil;
    [[RKRequestQueue sharedQueue] abortRequestsWithDelegate:self];
    [self.username release];
    [self.password release];
    [super dealloc];
}

#pragma mark NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if([challenge previousFailureCount] == 0) {
        NSLog(@"1.received challenge for authentication");
        
        NSURLCredential *credential = [NSURLCredential credentialWithUser:self.username password:self.password persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
        
    } else {
        NSLog(@"login failed");
        //alert to user that he entered incorrect username/password
        [self.delegate authenticateFailedWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUserCancelledAuthentication userInfo:nil]];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"2.received response, login successfully");
    [self getPlatformInfoAfterAuthenticate];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error when authenticating:%@",[error localizedDescription]);
    [self.delegate authenticateFailedWithError:error];
}

@end
