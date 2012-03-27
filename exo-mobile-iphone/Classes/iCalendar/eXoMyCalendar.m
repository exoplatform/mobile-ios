//
//  eXoMyCalendar.m
//  eXoApp
//
//  Created by exo on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "eXoMyCalendar.h"
#import "eXoEvent.h"
#import "eXoListOfEvent.h"
#import "httpClient.h"
#import "defines.h"
#import "JSON.h"

@implementation Button


@synthesize active;

- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {

		self.titleLabel.font = [UIFont systemFontOfSize:15];
	}

	return self;
}
@end

@interface Calendar (Private) 

#define BUTTON_WIDTH 40
#define BUTTON_HEIGHT 40

UIFont *monthFont;
UIFont *weekFont;
UIFont *dayFont;


-(int)getDay:(NSDate *)date;
-(int)getMonth:(NSDate *)date;
-(int)getYear:(NSDate *)date;

-(int)firstDayofMonth:(NSDate *)date;
-(int)numOfDays:(NSDate *)date;
-(void)addDay:(NSDate *)date numfDays:(int)numDays;

-(void)nextMonth:(NSDate *)date;
-(void)prevMonth:(NSDate *)date;

-(void)removeCalendar;

-(void)reDraw;
-(void)drawCalendar;
-(void)drawWeekLabel;

@end


@implementation Calendar

@synthesize delegate, myDate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		monthFont = [UIFont boldSystemFontOfSize:18];
		monthTitle = [[UILabel alloc] init];
		monthTitle.frame = CGRectMake(0, 0, 100, 20);
		monthTitle.center = CGPointMake(160, 25);
		monthTitle.backgroundColor = [UIColor clearColor];
		monthTitle.textColor = [UIColor greenColor];
		monthTitle.font = monthFont;
		
		myDate = [[NSDate date] retain];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"MMM yyyy"];
		monthTitle.text = [dateFormatter stringFromDate:myDate];
		[self addSubview:monthTitle];
		[dateFormatter release];
		
		UIButton *nextMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(210, 15, 20, 20)];
		[nextMonthButton setBackgroundImage:[UIImage imageNamed:@"next.jpg"] forState:UIControlStateNormal];
		[nextMonthButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchDown];
		[self addSubview:nextMonthButton];
		
		UIButton *prevMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(70, 15, 20, 20)];
		[prevMonthButton setBackgroundImage:[UIImage imageNamed:@"back.jpg"] forState:UIControlStateNormal];
		[prevMonthButton addTarget:self action:@selector(prev) forControlEvents:UIControlEventTouchDown];
		[self addSubview:prevMonthButton];
		
		//self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
		//self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"calendarTheme2.png"]];
		self.backgroundColor = [UIColor grayColor];
		
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	
	[self drawWeekLabel];
    [self drawCalendar];
	
}

-(void)next {
	[self nextMonth:myDate];
	[self drawCalendar];
}

-(void)prev {
	[self prevMonth:myDate];
	[self drawCalendar];
}

-(int)getDay:(NSDate *)date {
	int myDay = 0;
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"d"];
	myDay = [[dateFormatter stringFromDate:date] intValue];
	
	[dateFormatter release];
	return myDay;
}

-(int)getMonth:(NSDate *)date {
	int myMonth = 0;
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"M"];
	myMonth = [[dateFormatter stringFromDate:date] intValue];
	
	[dateFormatter release];
	return myMonth;
}

-(int)getYear:(NSDate *)date {
	int myYear = 0;
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy"];
	myYear = [[dateFormatter stringFromDate:date] intValue];
	
	[dateFormatter release];
	return myYear;
}

-(void)nextMonth:(NSDate *)date {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
	
    [comps setMonth:1];
	myDate = [[gregorian dateByAddingComponents:comps toDate:date options:0] retain];
	
    [comps release];
	[gregorian release];
	
	
}

-(void)prevMonth:(NSDate *)date {
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
	
    [comps setMonth:-1];
	myDate = [[gregorian dateByAddingComponents:comps toDate:date options:0] retain];
	
    [comps release];
    [gregorian release];
	
}

