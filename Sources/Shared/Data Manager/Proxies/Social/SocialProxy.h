//
//  SocialProxy.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 12/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SocialProxyDelegate;


@interface SocialProxy : NSObject {
    
    id<SocialProxyDelegate> delegate;
    
}

@property (nonatomic, assign) id<SocialProxyDelegate> delegate;


- (NSString*)URLEncodedString:(NSDictionary *)dictForParam;

@end


@protocol SocialProxyDelegate<NSObject>
- (void)proxyDidFinishLoading:(SocialProxy *)proxy;
- (void)proxy:(SocialProxy *)proxy didFailWithError:(NSError *)error;	
@end
