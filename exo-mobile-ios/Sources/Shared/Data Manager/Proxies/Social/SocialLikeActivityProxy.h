//
//  SocialLikeActivityProxy.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 20/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "SocialProxy.h"

@interface SocialLikeActivityProxy : SocialProxy <RKObjectLoaderDelegate> {
    
}

-(void)likeActivity:(NSString *)activity;
-(void)dislikeActivity:(NSString *)activity;


@end
