//
//  SocialPostActivity.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialPostActivity.h"
#import "SocialActivityDetails.h"
#import "SocialRestConfiguration.h"



@implementation SocialPostActivity

@synthesize text=_text;

#pragma - Object Management

-(id)init {
    if ((self=[super init])) {
        //Default behavior
        _text = @"";
    }
    return self;
}



- (void) dealloc {
    [_text release];
    [super dealloc];
}


#pragma mark - helper methods

//Helper to create the base URL
- (NSString *)createBaseURL {
    SocialRestConfiguration* socialConfig = [SocialRestConfiguration sharedInstance];
    
    //http://demo:gtn@localhost:8080/rest/private/api/social/v1/portal/activity/1ed7c4c9c0a8012636585a573a15c26e
    
    return [NSString stringWithFormat:@"%@/%@/private/api/social/%@/%@/", socialConfig.domainNameWithCredentials, socialConfig.restContextName,socialConfig.restVersion, socialConfig.portalContainerName]; 
    //return @"http://john:gtn@localhost:8080/rest-socialdemo/private/api/social/v1-alpha1/socialdemo/identity/";
    
}


//Helper to create the path to get the ressources
- (NSString *)createPath:(NSString *)activityId {
    return [NSString stringWithFormat:@"activity.json",activityId]; 
}




-(void)postActivity:(NSString *)message {
    if (message != nil) {
        _text = message;
    }
    
    
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL]];
    [RKObjectManager setSharedManager:manager];
    manager.serializationMIMEType = RKMIMETypeJSON;

    RKObjectRouter* router = [[RKObjectRouter new] autorelease];
    manager.router = router;
    
    // Send POST requests for instances of SocialActivityDetails to '/activity.json'
    [router routeClass:[SocialActivityDetails class] toResourcePath:@"activity.json" forMethod:RKRequestMethodPOST];
    
    // Let's create an SocialActivityDetails
    SocialActivityDetails* activity = [[SocialActivityDetails alloc] init];
    activity.title = _text;
    
    //Register our mappings with the provider FOR SERIALIZATION
    RKObjectMapping *activitySimpleMapping = [RKObjectMapping mappingForClass: 
                                       [SocialActivityDetails class]]; 
    [activitySimpleMapping mapKeyPath:@"title" toAttribute:@"title"]; 
    
    //Configure a serialization mapping for our Product class 
    RKObjectMapping *activitySimpleSerializationMapping = [activitySimpleMapping 
                                                    inverseMapping]; 
    
    //serialization mapping 
    [manager.mappingProvider 
     setSerializationMapping:activitySimpleSerializationMapping forClass:[SocialActivityDetails 
                                                                   class]]; 
    
    
    
    //Now create the mapping for the response
    RKObjectMapping* mappingForResponse = [RKObjectMapping mappingForClass:[SocialActivityDetails class]];
    [mappingForResponse mapKeyPathsToAttributes:
     @"identityId",@"identityId",
     @"totalNumberOfComments",@"totalNumberOfComments",
     @"postedTime",@"postedTime",
     @"type",@"type",
     @"activityStream",@"activityStream",
     @"title",@"title",
     @"priority",@"priority",
     @"identifyId",@"identifyId",
     @"createdAt",@"createdAt",
     @"titleId",@"titleId",
     @"posterIdentity",@"posterIdentity",
     nil];
    
    // Create our new SocialCommentIdentity mapping
    RKObjectMapping* socialCommentMapping = [RKObjectMapping mappingForClass:[SocialComment class]];
    [socialCommentMapping mapKeyPathsToAttributes:
     @"createdAt",@"createdAt",
     @"text",@"text",
     @"postedTime",@"postedTime",
     @"identityId",@"identityId",
     nil];
    [mappingForResponse mapKeyPath:@"comments" toRelationship:@"comments" withObjectMapping:socialCommentMapping];
    
    //[manager.mappingProvider addObjectMapping:mappingForResponse]; 
    
    // Send a POST to /articles to create the remote instance
    [manager postObject:activity mapResponseWith:mappingForResponse delegate:self];    
    
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
