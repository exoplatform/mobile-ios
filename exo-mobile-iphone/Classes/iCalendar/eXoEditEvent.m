//
//  eXoEditEvent2.m
//  eXoApp
//
//  Created by exo on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "eXoEditEvent.h"
#import "eXoEvent.h"
#import "DateView.h"
#import "EventCategory.h"
#import "httpClient.h"
#import "defines.h"

@implementation eXoEditEvent

@synthesize startTimeLabel, endTimeLabel, priorityLabel, repeatLabel, calendarLabel, categoryLabel, addEvent, event;


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		
		summaryTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 6, 300, 25)];
		summaryTextField.placeholder = @"Required";
		summaryTextField.keyboardType = UIKeyboardTypeASCIICapable;
		summaryTextField.returnKeyType = UIReturnKeyDone;
		summaryTextField.autocorrectionType = UITextAutocorrectionTypeNo;
		summaryTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		summaryTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
		
		locationTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 6, 180, 25)];
		locationTextField.placeholder = @"Touch Here";
		locationTextField.keyboardType = UIKeyboardTypeASCIICapable;
		locationTextField.returnKeyType = UIReturnKeyDone;
		locationTextField.autocorrectionType = UITextAutocorrectionTypeNo;
		locationTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		locationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
		
		startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 180, 25)];
		startTimeLabel.backgroundColor = [UIColor clearColor];
		
		endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 180, 25)];
		endTimeLabel.backgroundColor = [UIColor clearColor];
		
		priorityLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 180, 25)];
		priorityLabel.backgroundColor = [UIColor clearColor];
		
		repeatLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 180, 25)];
		repeatLabel.backgroundColor = [UIColor clearColor];
		
		calendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 180, 25)];
		calendarLabel.backgroundColor = [UIColor clearColor];
		
		categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 180, 25)];
		categoryLabel.backgroundColor = [UIColor clearColor];
		
		swAllDay = [[UISwitch alloc] initWithFrame:CGRectMake(200, 5, 80, 25)];
		[swAllDay addTarget:self action:@selector(allDayForEvent) forControlEvents:UIControlEventValueChanged];
		swAllDay.on = FALSE;
		
		descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 10, 280, 80)];
			
		dateFormatter = [[NSDateFormatter alloc] init];
		//[dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
		[dateFormatter setDateFormat:@"YYYYMMDDHHmmss"];

    }
    return self;
}

-(void)allDayForEvent
{
	
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	if(addEvent)
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain
																				 target:self action:@selector(addNewEvent)];
	else
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Actions" style:UIBarButtonItemStylePlain
																				 target:self action:@selector(eventAction)];
	
	summaryTextField.text = event.summary;
	if( event.description == nil || [event.description isEqualToString:@""])
		descriptionTextView.text = @"Touch here";
	else
		descriptionTextView.text = event.description;
	
	locationTextField.text = event.location;
	
	if(addEvent)
	{
		startTimeLabel.text = [dateFormatter stringFromDate:[NSDate date]];
		endTimeLabel.text = [dateFormatter stringFromDate:[NSDate date]];
	}
	else
	{
		startTimeLabel.text = event.startTime;
		endTimeLabel.text = event.endTime;
	}
	
	priorityLabel.text = event.priority;
	repeatLabel.text = event.repeat;
	calendarLabel.text = event.calendarType;
	categoryLabel.text = event.eventCategory;
	
}

-(void)addNewEvent
{
	
}

