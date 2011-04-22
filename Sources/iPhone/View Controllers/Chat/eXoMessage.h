//
//  eXoMessage.h
//  eXoApp
//
//  Created by Tran Hoai Son on 5/21/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


enum EXOReplyType 
{
    EXO_MESSAGE_REPLY_TYPE_NORMAL = 0,
    EXO_MESSAGE_REPLY_TYPE_DIRECT,
    EXO_MESSAGE_REPLY_TYPE_REPLY,
    EXO_MESSAGE_REPLY_TYPE_REPLY_PROBABLE,
    EXO_MESSAGE_REPLY_TYPE_MYUPDATE,
};

enum EXOMessageStatus 
{
    EXO_MESSAGE_STATUS_NORMAL = 0,
    EXO_MESSAGE_STATUS_READ,
};

@class eXoMessage;

@protocol eXoMessageIconUpdate
- (void)iconUpdate:(eXoMessage*)sender;
@end

//Message info
@interface eXoMessage : NSObject {
    NSString *statusId;	//Status ID
    NSString *name;	//message owner name
    NSString *screenName;	//Owner display name
    NSString *text;	//Content
	NSString *source;	//address
    NSDate *timestamp;	
    UIImage *icon;	
    enum EXOReplyType replyType;	
    enum EXOMessageStatus status;	
	BOOL favorited;	
	NSObject<eXoMessageIconUpdate> *iconUpdateDelegate;	
}

@property(readwrite, retain) NSString *statusId, *name, *screenName, *text, *source;
@property(readonly) UIImage *icon;
@property(readwrite, retain) NSDate *timestamp;
@property(readwrite) enum EXOReplyType replyType;
@property(readwrite) enum EXOMessageStatus status;
@property BOOL favorited;

- (BOOL) isEqual:(id)anObject;
- (void) finishedToSetProperties:(BOOL)forDirectMessage;

@end
