//
//  LoginProxy.m
//  eXo Platform
//
//  Created by Le Thanh Quang on 26/07/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "LoginProxy.h"
#import "ServerPreferencesManager.h"
#import "defines.h"


@implementation LoginProxy

@synthesize delegate = _delegate;


-(id)initWithDelegate:(id<LoginProxyDelegate>)delegate {
    if ((self = [super init])) {
        _delegate = delegate;
    }
    return self;
}



#pragma mark - helper methods

//Helper to create the base URL
- (NSString *)createBaseURL {  
    NSString *domainName = [[ServerPreferencesManager sharedInstance] selectedDomain];
    return [NSString stringWithFormat:@"%@/%@/",domainName, kRestContextName]; 
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
     nil];
    
    [manager loadObjectsAtResourcePath:@"platform/info" objectMapping:mapping delegate:self];          
}

- (void)authenticateAndGetPlatformInfoWithUsername:(NSString *)username password:(NSString *)password {
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL]];
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookiesForURL:[NSURL URLWithString:manager.client.baseURL]]) {
        [storage deleteCookie:cookie];
    }
    manager.client.forceBasicAuthentication = YES;
    manager.client.username = username;
    manager.client.password = password;
    [RKObjectManager setSharedManager:manager];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[PlatformServerVersion class]];
    [mapping mapKeyPathsToAttributes:
     @"platformVersion",@"platformVersion",
     @"platformRevision",@"platformRevision",
     @"platformBuildNumber",@"platformBuildNumber",
     @"isMobileCompliant",@"isMobileCompliant",
     @"platformEdition",@"platformEdition",
     nil];
    
    [manager loadObjectsAtResourcePath:@"private/platform/info" objectMapping:mapping delegate:self];
}


#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    LogTrace(@"Loaded payload: %@", [response bodyAsString]);
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    //NSLog(@"Loaded statuses: %@", objects);    
    //We receive the response from the server
    //We now need to check if the version can run social features or not and set properties
    
    PlatformServerVersion *platformServerVersion = [[objects objectAtIndex:0] retain];

    NSRange aRange = [platformServerVersion.platformVersion rangeOfString:@"3.5"];
    BOOL isPlatformCompatibleWithSocialFeatures = YES;
    if (aRange.location == NSNotFound) {
        //Version is not compatible with social features
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
    [super dealloc];
}

@end
