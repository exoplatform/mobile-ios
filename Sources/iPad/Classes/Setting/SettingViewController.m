//
//  SettingViewController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 5/31/10.
//  Copyright 2010 home. All rights reserved.
//

#import "SettingViewController.h"
#import "eXoMobileViewController.h"
#import "defines.h"
#import "Connection.h"
#import "LoginViewController.h"

@implementation SettingViewController

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		// Custom initialization
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	[super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
}

- (void)localize
{
	_dictLocalize = [_delegate getLocalization];
	_intSelectedLanguage = [_delegate getSelectedLanguage];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString* tmpStr = @"";
	return tmpStr;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    int numOfRows = 2;	
	return numOfRows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	
	if(indexPath.row == _intSelectedLanguage)
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	if(indexPath.row == 0)
	{
		UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(17.0, 14.0, 27, 17)];
		imgV.image = [UIImage imageNamed:@"EN.gif"];
		[cell addSubview:imgV];
		
		UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 13.0, 250.0, 20.0)];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
		titleLabel.text = [_dictLocalize objectForKey:@"English"];
		[cell addSubview:titleLabel];
		
	}
	else if(indexPath.row == 1)
	{
		UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(17.0, 14.0, 27, 17)];
		imgV.image = [UIImage imageNamed:@"FR.gif"];
		[cell addSubview:imgV];				
		
		UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 13.0, 250.0, 20.0)];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
		titleLabel.text = [_dictLocalize objectForKey:@"French"];
		[cell addSubview:titleLabel];		
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[_delegate setSelectedLanguage:indexPath.row];
	[_tblLanguage reloadData];
}

@end

