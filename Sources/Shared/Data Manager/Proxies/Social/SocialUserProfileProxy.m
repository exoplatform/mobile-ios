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

#import "SocialUserProfileProxy.h"
#import "SocialRestConfiguration.h"
#import "SocialUserProfileCache.h"
#import "ApplicationPreferencesManager.h"


@implementation SocialUserProfileProxy

@synthesize userProfile=_userProfile;


#pragma mark - Object Management

- (id)init {
    if ((self = [super init])) {
    } 
    return self;
}

- (void)dealloc {
    [_userProfile release];
    [super dealloc];
}

#pragma mark - helper methods

//Helper to create the path to get the ressources
- (NSString *)createPath:(NSString *)userIdentity {
    return [NSString stringWithFormat:@"%@/identity/%@.json", [super createPath], userIdentity]; 
}


//Helper to create the path to get the ressources
- (NSString *)createPathForUsername:(NSString *)username {
    
    return [NSString stringWithFormat:@"%@/identity/organization/%@.json", [super createPath], username]; 
}


#pragma mark - Call methods
- (void) getUserProfileFromUsername:(NSString *)username {
    
    // Load the object model via RestKit
    RKObjectManager* manager = [RKObjectManager sharedManager];
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[SocialUserProfile class]];
    [mapping mapKeyPathsToAttributes:
     @"id",@"identity",
     @"remoteId",@"remoteId",
     @"providerId",@"providerId",
     @"profile.avatarUrl",@"avatarUrl",
     @"profile.fullName",@"fullName",
    nil];
    
    [manager loadObjectsAtResourcePath:[self createPathForUsername:username] objectMapping:mapping delegate:self];   
}


#pragma mark - RKObjectLoaderDelegate methods
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    // We receive the response from the server
    _userProfile = [[objects objectAtIndex:0] retain];
    // Saving the current user's full name and avatar URL in the ServerObj that represents him
    ServerObj* currentAccount = [[ApplicationPreferencesManager sharedInstance] getSelectedAccount];
    currentAccount.avatarUrl = _userProfile.avatarUrl;
    currentAccount.userFullname = _userProfile.fullName;
    // We need to prevent the caller.
    [[SocialUserProfileCache sharedInstance] addInCache:_userProfile forIdentity:_userProfile.identity];
    [super objectLoader:objectLoader didLoadObjects:objects];
}

@end
