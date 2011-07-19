//
//  SocialActivityStreamProxy.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 07/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialActivityStreamProxy.h"
#import "SocialIdentityProxy.h"
#import "SocialIdentity.h"
#import "SocialRestConfiguration.h"
#import "SocialActivityStream.h"
#import "SocialUserProfileProxy.h"


@implementation SocialActivityStreamProxy

@synthesize _socialIdentityProxy;
@synthesize _socialUserProfileProxy;
@synthesize _arrActivityStreams;

- (id)initWithSocialIdentityProxy:(SocialIdentityProxy*)socialIdentityProxy
{
    if ((self = [super init])) 
    { 
        _socialIdentityProxy = [socialIdentityProxy retain];
    } 
    return self;
}

- (id)initWithSocialUserProfileProxy:(SocialUserProfileProxy*)socialUserProfileProxy
{
    if ((self = [super init])) 
    { 
        _socialUserProfileProxy = [socialUserProfileProxy retain];
    } 
    return self;
}

- (void)dealloc 
{
    [_socialIdentityProxy release];
    [super dealloc];
}


#pragma mark - helper methods

//Helper to create the base URL
- (NSString *)createBaseURL 
{
    SocialRestConfiguration* socialConfig = [SocialRestConfiguration sharedInstance];
    return [NSString stringWithFormat:@"%@/%@/private/api/social/%@/%@/activity_stream/",socialConfig.domainNameWithCredentials,socialConfig.restContextName,socialConfig.restVersion,socialConfig.portalContainerName];
}


//Helper to create the path to get the ressources
- (NSString *)createPath 
{    
    return [NSString stringWithFormat:@"%@/feed/default.json",_socialUserProfileProxy.userProfile.identity]; 
}


#pragma mark - Call methods

- (void) getActivityStreams 
{
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL]];
    [RKObjectManager setSharedManager:manager];
    [manager registerClass:[SocialActivityStream class] forElementNamed:@"activities"];
    [manager loadObjectsAtResourcePath:[self createPath] delegate:self];   
}



#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects 
{
	NSLog(@"Loaded statuses: %@", objects);    
    _arrActivityStreams = [objects retain];
    if (delegate && [delegate respondsToSelector:@selector(proxyDidFinishLoading:)]) {
        [delegate proxyDidFinishLoading:self];
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error 
{
	UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
	NSLog(@"Hit error: %@", error);
}

 
@end
