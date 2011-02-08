//
//  eXoMessage.m
//  eXoApp
//
//  Created by Tran Hoai Son on 5/21/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import "eXoMessage.h"
#import "defines.h"

@implementation eXoMessage

@synthesize statusId, name, screenName, text, icon, timestamp, replyType, status, source, favorited;

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
	NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_USERNAME];
    if ([text hasPrefix:[@"@" stringByAppendingString:userName]]) 
	{
        return TRUE;
    }
    return FALSE;
}

- (BOOL) isProbablyReplyToMe 
{
	NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_USERNAME];
    NSString *query = [@"@" stringByAppendingString:userName];
    NSRange range = [text rangeOfString:query];
    
    if (range.location != NSNotFound) 
	{
        return TRUE;
    }

    return FALSE;
}

- (BOOL) isMyUpdate 
{
	NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_USERNAME];
    return [screenName isEqualToString:userName];
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
