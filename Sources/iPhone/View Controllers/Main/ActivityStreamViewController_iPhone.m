//
//  ActivityStreamViewController_iPhone.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import "ActivityStreamViewController_iPhone.h"
#import "ActivityBasicTableViewCell.h"
#import "ActivityBasicCellViewController.h"
#import "MockSocial_Activity.h"

@implementation ActivityStreamViewController_iPhone


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _mockSocial_Activity = [[MockSocial_Activity alloc] init];
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

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (float)getHeighSizeForTableView:(UITableView *)tableView andText:(NSString*)text
{
    CGRect rectTableView = tableView.frame;
    float fWidth = 0;
    float fHeight = 0;
    
    if (rectTableView.size.width > 320) 
    {
        fWidth = rectTableView.size.width - 85; //fmargin = 85 will be defined as a constant.
    }
    else
    {
        fWidth = rectTableView.size.width - 100;
    }
    
    CGSize theSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:18.0f] constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    if (theSize.height < 100) 
    {
        fHeight = 160;
    }
    else
    {
        fHeight = 50 + theSize.height;
    }
    
    if (fHeight > 200) {
        fHeight = 200;
    }
    return fHeight;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    Activity* activity = [_mockSocial_Activity.arrayOfActivities objectAtIndex:indexPath.row];
    NSString* text = activity.title;
    float fHeight = [self getHeighSizeForTableView:tableView andText:text];
    
    return  fHeight;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	int n = [_mockSocial_Activity.arrayOfActivities count];
	return n;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	static NSString* kCellIdentifier = @"Cell";
	
    //We dequeue a cell
	UITableViewCell* cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    //Check if we found a cell
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
    }
    
    ActivityBasicCellViewController* activityBasicCellViewController = [[ActivityBasicCellViewController alloc] initWithNibName:@"ActivityBasicCellViewController" bundle:nil];
    Activity* activity = [_mockSocial_Activity.arrayOfActivities objectAtIndex:indexPath.row];
    NSLog([NSString stringWithFormat:@"%d",indexPath.row],nil);
    NSString* text = activity.title;
     
    float fWidth = tableView.frame.size.width;
    float fHeight = [self getHeighSizeForTableView:tableView andText:text];
    [activityBasicCellViewController.view setFrame:CGRectMake(0, 0, fWidth, fHeight)];
    [cell addSubview:activityBasicCellViewController.view];
    [activityBasicCellViewController setActivity:[_mockSocial_Activity.arrayOfActivities objectAtIndex:indexPath.row]];
    [activityBasicCellViewController release];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
}


@end
