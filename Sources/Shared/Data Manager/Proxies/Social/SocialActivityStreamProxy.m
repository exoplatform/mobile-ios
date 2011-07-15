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

//http://localhost:8080/rest/private/api/social/v1-alpha1/portal/activity_stream/f956c224c0a801261dbd7ead12838051/feed/default.json

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
    //return [NSString stringWithFormat:@"http://localhost:8080/rest-socialdemo/private/api/social/%@/socialdemo/activity_stream/",socialConfig.restVersion]; 
    return [NSString stringWithFormat:@"http://john:gtn@localhost:8080/rest-socialdemo/private/api/social/%@/socialdemo/activity_stream/",socialConfig.restVersion];
}


//Helper to create the path to get the ressources
- (NSString *)createPath 
{    
    return [NSString stringWithFormat:@"%@/feed/default.json",_socialUserProfileProxy.userProfile.identity]; 
}




#pragma mark - Call methods

- (void) getActivityStreams 
{
    RKObjectMapper* mapper = [[RKObjectMapper alloc] init];
    [mapper mapFromString:@"activities"];
    
    //RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL]];
    RKDynamicRouter* router = [[RKDynamicRouter new] autorelease];  
    [router routeClass:[SocialActivityStream class] toResourcePath:[self createPath] forMethod:RKRequestMethodGET]; 
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL] objectMapper:mapper router:router];

    [RKObjectManager setSharedManager:manager];
    [manager loadObjectsAtResourcePath:[self createPath] objectClass:[SocialActivityStream class] delegate:self];      
}



#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects 
{
	NSLog(@"Loaded statuses: %@", objects);    
	//[_socialIdentity release];
	//_socialIdentity = [objects retain];
    
    //_socialIdentity = [objects objectAtIndex:0];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error 
{
	UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
	NSLog(@"Hit error: %@", error);
}

 
@end
