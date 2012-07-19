//
//  SocialRestConfiguration.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 07/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRestVersion [NSString stringWithFormat:@"v1-alpha3"]
#define kRestContextName [NSString stringWithFormat:@"rest"]
#define kPortalContainerName [NSString stringWithFormat:@"portal"]


@interface SocialRestConfiguration : NSObject {
    
    NSString* _domainName;
    NSString* _portalContainerName;
    NSString* _restContextName;
    NSString* _restVersion;
    NSString* _username;
    NSString* _password;
    
}


@property (copy, nonatomic) NSString* domainName;
@property (copy, nonatomic) NSString* portalContainerName;
@property (copy, nonatomic) NSString* restContextName;
@property (copy, nonatomic) NSString* restVersion;
@property (copy, nonatomic) NSString* username;
@property (copy, nonatomic) NSString* password;



+ (SocialRestConfiguration*)sharedInstance;
- (void)updateDatas; //Method can be used to update datas after authentication
- (NSString *)createBaseUrl;


@end
