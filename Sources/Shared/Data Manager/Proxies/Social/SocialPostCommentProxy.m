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

#import "SocialPostCommentProxy.h"
#import "SocialRestConfiguration.h"
#import "SocialComment.h"


@implementation SocialPostCommentProxy

@synthesize comment=_comment, userIdentity = _userIdentity;

- (instancetype)init 
{
    if ((self = [super init])) 
    {
        _comment=@"";
    } 
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

#pragma mark - helper methods


#pragma mark - Call methods

-(void)postComment:(NSString *)commentValue forActivity:(NSString *)activityIdentity
{
    if (commentValue != nil) {
        _comment = commentValue;
    }
    
    
    RKObjectManager* manager = [RKObjectManager sharedManager];
    manager.serializationMIMEType = RKMIMETypeJSON;
    
    RKObjectRouter* router = [[RKObjectRouter new] autorelease];
    manager.router = router;
    
    // Send POST requests for instances of SocialActivityDetails to '/activity.json'
    [router routeClass:[SocialComment class] toResourcePath:[NSString stringWithFormat:@"%@/activity/%@/comment.json", [super createPath], activityIdentity] forMethod:RKRequestMethodPOST];
    
    // Let's create an SocialActivityDetails
    SocialComment* commentToPost = [[SocialComment alloc] init];
    commentToPost.text = _comment;
    
    //Register our mappings with the provider FOR SERIALIZATION
    RKObjectMapping *commentSimpleMapping = [RKObjectMapping mappingForClass: 
                                              [SocialComment class]]; 
    [commentSimpleMapping mapKeyPath:@"text" toAttribute:@"text"]; 
    
    //Configure a serialization mapping for our SocialComment class 
    RKObjectMapping *commentSimpleSerializationMapping = [commentSimpleMapping 
                                                           inverseMapping]; 
    
    //serialization mapping 
    [manager.mappingProvider 
     setSerializationMapping:commentSimpleSerializationMapping forClass:[SocialComment 
                                                                          class]]; 
    
    
    
   
    
    // Create our new SocialComment mapping
    RKObjectMapping* socialCommentMapping = [RKObjectMapping mappingForClass:[SocialComment class]];
    [socialCommentMapping mapKeyPathsToAttributes:
     @"createdAt",@"createdAt",
     @"text",@"text",
     @"postedTime",@"postedTime",
     @"identityId",@"identityId",
     nil];
        
    // Send a POST to /articles to create the remote instance
    [manager postObject:commentToPost mapResponseWith:socialCommentMapping delegate:self];  
    [commentToPost release];
}

@end
