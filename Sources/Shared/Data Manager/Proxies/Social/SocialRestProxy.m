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
    [super dealloc];
}


- (NSString *)createPath{
    return [NSString stringWithFormat:@"api/social/version/latest.json"]; 
}


#pragma mark - Call methods

- (void) getVersion{
    RKObjectManager* manager = [RKObjectManager sharedManager];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[SocialVersion class]];
    [mapping mapKeyPath:@"version" toAttribute:@"version"]; 
    [manager loadObjectsAtResourcePath:[self createPath] objectMapping:mapping delegate:self];   
}
#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{
    LogDebug(@"Loaded payload Version: %@", [response bodyAsString]);
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects 
{
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
