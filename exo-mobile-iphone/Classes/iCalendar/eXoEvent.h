//
//  eXoEvent.h
//  eXoApp
//
//  Created by exo on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//
@interface eXoEvent : NSObject {
	
	NSString *summary;
	NSString *description;
	NSString *location;
	NSString *createTime;
	NSString *startTime;
	NSString *endTime;
	NSString *priority;
	NSString *repeat;
	NSString *calendarType;
	NSString *eventCategory;
	NSString *UID;
	NSString *calendarID;
}

@property(nonatomic, retain) NSString *summary;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSString *location;
@property(nonatomic, retain) NSString *createTime;
@property(nonatomic, retain) NSString *startTime;
@property(nonatomic, retain) NSString *endTime;
@property(nonatomic, retain) NSString *priority;
@property(nonatomic, retain) NSString *repeat;
@property(nonatomic, retain) NSString *calendarType;
@property(nonatomic, retain) NSString *eventCategory;
@property(nonatomic, retain) NSString *UID;
@property(nonatomic, retain) NSString *calendarID;

-(void)createEvent:(NSString *)eventStr;

@end