-(void)eventAction
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Event action" delegate:self cancelButtonTitle:@"Cancel" 
											   destructiveButtonTitle:@"Update" otherButtonTitles:@"Delete", nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	NSHTTPURLResponse* response;
	NSError* error;
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	NSString *urlStr;
						
	
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];		
	//Add event
	if(buttonIndex == 0)
	{
		urlStr = [NSString stringWithFormat:@"%@/rest/cs/mobile/savecalendar/%@/%d",[userDefaults objectForKey:EXO_PREFERENCE_DOMAIN], event.calendarID, 0];
	}
	//Delete event
	else if(buttonIndex = 1)
	{
		
	}
	
	[request setURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]; 
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody: [NSData dataWithContentsOfFile:@""]];
	
	NSString *s = @"Basic ";
	NSString *userName = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
	NSString *password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
    NSString *author = [s stringByAppendingString: [httpClient stringEncodedWithBase64:[NSString stringWithFormat:@"%@:%@", userName, password ]]];
	[request setValue:author forHTTPHeaderField:@"Authorization"];
	
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSUInteger statusCode = [response statusCode];
	NSLog([NSString stringWithFormat:@"%d", statusCode]);
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	int numberOfRows = 0;
	if(section == 3)
		numberOfRows = 3;
	else if(section == 4)
		numberOfRows = 4;
	else
		numberOfRows = 1;
	
	
	return numberOfRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString* tmpStr = @"";
	switch (section) 
	{
		case 0:
		{
			tmpStr = @"Subject of event:";
			//tmpStr = [_dictLocalize objectForKey:@"DomainHeader"];
			break;
		}	
		case 1:
		{
			tmpStr = @"Event's description:";
			//tmpStr = [_dictLocalize objectForKey:@"DomainHeader"];
			break;
		}	
		case 2:
		{
			tmpStr = @"Event's location:";
			//tmpStr = [_dictLocalize objectForKey:@"DomainHeader"];
			break;
		}
		case 3:
		{
			tmpStr = @"Event time:";
			//tmpStr = [_dictLocalize objectForKey:@"DomainHeader"];
			break;
		}
		case 4:
		{
			tmpStr = @"Others";
			//tmpStr = [_dictLocalize objectForKey:@"AccountHeader"];			
			break;
		}	
		default:
			break;
	}
	
	return tmpStr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int heightOfRow = 0;
	
	if(indexPath.section == 1)
		heightOfRow = 100;
	else
		heightOfRow = 32;
		
	return heightOfRow;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   // if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
   // }
    
    // Set up the cell...
	int section = indexPath.section;
	int row = indexPath.row;
	
	if(section == 0)
	{
		cell.textLabel.text = @"Summary:";
		[cell addSubview:summaryTextField];

	}else if(section == 1)
	{
		[cell addSubview:descriptionTextView];
		
	}else if(section == 2)
	{
		cell.textLabel.text = @"Location";
		[cell addSubview:locationTextField];
		
	}else if(section == 3)
	{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		if(row == 0)
		{
			cell.textLabel.text = @"Start time:";
			[cell addSubview:startTimeLabel];
			
		}else if(row == 1)
		{
			cell.textLabel.text = @"End time:";
			[cell addSubview:endTimeLabel];
		}else
		{
			cell.textLabel.text = @"All day";
			[cell addSubview:swAllDay];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		
	}else if(section == 4)
	{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		if(row == 0)
		{
			cell.textLabel.text = @"Priority";
			[cell addSubview:priorityLabel];
		}
		else if(row == 1)
		{
			cell.textLabel.text = @"Repeat";
			[cell addSubview:repeatLabel];
		}
		else if(row == 2)
		{
			cell.textLabel.text = @"Calendar";
			[cell addSubview:calendarLabel];
		}
		else
		{
			cell.textLabel.text = @"Category";
			[cell addSubview:categoryLabel];
		}
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	int section = indexPath.section;
	int row = indexPath.row;
	
	if(section == 3)
	{
		if(row == 2)
			return;
		
		DateView *dateView = [[DateView alloc] initWithNibName:@"DateView" bundle:nil];
		
		if(row == 0)
		{
			dateView.selectedDate = [dateFormatter dateFromString:startTimeLabel.text];
			dateView.startTime = YES;
		}else if(row == 1)
		{
			dateView.selectedDate = [dateFormatter dateFromString:endTimeLabel.text];
			dateView.startTime = NO;
		}
		
		dateView.event = self;
		[self.navigationController pushViewController:dateView animated:YES];
	}
	else if(section == 4)
	{
		EventCategory *eventCategory = [[EventCategory alloc] initWithStyle:UITableViewStyleGrouped];
		eventCategory.type = row;
		[self.navigationController pushViewController:eventCategory animated:YES];
	}
	
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}


@end

