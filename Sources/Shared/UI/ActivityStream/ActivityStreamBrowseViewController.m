//
//  ActivityStreamBrowseViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 14/06/11.
//  Copyright 2011 eXo. All rights reserved.
//

#import "ActivityStreamBrowseViewController.h"
#import "MockSocial_Activity.h"
#import "ActivityBasicTableViewCell.h"

#define TEST_ON_MOCK 1


@implementation ActivityStreamBrowseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        

        
        
    }
    return self;
}

- (void)dealloc
{
    
#if TEST_ON_MOCK        
    [_mockSocial_Activity release];
    _mockSocial_Activity = nil;
#endif

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Load Activities
#if TEST_ON_MOCK        
    _mockSocial_Activity = [[MockSocial_Activity alloc] init];
#endif
    
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Helpers methods
- (float)getHeighSizeForTableView:(UITableView *)tableView andText:(NSString*)text
{
    //Default value is 0, to force the developper to implement this method
    return 0.0;
}


#pragma mark - Table view Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
#if TEST_ON_MOCK        
    Activity* activity = [_mockSocial_Activity.arrayOfActivities objectAtIndex:indexPath.row];
    NSString* text = activity.title;
    float fHeight = [self getHeighSizeForTableView:tableView andText:text];
    
    return  fHeight;
#endif
    
    return 44.;
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
	static NSString* kCellIdentifier = @"ActivityCell";
	
    //We dequeue a cell
	ActivityBasicTableViewCell* cell = (ActivityBasicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    //Check if we found a cell
    if (cell == nil) 
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityBasicTableViewCell" owner:self options:nil];
        cell = (ActivityBasicTableViewCell *)[nib objectAtIndex:0];        
    }
    
    //ActivityBasicCellViewController* activityBasicCellViewController = [[ActivityBasicCellViewController alloc] initWithNibName:@"ActivityBasicCellViewController" bundle:nil];
    
#if TEST_ON_MOCK        
    Activity* activity = [_mockSocial_Activity.arrayOfActivities objectAtIndex:indexPath.row];
#endif
    NSLog([NSString stringWithFormat:@"%d",indexPath.row],nil);
    NSString* text = activity.title;
    
    float fWidth = tableView.frame.size.width;
    float fHeight = [self getHeighSizeForTableView:tableView andText:text];
    [cell setFrame:CGRectMake(0, 0, fWidth, fHeight)];
    //[activityBasicCellViewController.view setFrame:CGRectMake(0, 0, fWidth, fHeight)];
    //[cell addSubview:activityBasicCellViewController.view];
    [cell setActivity:[_mockSocial_Activity.arrayOfActivities objectAtIndex:indexPath.row]];
    //[activityBasicCellViewController release];
    
    //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
}



@end
