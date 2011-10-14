//
//  SocialPostActivity.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "SocialProxy.h"

@interface SocialPostActivity : SocialProxy <RKObjectLoaderDelegate>{
    
    NSString* _text;
}

@property (nonatomic,retain) NSString* text;

-(void)postActivity:(NSString *)message fileURL:(NSString*)fileURL fileName:(NSString*)fileName;

@end
