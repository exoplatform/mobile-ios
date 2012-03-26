//
//  SocialPostCommentProxy.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "SocialProxy.h"

@interface SocialPostCommentProxy : SocialProxy <RKObjectLoaderDelegate> {
    
    NSString* _comment;
    NSString* _userIdentity;
    
}

@property (nonatomic, retain) NSString* comment;
@property (nonatomic, retain) NSString* userIdentity;


-(void)postComment:(NSString *)commentValue forActivity:(NSString *)activityIdentity;

@end