-(int)firstDayofMonth:(NSDate *)date {
	
	NSString *myFirstDay = [[NSString alloc] init];
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	[dateFormatter setDateFormat:@"EEE"];
	
    [comps setDay:1];
	[comps setMonth:[self getMonth:date]];
	[comps setYear:[self getYear:date]];
	
	myFirstDay = [dateFormatter stringFromDate:[gregorian dateFromComponents:comps]];
	
	int returnValue = -1;
	if([myFirstDay isEqualToString:@"Sun"])
		returnValue = 0;
	if([myFirstDay isEqualToString:@"Mon"])
		returnValue = 1;
	if([myFirstDay isEqualToString:@"Tue"])
		returnValue = 2;
	if([myFirstDay isEqualToString:@"Wed"])
		returnValue = 3;
	if([myFirstDay isEqualToString:@"Thu"])
		returnValue = 4;
	if([myFirstDay isEqualToString:@"Fri"])
		returnValue = 5;
	if([myFirstDay isEqualToString:@"Sat"])
		returnValue = 6;
	
	[comps release];
    [gregorian release];
	[dateFormatter release];
	
	return returnValue;
}

-(int)numOfDays:(NSDate *)date {
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSRange range = [gregorian rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
	
	[gregorian release];
	
	return range.length;
}

-(void)removeCalendar {
	for(int i = 0; i < [buttonArr count]; i++) {
		[(UIButton *)[buttonArr objectAtIndex:i] removeFromSuperview];
	}
}

-(void)drawWeekLabel {
	
	weekFont = [UIFont boldSystemFontOfSize:15];
	for(int i = 0; i < 7; i++) {
		UILabel *tmp = [[UILabel alloc] initWithFrame:CGRectMake(30 + (BUTTON_WIDTH + 1) * i, 35, 45, 20)];
		tmp.backgroundColor = [UIColor clearColor];
		tmp.font = weekFont;
		tmp.textColor = [UIColor blueColor];
		switch (i) {
			case 0:
			{
				tmp.text = @"Su";
				tmp.textColor = [UIColor redColor];
			}
				break;
			case 1:
				tmp.text = @"Mo";
				break;
			case 2:
				tmp.text = @"Tu";
				break;
			case 3:
				tmp.text = @"We";
				break;
			case 4:
				tmp.text = @"Th";
				break;
			case 5:
				tmp.text = @"Fr";
				break;
			case 6:
			{
				tmp.textColor = [UIColor cyanColor];
				tmp.text = @"Sa";
			}
				
				break;
			default:
				break;
		}
		
		[self addSubview:tmp];
		
	}
}

-(void)drawCalendar {
	
	[self removeCalendar];
	
	dayFont = [UIFont systemFontOfSize:10];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM yyyy"];
	monthTitle.text = [dateFormatter stringFromDate:myDate];
	
	
	int firstDay = [self firstDayofMonth:myDate];
	numOfDay = [self numOfDays:myDate];
	int count = 0;
	
	buttonArr = [[NSMutableArray alloc] init];
	for(int col = 0; col < 6; col++) {
		CGPoint point;
		for(int row= 0; row < 7; row++) {
			count++;
			if(count <= numOfDay) {
				if(row == 0 && col == 0)
					row = firstDay;
				point = CGPointMake(20 + (BUTTON_WIDTH + 1) * row, 50 + (BUTTON_HEIGHT + 1) * col);
				Button *bt = [[Button alloc] initWithFrame:CGRectMake(point.x, point.y, BUTTON_WIDTH, BUTTON_HEIGHT)];
				
				[bt addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
				//[bt setImage:[UIImage imageNamed:@"active.png"] forState:UIControlStateNormal];
				[bt setBackgroundImage:[UIImage imageNamed:@"active.png"] forState:UIControlStateNormal];
				if(count == (7*col - firstDay + 1))
					[bt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
				
				if(count == (7*(col + 1) - firstDay))
					[bt setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];

				
				[bt setTitle:[NSString stringWithFormat:@"%d", count] forState:UIControlStateNormal];
				
				[buttonArr addObject:bt];
				[self addSubview:bt];
				[bt release];
			}
			
		}
		
	}
	
	[self reDraw];
	[dateFormatter release];
}

-(NSArray *)getDaysHaveEvent:(NSArray *)eventArray Month:(NSDate *)date
{

	NSMutableArray *resulArr = [[NSMutableArray alloc] init];
	int count = [eventArray count];
	
	for(int i = 0; i < count; i++)
	{
		NSDictionary *tmp = [eventArray objectAtIndex:i];
		NSDictionary *startTimeDic = [tmp objectForKey:@"fromDateTime"];
		long timeInterval = [[startTimeDic objectForKey:@"time"] doubleValue] / 1000;
		NSString *dataStr = [NSString stringWithFormat:@"%.0f", timeInterval];
		int count = [resulArr count];
		if(count == 0)
		{
			[resulArr addObject:dataStr];
		}
		else
		{
			for(int j = 0; j < count; j++)
			{
				BOOL isExisted = FALSE;
				NSString *tmpStr = [resulArr objectAtIndex:j];
				if([dataStr isEqualToString:tmpStr])
				{
					isExisted = TRUE;
					break;
				}
				if(!isExisted)
					[resulArr addObject:tmpStr];
			}
		}
	}
	
	return resulArr;
}

-(NSArray *)getEventByDay:(NSDate *)date
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
	[dateFormatter setDateFormat:@"YYYYMMDDHHmmss"];
	
	NSString *startTimeStr = [dateFormatter stringFromDate:date];
	
    [comps setHour:23];
	[comps setMinute:59];
	[comps setSecond:59];
	NSDate *endTimeDate = [[gregorian dateByAddingComponents:comps toDate:date options:0] retain];
	
	NSString *endTimeStr = [dateFormatter stringFromDate:endTimeDate];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *urlStr = [NSString stringWithFormat:@"%@/rest/cs/mobile/searchevents/%@/%@", 
						[userDefaults objectForKey:EXO_PREFERENCE_DOMAIN], startTimeStr, endTimeStr];
	
	NSData *data = [httpClient sendRequestWithAuthorization:urlStr];
	//NSData *data = [httpClient sendRequest:urlStr];
	NSString *reponseStr = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];

	
	//NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

	// jsonString contains the actual JSON output from your web service
	SBJSON *json = [[SBJSON alloc] init];
	NSError *error = nil;

	NSMutableArray *resulArr = [[NSMutableArray alloc] init];
	
	NSDictionary *dic = [json objectWithString:reponseStr error:&error];
	NSArray *eventArr = [dic objectForKey:@"data"];
	int count = [eventArr count];
	
	for(int i = 0; i < count; i++)
	{
		NSDictionary *tmp = [eventArr objectAtIndex:i];
		
		eXoEvent *event = [[eXoEvent alloc] init];
		
		event.summary = [tmp objectForKey:@"summary"];
		event.description = [tmp objectForKey:@"description"];
		event.location = [tmp objectForKey:@"location"];
		
		NSDictionary *startTimeDic = [tmp objectForKey:@"fromDateTime"];
		long timeInterval = [[startTimeDic objectForKey:@"time"] doubleValue] / 1000;
		NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
		[comps setHour:[[startTimeDic objectForKey:@"hours"] intValue]];
		[comps setMinute:[[startTimeDic objectForKey:@"minutes"] intValue]];
		[comps setSecond:[[startTimeDic objectForKey:@"seconds"] intValue]];
		event.startTime = [dateFormatter stringFromDate:[gregorian dateByAddingComponents:comps toDate:startDate options:0]];


		NSDictionary *endTimeDic = [tmp objectForKey:@"toDateTime"];
		long timeInterval2 = [[endTimeDic objectForKey:@"time"] doubleValue] / 1000;
		NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:timeInterval2];
		[comps setHour:[[endTimeDic objectForKey:@"hours"] intValue]];
		[comps setMinute:[[endTimeDic objectForKey:@"minutes"] intValue]];
		[comps setSecond:[[endTimeDic objectForKey:@"seconds"] intValue]];
		event.endTime = [dateFormatter stringFromDate:[gregorian dateByAddingComponents:comps toDate:endDate options:0]];
		
		event.priority = [tmp objectForKey:@"priority"];
		event.repeat = [tmp objectForKey:@"repeatType"];
		event.calendarType = [tmp objectForKey:@"eventCategoryId"];
		event.eventCategory = [tmp objectForKey:@"eventCategoryName"];
		event.UID = [tmp objectForKey:@"id"];
		event.calendarID = [tmp objectForKey:@"calendarId"];
		
		[resulArr addObject:event];
	}
	
	[comps release];
	[gregorian release];
	
	return resulArr;

}

