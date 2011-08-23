//
//  eXoChatUser.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 23/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPUser.h"

@interface eXoChatUser : NSObject 
{
	XMPPUser*			_xmppUser;	//XMPP user controller
	NSMutableArray*		_arrMessages;	//Message list for users
	NSString*			_htmlStr;	//Message content in HTML format
}
//Constructor
- (void)setObjectWithXMPPUser:(XMPPUser*)xmppUser andArrMsg:(NSMutableArray*)arrMessages andHtmlstr:(NSString*)htmlStr;
//Gettors
- (XMPPUser*)getXmppUser;
- (NSString*)getChatUserId;
- (NSMutableArray*)getArrMessages;
- (void)setArrMessages:(NSMutableArray*)arrMessages;
- (NSString*)getHtmlStr;
- (void)setHtmlStr:(NSString*)htmlStr;

@end
