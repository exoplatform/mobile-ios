//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import "SocialRestProxy.h"
#import "defines.h"

@implementation SocialRestProxy

- (instancetype) init
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
    SocialVersion *version = objects[0];
    SocialRestConfiguration* socialConfig = [SocialRestConfiguration sharedInstance];
    socialConfig.restVersion = version.version;
    
    [super objectLoader:objectLoader didLoadObjects:objects];
}


@end
