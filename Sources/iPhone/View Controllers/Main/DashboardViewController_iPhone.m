//
//  DashboardViewController_iPhone.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import "DashboardViewController_iPhone.h"

#import "Three20/Three20.h"
#import "Connection.h"
#import "Gadget_iPad.h"
#import "Gadget_iPhone.h"
#import "GadgetDisplayViewController.h"


//Constants Definitions
#define kTagForCellSubviewTitleLabel 22
#define kTagForCellSubviewDescriptionLabel 33
#define kTagForCellSubviewImageView 44

@implementation DashboardViewController_iPhone

@synthesize _arrTabs;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) 
//    {
//        self.title = @"Dashboard";
//    }
//    return self;
//}
//
//- (void)dealloc 
//{
//    [super dealloc];
//}
//
//- (void)loadView 
//{
//    [super loadView];
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //TODO localize that
        self.title = @"Dashboard";
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    Connection *conn = [[Connection alloc] init];
    
    [_arrTabs removeLastObject];
    _arrTabs = [conn getItemsInDashboard];
    
    [_tblGadgets reloadData];
    
    [conn release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    BOOL b = NO;
    if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight))
    {
        b = YES;
    }    
    return b;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    int n = [_arrTabs count]; 
    return n;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return 60;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str = [[_arrTabs objectAtIndex:section] _strDbItemName];
    return str;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	int n = [[[_arrTabs objectAtIndex:section] _arrGadgetsInItem] count];
	return n;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	static NSString* kCellIdentifier = @"Cell";
	
    //We dequeue a cell
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    //Check if we found a cell
    if (cell==nil) 
    {
         
        //Not found, so create a new one
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        //Add subviews only one time, and use the propertie 'Tag' of UIView to retrieve them
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 5.0, 180.0, 20.0)];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        //define the tag for the titleLabel
        titleLabel.tag = kTagForCellSubviewTitleLabel; 
        [cell addSubview:titleLabel];
        //release the titleLabel because cell retain it now
        [titleLabel release];
        
        //Create the descriptionLabel
        UILabel* descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 23.0, 180.0, 33.0)];
        descriptionLabel.numberOfLines = 2;
        descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        descriptionLabel.tag = kTagForCellSubviewDescriptionLabel;
        [cell addSubview:descriptionLabel];
        [descriptionLabel release];
        
        //Create the imageView
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 5.0, 50, 50)];
        imgView.tag = kTagForCellSubviewImageView;
        [cell addSubview:imgView];
        [imgView release];
     
    }
         
    
    //Configurate the cell
    //Configurate the titleLabel and assign good value
	UILabel *titleLabel = (UILabel*)[cell viewWithTag:kTagForCellSubviewTitleLabel];
    titleLabel.text = [[[[_arrTabs objectAtIndex:indexPath.section] _arrGadgetsInItem] objectAtIndex:indexPath.row] name];
    
	//Configuration the DesriptionLabel
    UILabel *descriptionLabel = (UILabel*)[cell viewWithTag:kTagForCellSubviewDescriptionLabel];
	descriptionLabel.text = [[[[_arrTabs objectAtIndex:indexPath.section] _arrGadgetsInItem] objectAtIndex:indexPath.row] description];
	
    //Configuration of the ImageView
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:kTagForCellSubviewImageView];
    imgView.image = [[[[_arrTabs objectAtIndex:indexPath.section] _arrGadgetsInItem] objectAtIndex:indexPath.row] imageIcon];
    
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GateInDbItem *gadgetTab = [_arrTabs objectAtIndex:indexPath.section];
	Gadget_iPhone *gadget = [gadgetTab._arrGadgetsInItem objectAtIndex:indexPath.row];
	NSURL *tmpURL = gadget._urlContent;
	
	
	if (_gadgetDisplayViewController == nil) 
	{
		_gadgetDisplayViewController = [[GadgetDisplayViewController alloc] initWithNibAndUrl:@"GadgetDisplayViewController" bundle:nil url:tmpURL];
	}

	[_gadgetDisplayViewController setUrl:tmpURL];

    [self.navigationController pushViewController:_gadgetDisplayViewController animated:YES];
}


@end