//
//  eXoEditEvent2.h
//  eXoApp
//
//  Created by exo on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eXoEvent;

@interface eXoEditEvent : UITableViewController<UIActionSheetDelegate> {

	eXoEvent *event;
	BOOL addEvent;
	
	UITextField *summaryTextField;
	UILabel		*startTimeLabel;
	UILabel		*endTimeLabel;
	UITextView	*descriptionTextView;
	UITextField *locationTextField;
	UILabel		*priorityLabel;
	UILabel		*repeatLabel;
	UILabel		*calendarLabel;
	UILabel		*categoryLabel;
	
	UISwitch *swAllDay;
	
	NSDateFormatter *dateFormatter;
}

@property(nonatomic, retain) UILabel *startTimeLabel;
@property(nonatomic, retain) UILabel *endTimeLabel;
@property(nonatomic, retain) UILabel *priorityLabel;
@property(nonatomic, retain) UILabel *repeatLabel;
@property(nonatomic, retain) UILabel *calendarLabel;
@property(nonatomic, retain) UILabel *categoryLabel;

@property(nonatomic, retain) eXoEvent *event;
@property BOOL addEvent;

@end
