//
//  eXoEvent.m
//  eXoApp
//
//  Created by exo on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "eXoEvent.h"


@implementation eXoEvent

@synthesize summary, description, location, createTime, startTime, endTime, priority, repeat, calendarType, eventCategory, UID, calendarID;

-(void)createEvent:(NSString *)eventStr
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyyMMddTHHmmss"];
	NSArray *eventArr = [eventStr componentsSeparatedByString:@"\n"];
	for(int i = 0; i < [eventArr count]; i++)
	{
		NSString *valueKeyStr = [eventArr objectAtIndex:i];
		NSRange range = [valueKeyStr rangeOfString:@":"];
		NSString *key = [valueKeyStr substringToIndex:range.length];
		NSString *value = [valueKeyStr substringFromIndex:range.length];
		if([key isEqualToString:@"DTSTAMP"])
		{
			self.createTime = value;
			
		}else if([key isEqualToString:@"DTSTART;VALUE=DATE-TIME"])
		{
			self.startTime = value;
			
		}else if([key isEqualToString:@"DTEND;VALUE=DATE-TIME"])
		{
			self.endTime = value;
			
		}else if([key isEqualToString:@"SUMMARY"])
		{
			self.summary = value;
			
		}else if([key isEqualToString:@"DESCRIPTION;VALUE=TEXT"])
		{
			self.description = value;
			
		}else if([key isEqualToString:@"LOCATION;VALUE=TEXT"])
		{
			self.location = value;
			
		}else if([key isEqualToString:@"UID"])
		{
			self.UID = value;
		}

	}
}

@end
