//
//  eXoChatUser.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 23/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "eXoChatUser.h"


@implementation eXoChatUser
- (void)setObjectWithXMPPUser:(XMPPUser*)xmppUser andArrMsg:(NSMutableArray*)arrMessages andHtmlstr:(NSString*)htmlStr
{
	_xmppUser = xmppUser;
	_arrMessages = arrMessages;
	_htmlStr = htmlStr;
}

- (XMPPUser*)getXmppUser
{
	return _xmppUser;
}

- (NSString*)getChatUserId
{
	return [[_xmppUser jid] user];
}

- (NSMutableArray*)getArrMessages
{
	return _arrMessages;
}

- (void)setArrMessages:(NSMutableArray*)arrMessages
{
	_arrMessages = arrMessages;
}

- (NSString*)getHtmlStr {
	return _htmlStr;
}

- (void)setHtmlStr:(NSString*)htmlStr {
	_htmlStr = [htmlStr retain];
}

@end
