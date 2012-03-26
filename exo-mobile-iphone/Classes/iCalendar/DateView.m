//
//  DateView.m
//  eXoApp
//
//  Created by exo on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DateView.h"
#import "eXoEditEvent.h"


@implementation DateView

@synthesize selectedDate, event, startTime;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"YYYYMMDDHHmmss"];
		
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain
																			 target:self action:@selector(save)];
	
	selectedDateTextField.font = [UIFont systemFontOfSize:15];
	selectedDateTextField.enabled = NO;
	
	datePicker.date = selectedDate;
	selectedDateTextField.text = [dateFormatter stringFromDate:datePicker.date];
	
}

-(void)save
{
	if(startTime)
		event.startTimeLabel.text = selectedDateTextField.text;
	else
		event.endTimeLabel.text = selectedDateTextField.text;
	
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)dateChanged:(id)sender
{
	selectedDateTextField.text = [dateFormatter stringFromDate:datePicker.date];
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
