//
//  ChatProxy.h
//  eXo Platform
//
//  Created by Mai Gia on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPClient.h"

@interface ChatProxy : NSObject {
    
    id              _delegate;
    XMPPClient*     _xmppClient;        //Chat socket
    
}

@property(nonatomic, retain) id delegate;

+ (ChatProxy *)sharedInstance;

- (void)connectToChatServer:(NSString *)host port:(int)port userName:(NSString *)userName password:(NSString *)password;

- (NSArray *)getUserList;


@end
