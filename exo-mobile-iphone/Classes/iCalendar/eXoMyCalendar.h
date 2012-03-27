//
//  eXoMyCalendar.h
//  eXoApp
//
//  Created by exo on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Button : UIButton
{

	BOOL active;
}

@property BOOL active;

@end


@interface Calendar : UIView {
	
	NSMutableArray *buttonArr;
	int buttonTag;
	UILabel *monthTitle;
	int numOfDay;
	NSDate *myDate;
	id delegate;

}

@property(nonatomic, retain) NSDate *myDate;
@property(nonatomic, retain)id delegate;

-(NSArray *)getEventByDay:(NSDate *)date;
-(NSDictionary *)getEventByMonth:(NSDate *)month;

@end

@interface eXoMyCalendar : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	Calendar *myCalendar;
	UIToolbar *calendarTypeToolbar;
	UIButton *btnToday;
	UISegmentedControl *segCalendartype;
	UITableView *tblEventOnday;
	

}

@property(nonatomic, retain) UIButton *btnToday;
@property(nonatomic, retain) UISegmentedControl *segCalendartype;
@end