-(NSDictionary *)getEventByMonth:(NSDate *)month
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
	[dateFormatter setDateFormat:@"YYYYMMDDHHmmss"];

	[comps setYear:[self getYear:month]];
	[comps setMonth:[self getMonth:month]];
	[comps setDay:1];
    [comps setHour:0];
	[comps setMinute:0];
	[comps setSecond:0];
	
	NSDate *date = [[gregorian dateFromComponents:comps] retain];
	NSString *startTimeStr = [dateFormatter stringFromDate:date];
	
	
	[comps setDay:[self numOfDays:month]];
    [comps setHour:23];
	[comps setMinute:59];
	[comps setSecond:59];
	
	date = [[gregorian dateFromComponents:comps] retain];
	NSString *endTimeStr = [dateFormatter stringFromDate:date];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *urlStr = [NSString stringWithFormat:@"%@/rest/cs/mobile/searchevents/%@/%@", 
						[userDefaults objectForKey:EXO_PREFERENCE_DOMAIN], startTimeStr, endTimeStr];
	
	//NSLog(urlStr);
	
	NSData *data = [httpClient sendRequestWithAuthorization:urlStr];
	//NSData *data = [httpClient sendRequest:urlStr];
	NSString *reponseStr = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
	
	
	//NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	// jsonString contains the actual JSON output from your web service
	SBJSON *json = [[SBJSON alloc] init];
	NSError *error = nil;
	
	NSMutableArray *resultArr = [[NSMutableArray alloc] init];
	NSDictionary *resultDic = [[NSDictionary alloc] init];
	
	NSDictionary *dicJson = [json objectWithString:reponseStr error:&error];
	NSArray *eventArr = [dicJson objectForKey:@"data"];
	NSArray *daysHaveEventArr = [self getDaysHaveEvent:eventArr Month:month];
	
	for(int i = 0; i < [daysHaveEventArr count]; i++)
	{
		NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
		[resultDic setValue:mutableArr forKey:[daysHaveEventArr objectAtIndex:i]];
	}
	
	int count = [eventArr count];
	
	for(int i = 0; i < count; i++)
	{
		NSDictionary *tmp = [eventArr objectAtIndex:i];
		
		eXoEvent *event = [[eXoEvent alloc] init];
		
		event.summary = [tmp objectForKey:@"summary"];
		event.description = [tmp objectForKey:@"description"];
		event.location = [tmp objectForKey:@"location"];
		
		NSDictionary *startTimeDic = [tmp objectForKey:@"fromDateTime"];
		long timeInterval = [[startTimeDic objectForKey:@"time"] doubleValue] / 1000;
		NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
		[comps setHour:[[startTimeDic objectForKey:@"hours"] intValue]];
		[comps setMinute:[[startTimeDic objectForKey:@"minutes"] intValue]];
		[comps setSecond:[[startTimeDic objectForKey:@"seconds"] intValue]];
		event.startTime = [dateFormatter stringFromDate:[gregorian dateByAddingComponents:comps toDate:startDate options:0]];
		
		
		NSDictionary *endTimeDic = [tmp objectForKey:@"toDateTime"];
		long timeInterval2 = [[endTimeDic objectForKey:@"time"] doubleValue] / 1000;
		NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:timeInterval2];
		[comps setHour:[[endTimeDic objectForKey:@"hours"] intValue]];
		[comps setMinute:[[endTimeDic objectForKey:@"minutes"] intValue]];
		[comps setSecond:[[endTimeDic objectForKey:@"seconds"] intValue]];
		event.endTime = [dateFormatter stringFromDate:[gregorian dateByAddingComponents:comps toDate:endDate options:0]];
		
		event.priority = [tmp objectForKey:@"priority"];
		event.repeat = [tmp objectForKey:@"repeatType"];
		event.calendarType = [tmp objectForKey:@"eventCategoryId"];
		event.eventCategory = [tmp objectForKey:@"eventCategoryName"];
		event.UID = [tmp objectForKey:@"id"];
		event.calendarID = [tmp objectForKey:@"calendarId"];
		
		for(int j = 0; j < [resultArr count]; j++)
		{
			NSMutableArray *arr = [resultDic objectForKey:[NSString stringWithFormat:[NSString stringWithFormat:@"%.0f", timeInterval]]];
			
			[arr addObject:event];
		}

	}
	
	[comps release];
	[gregorian release];
	
	return resultDic;
	
}

