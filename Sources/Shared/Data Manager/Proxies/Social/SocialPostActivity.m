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
    manager.requestSerializationMIMEType = RKMIMETypeJSON;

    RKRouter * router = [[RKRouter alloc] initWithBaseURL:manager.baseURL];
    
    manager.router = router;
    
    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[SocialActivity class] pathPattern:[self createPath] method:RKRequestMethodPOST]];
    
    // Let's create an SocialActivity
    SocialActivity *activity = [[SocialActivity alloc] init];
    activity.title = message;
    
    //Register our mappings with the provider FOR SERIALIZATION
    RKObjectMapping *activitySimpleMapping = [RKObjectMapping requestMapping];
    
    [activitySimpleMapping addAttributeMappingsFromDictionary:@{@"title":@"title"}];
    
    
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
        
        [activitySimpleMapping addAttributeMappingsFromDictionary:@{@"type":@"type",@"templateParams":@"templateParams"}];
    }
    
    //Configure a serialization mapping for our Product class 
//    RKObjectMapping *activitySimpleSerializationMapping = [activitySimpleMapping 
//                                                    inverseMapping];
    
    //serialization mapping
    
        
    RKRequestDescriptor * requestDescriptor =  [RKRequestDescriptor requestDescriptorWithMapping:activitySimpleMapping objectClass:[SocialActivity class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    [manager addRequestDescriptor:requestDescriptor];
    
    
    //Now create the mapping for the response
    RKObjectMapping* mappingForResponse =  [RKObjectMapping mappingForClass:[SocialActivity class]];
    [mappingForResponse addAttributeMappingsFromDictionary:@{
     @"identityId":@"identityId",
     @"totalNumberOfComments":@"totalNumberOfComments",
     @"postedTime":@"postedTime",
     @"type":@"type",
     @"activityStream":@"activityStream",
     @"title":@"title",
     @"priority":@"priority",
     @"activityId":@"activityId",
     @"createdAt":@"createdAt",
     @"titleId":@"titleId",
     @"templateParams":@"templateParams"}];
    
    
    RKResponseDescriptor * responseDescriptor =  [RKResponseDescriptor responseDescriptorWithMapping:mappingForResponse method:RKRequestMethodPOST pathPattern:[self createPath] keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]] ;
    
    
    [manager addResponseDescriptor:responseDescriptor];
    
    
    
    
    // Send a POST to /like to create the remote instance
            
    [manager  postObject:activity path:[self createPath] parameters:nil
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     [super restKitDidLoadObjects:[mappingResult array]];
                 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     [super restKitDidFailWithError:error];
                 }
     ];
    
    [activity release];
}

@end
