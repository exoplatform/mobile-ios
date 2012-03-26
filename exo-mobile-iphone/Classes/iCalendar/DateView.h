//
//  DateView.h
//  eXoApp
//
//  Created by exo on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eXoEditEvent;

@interface DateView : UIViewController {
	IBOutlet UIDatePicker *datePicker;
	IBOutlet UITextField *selectedDateTextField;
	NSDate *selectedDate;
	BOOL startTime;
	
	eXoEditEvent *event;
	NSDateFormatter *dateFormatter;
}

@property(nonatomic, retain) NSDate *selectedDate;
@property(nonatomic, retain) eXoEditEvent *event;
@property BOOL startTime;

-(IBAction)dateChanged:(id)sender;

@end