-(void)selected:sender {
	
	int day = 0;
	for(int i = 0; i < [buttonArr count]; i++) {
		Button *bt = (Button *)[buttonArr objectAtIndex:i];
		if([bt isEqual:(Button *)sender]) {
			day = i + 1;
			bt.active = YES;
		}else
			bt.active = NO;
	}
	[self reDraw];
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	
    [comps setDay:day];
	[comps setMonth:[self getMonth:myDate]];
	[comps setYear:[self getYear:myDate]];
	
	myDate = [[gregorian dateFromComponents:comps] retain];
	
	[gregorian release];
	[comps release];
	eXoMyCalendar *calendar = (eXoMyCalendar *)delegate;
	eXoListOfEvent *listOfEvents = [[eXoListOfEvent alloc] initWithStyle:UITableViewStyleGrouped];
	
	listOfEvents.listOfEvent = [self getEventByDay:myDate];
	
	[calendar.navigationController pushViewController:listOfEvents animated:YES];
}

-(void)reDraw {
	
	int currentDate = [self getDay:[NSDate date]];
	int currentMonth = [self getMonth:[NSDate date]];
	int currentYear = [self getYear:[NSDate date]];
	
	int myMonth = [self getMonth: myDate];
	int myYear = [self getYear: myDate];
	
	for(int i = 0; i < [buttonArr count]; i++) {
		Button *bt = (Button *)[buttonArr objectAtIndex:i];
		if(currentDate != (i+1) || currentMonth != myMonth || currentYear != myYear) {
			if(bt.active)
				[bt setBackgroundImage:[UIImage imageNamed:@"active.png"] forState:UIControlStateNormal];
			else
				[bt setBackgroundImage:[UIImage imageNamed:@"inactive.png"] forState:UIControlStateNormal];
		}else {
			if(bt.active)
				[bt setBackgroundImage:[UIImage imageNamed:@"current.png"] forState:UIControlStateNormal];
			else 
				[bt setBackgroundImage:[UIImage imageNamed:@"incurrent.png"] forState:UIControlStateNormal];
			
		}
		
		
	}
	
}


