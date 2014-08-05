//
//  PlatformRegistrationProxy.m
//  eXo
//
//  Created by Work on 4/8/14.
//  Copyright (c) 2014 eXo Platform. All rights reserved.
//

#import "PlatformRegistrationProxy.h"
#import "PlatformRegistration.h"
#import "ApplicationPreferencesManager.h"
#import "defines.h"

@implementation PlatformRegistrationProxy

@synthesize username = _username;

- (id)initWithUsername:(NSString*) user
{
    if (self == [super init]) {
        self.username = user;
    }
    return self;
}

- (NSString*) createPath
{
    return [NSString stringWithFormat:@"/%@", NOTIFICATIONS_REGISTRATIONS_PATH];
}

- (void)registerDeviceOnPlatform
{
    RKObjectManager* manager = [RKObjectManager sharedManager];
    manager.serializationMIMEType = RKMIMETypeJSON;
    manager.acceptMIMEType = RKMIMETypeJSON;
    
    RKObjectRouter* router = [[RKObjectRouter new] autorelease];
    [router routeClass:[PlatformRegistration class] toResourcePath:[self createPath] forMethod:RKRequestMethodPOST];
    manager.router = router;
    
    PlatformRegistration *registration = [[PlatformRegistration alloc] init];
    registration.username = self.username;
    registration.platform = @"ios";
    registration.deviceToken = [[ApplicationPreferencesManager sharedInstance] retrieveDeviceToken];
    
    RKObjectMapping *serializationMapping = [RKObjectMapping mappingForClass:[PlatformRegistration class]];
    [serializationMapping mapKeyPath:@"username" toAttribute:@"username"];
    [serializationMapping mapKeyPath:@"platform" toAttribute:@"platform"];
    [serializationMapping mapKeyPath:@"deviceToken" toAttribute:@"device_id"];
    
    [manager.mappingProvider setSerializationMapping:serializationMapping forClass:[PlatformRegistration                                                               class]];

    RKObjectMapping *responseMapping = [serializationMapping inverseMapping];
    
//    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[PlatformRegistration class]];
//    [responseMapping mapKeyPath:@"username" toAttribute:@"username"];
//    [responseMapping mapKeyPath:@"platform" toAttribute:@"platform"];
//    [responseMapping mapKeyPath:@"device_id" toAttribute:@"deviceToken"];
    
    [manager postObject:registration mapResponseWith:responseMapping delegate:self];
    [registration release];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Platform registration failed with error: %@", [error debugDescription]);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"Successfully registered device and username in Platform.");
}

@end
