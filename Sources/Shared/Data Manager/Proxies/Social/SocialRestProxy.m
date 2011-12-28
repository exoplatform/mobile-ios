//
//  SocialRestProxy.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialRestProxy.h"
#import "defines.h"

@implementation SocialRestProxy

- (id) init
{
    if ((self = [super init])) 
    {
    }	
	return self;
}

- (void)dealloc 
{
    delegate = nil;
    [[RKRequestQueue sharedQueue] cancelAllRequests];
    
    [super dealloc];
}

//Helper to create the base URL
- (NSString *)createBaseURL 
{
    SocialRestConfiguration* socialConfig = [SocialRestConfiguration sharedInstance];
    NSLog(@"%@", [NSString stringWithFormat:@"%@/%@/api/social/version/",[[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_DOMAIN],socialConfig.restContextName]);
    //http://{domain_name}/{rest_context_name}/api/social/version/latest.json
    return [NSString stringWithFormat:@"%@/%@/api/social/version/",[[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_DOMAIN],socialConfig.restContextName];
    
}

//Helper to create the path to get the ressources
- (NSString *)createPath{
    return @"latest.json"; 
}


#pragma mark - Call methods

- (void) getVersion{
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL]];
    [RKObjectManager setSharedManager:manager];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[SocialVersion class]];
    [mapping mapKeyPath:@"version" toAttribute:@"version"]; 
    [manager loadObjectsAtResourcePath:[self createPath] objectMapping:mapping delegate:self];   
}
#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{
    NSLog(@"Loaded payload Version: %@", [response bodyAsString]);
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects 
{
	//NSLog(@"Loaded statuses: %@", objects);    
    SocialVersion *version = [[objects objectAtIndex:0]retain];
    SocialRestConfiguration* socialConfig = [SocialRestConfiguration sharedInstance];
    socialConfig.restVersion = version.version;
    
    if (delegate && [delegate respondsToSelector:@selector(proxyDidFinishLoading:)]) {
        [delegate proxyDidFinishLoading:self];
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error 
{
    if (delegate && [delegate respondsToSelector:@selector(proxy: didFailWithError:)]) {
        [delegate proxy:self didFailWithError:error];
    }
}

@end
