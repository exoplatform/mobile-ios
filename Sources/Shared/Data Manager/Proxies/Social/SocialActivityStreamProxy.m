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


@interface NSDictionary (RKAdditions)

/**
 * Creates and initializes a dictionary with key value pairs, with the keys specified
 * first instead of the objects. This allows for a more sensible definition of the 
 * property to element and relationship mappings on RKObjectMappable classes
 */
+ (id)dictionaryWithKeysAndObjects:(id)firstKey, ... NS_REQUIRES_NIL_TERMINATION;

@end

@implementation NSDictionary (RKAdditions)

+ (id)dictionaryWithKeysAndObjects:(id)firstKey, ... {
	va_list args;
    va_start(args, firstKey);
	NSMutableArray* keys = [NSMutableArray array];
	NSMutableArray* values = [NSMutableArray array];
    for (id key = firstKey; key != nil; key = va_arg(args, id)) {
		id value = va_arg(args, id);
        [keys addObject:key];
		[values addObject:value];		
    }
    va_end(args);
    
    return [self dictionaryWithObjects:values forKeys:keys];
}

@end



@implementation SocialActivityStreamProxy

@synthesize _socialIdentityProxy;

//http://localhost:8080/rest/private/api/social/v1-alpha1/portal/activity_stream/f956c224c0a801261dbd7ead12838051/feed/default.json

- (id)initWithSocialIdentityProxy:(SocialIdentityProxy*)socialIdentityProxy
{
    if ((self = [super init])) 
    { 
        _socialIdentityProxy = [socialIdentityProxy retain];
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
    return [NSString stringWithFormat:@"http://demo:gtn@localhost:8080/rest/private/api/social/v1-alpha1/portal/activity_stream/",socialConfig.restVersion];
}


//Helper to create the path to get the ressources
- (NSString *)createPath 
{    
    return [NSString stringWithFormat:@"%@/feed/default.json",_socialIdentityProxy._socialIdentity.identity]; 
}




#pragma mark - Call methods

- (void) getActivityStreams 
{
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL]];
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