@end

@implementation eXoMyCalendar

@synthesize btnToday, segCalendartype;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
	
		myCalendar = [[Calendar alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
		myCalendar.delegate = self;
		[myCalendar getEventByMonth:myCalendar.myDate];
		[self.view addSubview:myCalendar];
		
		tblEventOnday = [[UITableView alloc] initWithFrame:CGRectMake(0, 300, 320, 200)];
		tblEventOnday.dataSource = self;
		tblEventOnday.delegate = self;
		[self.view addSubview:tblEventOnday];
		
		btnToday = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		btnToday.frame = CGRectMake(10, 5, 50, 30);
		[btnToday addTarget:self action:@selector(todayCanlendar) forControlEvents:UIControlEventTouchUpInside];
		[btnToday setTitle:@"Today" forState:UIControlStateNormal];
		
		
		NSArray * buttonArr = [[NSArray alloc] initWithObjects:@"Month", @"Day", @"List", nil];
		segCalendartype = [[UISegmentedControl alloc] initWithItems:buttonArr];
		[buttonArr release];
		segCalendartype.segmentedControlStyle = UISegmentedControlStyleBordered;
		segCalendartype.frame = CGRectMake(70, 5, 200, 30);
		segCalendartype.selectedSegmentIndex = 0;
		
		[segCalendartype addTarget:self action:@selector(setCalendarType) forControlEvents:UIControlEventValueChanged];
		segCalendartype.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		

		
		//self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"calendarTheme.jpg"]];
		
		//calendarTypeToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(10, 5, 300, 30)];
		
		
    }
	
    return self;
	
}

-(void)todayCanlendar
{
	
}

-(void)setCalendarType
{
	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 30;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.textLabel.text = @"Test";
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
