//
//  AcitivityDetailViewController.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "MockSocial_Activity.h"

#import "ActivityDetailCommentTableViewCell.h"
#import "ActivityDetailMessageTableViewCell.h"
#import "ActivityDetailLikeTableViewCell.h"
#import "ActivityStreamBrowseViewController.h"


@implementation ActivityDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _activity = [[Activity alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_activity release];
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

- (void)setActivity:(Activity*)activity
{
    _activity =  activity;
    [_tblvActivityDetail reloadData];
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
    
    CGSize theSize = [text sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    
    if (theSize.height < 30) 
    {
        fHeight = 50;
    }
    else
    {
        fHeight = 35 + theSize.height;
    }
    
    if (fHeight > 200) {
        fHeight = 200;
    }
    return fHeight;
}

#pragma mark - Table view Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    int n = 3;
    if (_activity.nbLikes == 0) 
    {
        n --;
    }
    if (_activity.nbComments == 0) 
    {
        n--;
    }
    return n;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    int n = 0;
    if (section == 0) 
    {
        n = 1;
    }
    if (section == 1) 
    {
        n = 1;
    }
    if (section == 2) 
    {
        //n = _activity.nbComments;
        n = 3;
    }
    return n;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //return 44.;
    int n = 0;
    if (indexPath.section == 0) 
    {
        n = [self getHeighSizeForTableView:tableView andText:_activity.title];
    }
    if (indexPath.section == 1) 
    {
        n = [self getHeighSizeForTableView:tableView andText:@"John, Mary, Jack like"];
    }
    if (indexPath.section == 2) 
    {
        //n = _activity.nbComments;
        n = 71;
    }
    return n;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString* kCellIdentifier = @"ActivityCell";
	
    //If section for messages
    if (indexPath.section == 0) 
    {
        ActivityDetailMessageTableViewCell* cell = (ActivityDetailMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        
        //Check if we found a cell
        if (cell == nil) 
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityDetailMessageTableViewCell" owner:self options:nil];
            cell = (ActivityDetailMessageTableViewCell *)[nib objectAtIndex:0];
            
            //Create a cell, need to do some configurations
            [cell configureCell];
            [cell setActivity:_activity];
        }
        
        return cell;
    }
    else if (indexPath.section == 1) 
    {
        ActivityDetailLikeTableViewCell* cell = (ActivityDetailLikeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        
        //Check if we found a cell
        if (cell == nil) 
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityDetailLikeTableViewCell" owner:self options:nil];
            cell = (ActivityDetailLikeTableViewCell *)[nib objectAtIndex:0];
            
            //Create a cell, need to do some configurations
            [cell configureCell];
    }
    
        return cell;
    }
    else
    {
        ActivityDetailCommentTableViewCell* cell = (ActivityDetailCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    //Check if we found a cell
    if (cell == nil) 
    {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityDetailCommentTableViewCell" owner:self options:nil];
            cell = (ActivityDetailCommentTableViewCell *)[nib objectAtIndex:0];
            
            //Create a cell, need to do some configurations
            [cell configureCell];
    }
    
	return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
}

@end
