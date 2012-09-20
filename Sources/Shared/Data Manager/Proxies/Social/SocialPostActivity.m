//
//  SocialPostActivity.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialPostActivity.h"
#import "SocialActivity.h"
#import "SocialRestConfiguration.h"
#import "ApplicationPreferencesManager.h"
#import "defines.h"


@implementation SocialPostActivity

@synthesize text=_text;

#pragma - Object Management

-(id)init {
    if ((self=[super init])) {
        //Default behavior
        _text = [@"" retain];
    }
    return self;
}



- (void) dealloc {
    [_text release];
    [super dealloc];
}


#pragma mark - helper methods

//Helper to create the path to get the ressources
- (NSString *)createPath {
    return [NSString stringWithFormat:@"%@/activity.json", [super createPath]]; 
}


-(void)postActivity:(NSString *)message fileURL:(NSString*)fileURL fileName:(NSString*)fileName {
    if (message != nil) {
        self.text = message;
    }
    
    
    RKObjectManager* manager = [RKObjectManager sharedManager];
    manager.serializationMIMEType = RKMIMETypeJSON;

    RKObjectRouter* router = [[RKObjectRouter new] autorelease];
    manager.router = router;
    
    // Send POST requests for instances of SocialActivity to '/activity.json'
    [router routeClass:[SocialActivity class] toResourcePath:[self createPath] forMethod:RKRequestMethodPOST];
    
    // Let's create an SocialActivity
    SocialActivity *activity = [[SocialActivity alloc] init];
    activity.title = message;
    
    //Register our mappings with the provider FOR SERIALIZATION
    RKObjectMapping *activitySimpleMapping = [RKObjectMapping mappingForClass: 
                                              [SocialActivity class]]; 
    [activitySimpleMapping mapKeyPath:@"title" toAttribute:@"title"];
    
    //Attach file
    if(fileURL != nil) {
        ApplicationPreferencesManager *serverPM = [ApplicationPreferencesManager sharedInstance];
        activity.type = @"DOC_ACTIVITY"; 
        
        NSRange rangeOfDocLink = [fileURL rangeOfString:@"jcr"];
        NSString* docLink = [NSString stringWithFormat:@"/rest/%@", [fileURL substringFromIndex:rangeOfDocLink.location]];

        NSString* docPath = [fileURL substringFromIndex:[fileURL rangeOfString:serverPM.userHomeJcrPath].location];
        
        activity.title = [NSString stringWithFormat:@"Shared a document <a href=\"%@\">%@</a>\"", docLink, fileName];
        

         activity.templateParams = [[NSMutableDictionary alloc] init];
        
        [activity setKeyForTemplateParams:@"DOCPATH" value:docPath];
        [activity setKeyForTemplateParams:@"MESSAGE" value:message];
        [activity setKeyForTemplateParams:@"DOCLINK" value:docLink];
        [activity setKeyForTemplateParams:@"WORKSPACE" value:serverPM.defaultWorkspace];
        [activity setKeyForTemplateParams:@"REPOSITORY" value:serverPM.currentRepository];
        [activity setKeyForTemplateParams:@"DOCNAME" value:fileName];
        
        [activitySimpleMapping mapKeyPath:@"type" toAttribute:@"type"];
        [activitySimpleMapping mapKeyPath:@"templateParams" toAttribute:@"templateParams"];
    }
    
    //Configure a serialization mapping for our Product class 
    RKObjectMapping *activitySimpleSerializationMapping = [activitySimpleMapping 
                                                    inverseMapping]; 
    
    //serialization mapping 
    [manager.mappingProvider 
     setSerializationMapping:activitySimpleSerializationMapping forClass:[SocialActivity 
                                                                   class]]; 
    
    
    
    //Now create the mapping for the response
    RKObjectMapping* mappingForResponse = [RKObjectMapping mappingForClass:[SocialActivity class]];
    [mappingForResponse mapKeyPathsToAttributes:
     @"identityId",@"identityId",
     @"totalNumberOfComments",@"totalNumberOfComments",
     @"postedTime",@"postedTime",
     @"type",@"type",
     @"activityStream",@"activityStream",
     @"title",@"title",
     @"priority",@"priority",
     @"activityId",@"activityId",
     @"createdAt",@"createdAt",
     @"titleId",@"titleId",
     @"posterIdentity",@"posterIdentity",
     @"templateParams",@"templateParams",
     nil];
    
    
    //[manager.mappingProvider addObjectMapping:mappingForResponse]; 
    
    // Send a POST to /articles to create the remote instance
    [manager postObject:activity mapResponseWith:mappingForResponse delegate:self];    
    [activity release];
}

@end
