//
//  EventCategory.m
//  eXoApp
//
//  Created by exo on 1/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventCategory.h"


@implementation EventCategory

@synthesize type, selectedItem;


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		
		type = -1;
		selectedItem = -1;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	//[categoryArr release];
	
	if(type == 0)
		categoryArr = [[NSArray alloc] initWithObjects:@"None", @"Normal", @"High", @"Low", nil];
	else if(type == 1)
		categoryArr = [[NSArray alloc] initWithObjects:@"No repeat", @"Daily", @"Working days", @"Weekend", @"Weekly", @"Monthly", @"Yearly", nil];
	else if(type == 2)
		categoryArr = [[NSArray alloc] initWithObjects:@"Personal calendars", @"Default", @"Group calendars", @"Executive-board calendar", @"Administrators calendar", @"Users calendar", nil];
	else
		categoryArr = [[NSArray alloc] initWithObjects:@"Meetings", @"Calls", @"Clients", @"Holiday", @"Anniversary", nil];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
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
	if(type == 2)
		return 2;
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int numOfRow = 0;
	if(type == 2)
	{
		if(section == 0)
			numOfRow = 1;
		else
			numOfRow = 3;
	}
		
	else
		numOfRow = [categoryArr count];

    return numOfRow;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *title = @"";
	if(type == 2)
	{
		if(section == 0)
			title = [categoryArr objectAtIndex:0];
		else
			title = [categoryArr objectAtIndex:2];
	}
	
	return title;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	int section = indexPath.section;
	int row = indexPath.row;
	
	if(type == 2)
	{
		if(section == 0)
		{
			cell.textLabel.text = [categoryArr objectAtIndex:1];
		}
		else
		{
			if(row == 0)
				cell.textLabel.text = [categoryArr objectAtIndex:3];
			else if(row == 1)
				cell.textLabel.text = [categoryArr objectAtIndex:4];
			else
				cell.textLabel.text = [categoryArr objectAtIndex:5];
		}

	}
	else
	{
		cell.textLabel.text = [categoryArr objectAtIndex:row];
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
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

