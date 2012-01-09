//
//  SocialRestProxy.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "SocialVersion.h"
#import "SocialProxy.h"
#import "SocialRestConfiguration.h"

@interface SocialRestProxy : SocialProxy <RKObjectLoaderDelegate>{
    
}
- (void)getVersion;
@end