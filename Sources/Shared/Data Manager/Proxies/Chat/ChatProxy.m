//
//  ChatProxy.m
//  eXo Platform
//
//  Created by Mai Gia on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChatProxy.h"
#import "XMPPJID.h"

@implementation ChatProxy

@synthesize delegate = _delegate;

+ (ChatProxy*)sharedInstance
{
	static ChatProxy *sharedInstance;
	@synchronized(self)
	{
		if(!sharedInstance)
		{
			sharedInstance = [[ChatProxy alloc] init];
		}
		return sharedInstance;
	}
	return sharedInstance;
}

//Host without protocol, path
-(void)connectToChatServer:(NSString *)host port:(int)port userName:(NSString *)userName password:(NSString *)password
{
   
    if(!_xmppClient)
    {
		_xmppClient = [[XMPPClient alloc] init];
		[_xmppClient addDelegate:_delegate];
		[_xmppClient setAutoLogin:NO];
		[_xmppClient setAutoRoster:YES];
		[_xmppClient setAutoPresence:YES];

    }
    
	[_xmppClient setDomain:host];	
	[_xmppClient setPort:port]; //maybe port number is not neccessary for this App
	
	BOOL usesSSL = NO;
	BOOL allowsSelfSignedCertificates = NO;
	BOOL allowsSSLHostNameMismatch = NO;
	
	[_xmppClient setUsesOldStyleSSL:usesSSL];
	[_xmppClient setAllowsSelfSignedCertificates:allowsSelfSignedCertificates];
	[_xmppClient setAllowsSSLHostNameMismatch:allowsSSLHostNameMismatch];
    
	NSString* resource = @"";
	NSString* userLocation = @"@";
	userLocation = [userLocation stringByAppendingString:host];
	
	NSString* jid_name = [userName stringByAppendingString:userLocation];
	XMPPJID* jid = [XMPPJID jidWithString:jid_name resource:resource];
	[_xmppClient setMyJID:jid];
	[_xmppClient setPassword:password];
    
    if(![_xmppClient isConnected])
    {
        [_xmppClient connect];
    }
    
//    [_xmppClient authenticateUser];	
    
}

- (NSArray *)getUserList
{
    return [_xmppClient sortedUsersByAvailabilityName];	
}

#pragma mark XMPPClient Delegate Methods:

- (void)xmppClientDidConnect:(XMPPClient *)sender
{
	[_xmppClient authenticateUser];
}

- (void)xmppClientDidUpdateRoster:(XMPPClient *)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(updateChatClient:)])
    {
        [_delegate updateChatClient:_xmppClient];
    }
}

- (void)xmppClient:(XMPPClient *)sender didReceiveMessage:(XMPPMessage *)message
{
    if([_delegate respondsToSelector:@selector(receivedChatMessage:)])
    {
        [_delegate receivedChatMessage:message];
    }	
}

@end
