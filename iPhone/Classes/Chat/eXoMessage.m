//
//  eXoMessage.m
//  eXoApp
//
//  Created by Tran Hoai Son on 5/21/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import "eXoMessage.h"
#import "eXoAccount.h"

@implementation eXoMessage

@synthesize statusId, name, screenName, text, icon, timestamp, replyType, status, user, source, favorited;

- (void) dealloc {
    [statusId release];
    [name release];
    [screenName release];
    [text release];
    [icon release];
    [timestamp release];
    [source release];
	[iconUpdateDelegate release];
    [super dealloc];
}

- (BOOL) isEqual:(id)anObject 
{
    if ([[self statusId] isEqual:[anObject statusId]]) 
	{
        return TRUE;
    }
    return FALSE;
}

- (void) setStatus:(enum EXOMessageStatus)value 
{
    status = value;
}

- (BOOL) isReplyToMe 
{
    if ([text hasPrefix:[@"@" stringByAppendingString:[[eXoAccount instance] userName]]]) 
	{
        return TRUE;
    }
    return FALSE;
}

- (BOOL) isProbablyReplyToMe 
{
    NSString *query = [@"@" stringByAppendingString:[[eXoAccount instance] userName]];
    NSRange range = [text rangeOfString:query];
    
    if (range.location != NSNotFound) 
	{
        return TRUE;
    }

    return FALSE;
}

- (BOOL) isMyUpdate 
{
    return [screenName isEqualToString:[[eXoAccount instance] userName]];
}

- (void) finishedToSetProperties:(BOOL)forDirectMessage 
{
	if (forDirectMessage) 
	{
		replyType = EXO_MESSAGE_REPLY_TYPE_DIRECT;
	} 
	else 
	{
		if ([self isReplyToMe]) 
		{
		 replyType = EXO_MESSAGE_REPLY_TYPE_REPLY;
		} 
		else if ([self isProbablyReplyToMe]) 
		{
		 replyType = EXO_MESSAGE_REPLY_TYPE_REPLY_PROBABLE;
		} 
		else 
		{
		 replyType = EXO_MESSAGE_REPLY_TYPE_NORMAL;
		}
	}
}

@end
