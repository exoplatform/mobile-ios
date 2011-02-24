//
//  eXoGadgetViewController.m
//  eXoMobile
//
//  Created by Mai Thanh Xuyen on 8/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "eXoGadgetViewController.h"
#import "Gadget_iPhone.h"
#import "eXoApplicationsViewController.h"
#import "eXoWebViewController.h"
#import "GadgetDisplayViewController.h"

@implementation eXoGadgetViewController


#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style delegate:(eXoApplicationsViewController *)delegate 
						gadgetTab:(GateInDbItem_iPhone *)gagetTab {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		
		_delegate = delegate;
		_gadgetTab = gagetTab;
    }
    return self;
}



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = _gadgetTab._strDbItemName;
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_gadgetTab._arrGadgetsInItem count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		//Configure the cell
#define TAG_FOR_TITLE_LABEL 97
#define TAG_FOR_DESCRIPTION_LABEL 98
#define TAG_FOR_IMGVIEW_LABEL 99
		
		//Add the title label
		UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 5.0, 210.0, 20.0)];
		titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
		titleLabel.tag = TAG_FOR_TITLE_LABEL;
		[cell addSubview:titleLabel];	
		
		//Add the description label
		UILabel* descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 23.0, 210.0, 33.0)];
		descriptionLabel.numberOfLines = 2;
		descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
		descriptionLabel.tag = TAG_FOR_DESCRIPTION_LABEL;
		[cell addSubview:descriptionLabel];
		
		//Add the imageview
		UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 5.0, 50, 50)];
		imgView.tag = TAG_FOR_IMGVIEW_LABEL;
		[cell addSubview:imgView];

    } 

    
	Gadget_iPhone *gadget = [_gadgetTab._arrGadgetsInItem objectAtIndex:indexPath.row];
  
	//Add values...
	UILabel* titleLabel = (UILabel *)[cell viewWithTag:TAG_FOR_TITLE_LABEL];
	titleLabel.text = gadget._strName;

	UILabel* descriptionLabel = (UILabel *)[cell viewWithTag:TAG_FOR_DESCRIPTION_LABEL];
	descriptionLabel.text = gadget._strDescription;
	
	UIImageView* imgView = (UIImageView *)[cell viewWithTag:TAG_FOR_IMGVIEW_LABEL];
	imgView.image = gadget._imgIcon;			
    
    return cell;
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


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	Gadget_iPhone *gadget = [_gadgetTab._arrGadgetsInItem objectAtIndex:indexPath.row];
	NSURL *tmpURL = gadget._urlContent;
//	eXoWebViewController* tmpView = [[eXoWebViewController alloc] initWithNibAndUrl:@"eXoWebViewController" bundle:nil url:tmpURL];
//	tmpView._delegate = _delegate;
//	[[self navigationController] pushViewController:tmpView animated:YES];
	
	if (_gadgetDisplayViewController == nil) 
	{
		_gadgetDisplayViewController = [[GadgetDisplayViewController alloc] initWithNibAndUrl:@"GadgetDisplayViewController" bundle:nil url:tmpURL];
	}
	
	//[_gadgetDisplayViewController startGadget:gadget];
	[_gadgetDisplayViewController setUrl:tmpURL];
	if ([self.navigationController.viewControllers containsObject:_gadgetDisplayViewController]) 
	{
		[self.navigationController popToViewController:_gadgetDisplayViewController animated:YES];
	}
	else 
	{
		[self.navigationController pushViewController:_gadgetDisplayViewController animated:YES];
	}
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

