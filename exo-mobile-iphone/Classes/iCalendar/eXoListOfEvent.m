//
//  eXoListOfEvent.m
//  eXoApp
//
//  Created by exo on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "eXoListOfEvent.h"
#import "eXoEvent.h"
#import "eXoEditEvent.h"

@implementation eXoListOfEvent

@synthesize listOfEvent;

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" 
																		style:UIBarButtonItemStylePlain target:self action:@selector(addNewEvent)];
    }
    return self;
}

-(void)addNewEvent
{
	eXoEditEvent *addNewEvent = [[eXoEditEvent alloc] initWithStyle:UITableViewStyleGrouped];
	addNewEvent.addEvent = YES;
	[self.navigationController pushViewController:addNewEvent animated:YES];
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

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
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listOfEvent count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   // if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
   // }
	
	eXoEvent *event = (eXoEvent *)[listOfEvent objectAtIndex:indexPath.row];
	
	UILabel *summary = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 200, 20)];
	summary.font = [UIFont systemFontOfSize:20];
	summary.text = event.summary;
	[cell addSubview:summary];
	
	UILabel *location = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 200, 15)];
	location.font = [UIFont systemFontOfSize:15];
	location.text = event.location;
	[cell addSubview:location];
	
	UILabel *startTime = [[UILabel alloc] initWithFrame:CGRectMake(210, 5, 50, 15)];
	startTime.font = [UIFont systemFontOfSize:15];
	startTime.text = event.startTime;
	[cell addSubview:startTime];
	
	UILabel *endTime = [[UILabel alloc] initWithFrame:CGRectMake(210, 30, 50, 15)];
	endTime.font = [UIFont systemFontOfSize:15];
	endTime.text = event.endTime;
	[cell addSubview:endTime];
	
    // Set up the cell...
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	eXoEditEvent *event = [[eXoEditEvent alloc] initWithStyle:UITableViewStyleGrouped];
	event.event = [listOfEvent objectAtIndex:indexPath.row];
	event.addEvent = FALSE;
	[self.navigationController pushViewController:event animated:YES];
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

