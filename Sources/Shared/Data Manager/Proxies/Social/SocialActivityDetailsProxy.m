//
//  SocialActivityDetailsProxy.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 15/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialActivityDetailsProxy.h"
#import "SocialRestConfiguration.h"
#import "SocialActivityDetails.h"
#import "SocialIdentity.h"
#import "SocialComment.h"



@implementation SocialActivityDetailsProxy

@synthesize activityIdentity = _activityIdentity;
@synthesize numberOfComments = _numberOfComments;
@synthesize posterIdentity = _posterIdentity;
@synthesize activityStream = _activityStream;





#pragma - Object Management

-(id)init {
    if ((self=[super init])) {
        //Default behavior
        _numberOfComments = 0;
        _posterIdentity = NO;
        _activityStream = NO;
    }
    return self;
}


-(id)initWithNumberOfComments:(int)nbComments {
    if ((self = [self init])) {
        
        //The set the wanted number of comments
        _numberOfComments = nbComments;
    }
    return self;
}



- (void) dealloc {
    [_activityIdentity release];
    [super dealloc];
}


#pragma mark - helper methods

//Helper to create the base URL
- (NSString *)createBaseURL {
    SocialRestConfiguration* socialConfig = [SocialRestConfiguration sharedInstance];
    
    //http://demo:gtn@localhost:8080/rest/private/api/social/v1/portal/activity/1ed7c4c9c0a8012636585a573a15c26e
    
    return [NSString stringWithFormat:@"%@/%@/private/api/social/%@/%@/activity/", socialConfig.domainNameWithCredentials, socialConfig.restContextName,socialConfig.restVersion, socialConfig.portalContainerName]; 
    //return @"http://john:gtn@localhost:8080/rest-socialdemo/private/api/social/v1-alpha1/socialdemo/identity/";
    
}


//Helper to create the path to get the ressources
- (NSString *)createPath:(NSString *)activityId {
    return [NSString stringWithFormat:@"%@.json",activityId]; 
}


//Helper to add Parameters to the request
//Conform to the RestKit Documentation
- (NSDictionary*)createParamDictionary {
    NSMutableDictionary *dicForParams = [[NSMutableDictionary alloc] init];
    
    BOOL hasParams = NO;
    
    //Check for poster Identity
    if (_posterIdentity) {
        [dicForParams setValue:@"1" forKey:@"poster_identity"];
        hasParams = YES;
    }
    
    //Check for ActivityStream
    if (_activityStream) {
        [dicForParams setValue:@"1" forKey:@"activity_stream"];
        hasParams = YES;
    }
    
    //Check for number of Comments
    if (_numberOfComments>0) {
        [dicForParams setValue:[NSString stringWithFormat:@"%d",_numberOfComments] forKey:@"number_of_comments"];
        hasParams = YES;
    }
        
    if (!hasParams) return nil;
    
    return (NSDictionary *)dicForParams;
}



#pragma - Request Methods

- (void)getActivityDetail:(NSString *)activityId{
    
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL]];
    [RKObjectManager setSharedManager:manager];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[SocialActivityDetails class]];
    [mapping mapKeyPathsToAttributes:
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
    
    // Create our new SocialIdentity mapping
    
    //RKObjectAttributeMapping socialIdentityMapping = [RKObjectAttributeMapping mappingFromKeyPath:@"identityId" toKeyPath:@"identityId"];
    
    //[manager registerClass:[SocialIdentity class] forElementNamed:@"identityId"];
    
    RKObjectMapping* socialIdentityMapping = [RKObjectMapping mappingForClass:[SocialIdentity class]];
    /*[socialIdentityMapping mapKeyPathsToAttributes:
     @"identityId",@"identity", 
     nil];*/
    [manager.mappingProvider setObjectMapping:socialIdentityMapping forKeyPath:@"identityId"];
    
    //[socialIdentityMapping ]
    /*[socialIdentityMapping mapKeyPathsToAttributes:
     @"identityId",@"identity", 
     nil];
     [mapping addAttributeMapping:socialIdentityMapping];
     */
    //[mapping mapKeyPath:@"identityId" toRelationship:@"identityId" withObjectMapping:socialIdentityMapping];
    
    // Configure relationship mappings
    //RKObjectMapping* socialIdentityMapping = [RKObjectMapping mappingForClass:[SocialIdentity class]];
    // Direct configuration of instances
    /*RKObjectRelationshipMapping* activityIdentityMapping = [RKObjectRelationshipMapping mappingFromKeyPath:@"identityId" 
     toKeyPath:@"identityId" 
     objectMapping:socialIdentityMapping];
     [mapping addRelationshipMapping:activityIdentityMapping];
     */
    //[mapping mapRelationship:@"identityId" withObjectMapping:socialIdentityMapping];
    
    
    /* 
     // Create our new SocialIdentity mapping
     RKObjectMapping* socialCommentMapping = [RKObjectMapping mappingForClass:[SocialComment class]];
     [socialCommentMapping mapKeyPathsToAttributes:
     @"createdAt",@"createdAt",
     @"text",@"text",
     @"postedTime",@"postedTime",
     nil];
     [socialCommentMapping mapKeyPath:@"identityId" toRelationship:@"identityId" withObjectMapping:socialIdentityMapping];
     [mapping mapKeyPath:@"comments" toRelationship:@"comments" withObjectMapping:socialCommentMapping];
     */
    
    [manager loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@",[self createPath:activityId],[self URLEncodedString:[self createParamDictionary]]] 
                         objectMapping:mapping delegate:self];
    
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
