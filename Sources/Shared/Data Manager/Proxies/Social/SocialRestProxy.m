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
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects 
{
    SocialVersion *version = [objects objectAtIndex:0];
    SocialRestConfiguration* socialConfig = [SocialRestConfiguration sharedInstance];
    socialConfig.restVersion = version.version;
    
    [super objectLoader:objectLoader didLoadObjects:objects];
}


@end
