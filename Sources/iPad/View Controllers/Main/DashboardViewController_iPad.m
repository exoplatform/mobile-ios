//
//  DashboardViewController_iPad.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import "DashboardViewController_iPad.h"

#import "Three20UI/UINSStringAdditions.h"

// Core
#import "Three20Core/TTCorePreprocessorMacros.h"

// UI
#import "Three20UI/TTNavigator.h"

// UINavigator
#import "Three20UINavigator/TTURLAction.h"
#import "Three20UINavigator/TTURLMap.h"
#import "Three20UINavigator/TTURLObject.h"

#import "Gadget_iPad.h"
#import "HomeViewController_iPad.h"

#import "AppDelegate_iPad.h"

#import "GadgetDisplayController.h"
#import "RootViewController.h"

//Constants Definitions
#define kTagForCellSubviewTitleLabel 22
#define kTagForCellSubviewDescriptionLabel 33
#define kTagForCellSubviewImageView 44

static NSString* CellIdentifier = @"CellIdentifier";

@implementation DashboardViewController_iPad

@synthesize _arrTabs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
        _arrTabs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_arrTabs release];
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


- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return [_arrTabs count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    GateInDbItem* tab = [_arrTabs objectAtIndex:section];
    return tab._strDbItemName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 60;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    GateInDbItem* tab = [_arrTabs objectAtIndex:section];
    return [tab._arrGadgetsInItem count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) 
    {
        //Not found, so create a new one
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        //Add subviews only one time, and use the propertie 'Tag' of UIView to retrieve them
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 5.0, 320.0, 20.0)];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        //define the tag for the titleLabel
        titleLabel.tag = kTagForCellSubviewTitleLabel; 
        titleLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:titleLabel];
        //release the titleLabel because cell retain it now
        [titleLabel release];
    
        //Create the descriptionLabel
        UILabel* descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 23.0, 320.0, 33.0)];
        descriptionLabel.numberOfLines = 2;
        descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        descriptionLabel.tag = kTagForCellSubviewDescriptionLabel;
        descriptionLabel.backgroundColor = [UIColor clearColor];

        [cell addSubview:descriptionLabel];
        [descriptionLabel release];
        
        //Create the imageView
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(55.0, 5.0, 50, 50)];
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
    GateInDbItem* tab = [_arrTabs objectAtIndex:indexPath.section];
    Gadget_iPad* gadget = [tab._arrGadgetsInItem objectAtIndex:indexPath.row];
    GadgetDisplayController * _gadgetDisplayController = [[GadgetDisplayController alloc] initWithNibName:@"GadgetDisplayController" bundle:nil];
    [_gadgetDisplayController setDelegate:self];
    
    
    
    // push the gadgets
    [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:_gadgetDisplayController invokeByController:self isStackStartView:FALSE];
    

    [_gadgetDisplayController startGadget:gadget];

    
    
}

@end
