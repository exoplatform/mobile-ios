//
//  ChatProxy.h
//  eXo Platform
//
//  Created by Mai Gia on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPClient.h"
#import "XMPPUser.h"

@interface ChatProxy : NSObject {
    
    id              _delegate;
    XMPPClient*     _xmppClient;        //Chat socket
    
}

@property(nonatomic, retain) id delegate;

+ (ChatProxy *)sharedInstance;

- (void)connectToChatServer:(NSString *)host port:(int)port userName:(NSString *)userName password:(NSString *)password;
- (void)disconnect;

- (XMPPUser *)getXMPPUser;
- (NSArray *)getUserList;

- (void)sendChatMessage:(NSString *)msg to:(NSString *)toUser;


@end
