//
//  SocialRestConfiguration.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 07/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRestVersion [NSString stringWithFormat:@"v1-alpha1"]
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


@property (retain, nonatomic) NSString* domainName;
@property (retain, nonatomic) NSString* portalContainerName;
@property (retain, nonatomic) NSString* restContextName;
@property (retain, nonatomic) NSString* restVersion;
@property (retain, nonatomic) NSString* username;
@property (retain, nonatomic) NSString* password;



+ (SocialRestConfiguration*)sharedInstance;



@end
