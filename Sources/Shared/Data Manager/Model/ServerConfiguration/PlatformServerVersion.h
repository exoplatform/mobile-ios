//
//  PlatformServerVersion.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 26/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PlatformServerVersion : NSObject {
    
    NSString* _platformVersion; // Version of the Platform (3.0 or 3.5 or higher)
    NSString* _platformRevision; // Revision of the Platform
    NSString* _platformBuildNumber; // BuildNumber
    NSString* _isMobileCompliant;
    NSString* _platformEdition;
}


@property (nonatomic, retain) NSString* platformVersion; // Version of the Platform (3.0 or 3.5 or higher)
@property (nonatomic, retain)NSString* platformRevision; // Revision of the Platform
@property (nonatomic, retain)NSString* platformBuildNumber; // BuildNumber

@property (nonatomic, retain)NSString* isMobileCompliant; // 
@property (nonatomic, retain)NSString* platformEdition; //
@end
