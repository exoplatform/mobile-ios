//
//  AppContainerViewController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/9/10.
//  Copyright 2010 home. All rights reserved.
//

#import "AppContainerViewController.h"
#import "MainViewController.h"
#import "GadgetViewController.h"
#import "defines.h"
#import "Gadget.h"
#import "Connection.h"
#import "MessengerViewController.h"
#import "XMPPClient.h"

static NSString* kCellIdentifier = @"Cell";

@implementation AppContainerViewController

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		// Custom initialization
		_gadgetViewController = [[GadgetViewController alloc] initWithNibName:@"GadgetViewController" bundle:nil];
		[_gadgetViewController setDelegate:self];
		
		_arrGateInDbItems = [[NSMutableArray alloc] init];
		_arrGadgets = [[NSMutableArray alloc] init];
		_bGrid = NO;
		_bExistGadget = NO;
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
	[_btnGrid setBackgroundImage:[UIImage imageNamed:@"GridView.png"] forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animate
{
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

- (UITableView*)getTableViewAppList
{
	return _tblAppList;
}

- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
}

- (Connection*)getConnection
{
	_connection = [_delegate getConnection];
	return _connection;
}

- (void)localize
{
	_dictLocalize = [_delegate getLocalization];	 
	[_gadgetViewController localize];
	[_tblAppList reloadData];
}

- (void)setSelectedLanguage:(int)languageId
{
	[_delegate setSelectedLanguage:languageId];
}

- (int)getSelectedLanguage
{
	return _intSelectedLanguage;
}

- (NSDictionary*)getLocalization
{
	return _dictLocalize;
}

- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
	{
	}
	
	if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{	
	}
}

- (void)loadGadgets
{
	[self getConnection];
	_arrGateInDbItems = [_connection getItemsInDashboard];
	
	if([_arrGateInDbItems count] == 0)
	{	
		_bExistGadget = NO;
	}
	else
	{	
		_bExistGadget = YES;
		[_tblAppList addSubview:_btnGrid];
		for(int i = 0; i < [_arrGateInDbItems count]; i++)
		{
			if([[[_arrGateInDbItems objectAtIndex:i] _arrGadgetsInItem] count] == 0)
			{
				[_arrGateInDbItems removeObjectAtIndex:i];
				i = 0;
			}
		}
	}
	
	for (int i = 0; i < [_arrGateInDbItems count]; i++) 
	{
		GateInDbItem* tmpGateInDbItem = [_arrGateInDbItems objectAtIndex:i];
		if ([tmpGateInDbItem._arrGadgetsInItem count] > 0) 
		{
			break;
		}
	}
	if (_bExistGadget) 
	{
		[_btnGrid setHidden:NO];
		[_btnGrid setFrame:CGRectMake(280, 165, 30, 30)];
	}
	else 
	{
		[_btnGrid setHidden:YES];
	}
	
	[_tblAppList reloadData];
}


- (IBAction)onGridBtn:(id)sender
{
	_bGrid = !_bGrid;
	
	if(_bGrid)
	{  
		[_btnGrid setBackgroundImage:[UIImage imageNamed:@"ListView.png"] forState:UIControlStateNormal];
	}
	else 
	{
		[_btnGrid setBackgroundImage:[UIImage imageNamed:@"GridView.png"] forState:UIControlStateNormal];
	}
	
	[_gadgetViewController onGridBtn];
}
																												
- (void)onGadget:(Gadget*)gadget
{
	[_delegate startGadget:gadget];	
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	int numberOfSections = 0;
	
	if(_bExistGadget)
	{
		numberOfSections = 2;
	}
	else
	{
		numberOfSections = 1;
	}
	return numberOfSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	int height = 0;
	
	switch (indexPath.section) 
	{
		case 0:
		{
			height = 60;
			break;
		}
		case 1:
		{
			height = 455;
			break;
		}
			
		default:
			break;
	}
	return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString* tmpStr = @"";
	switch (section) 
	{
		case 0:
		{
			tmpStr = @"Applications";
			break;
		}
		case 1:
		{
			tmpStr = @"Dashboard";
			break;
		}
			
		default:
			break;
	}
	return tmpStr;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    int numOfRows = 0;
	switch (section) 
	{
		case 0:
		{
			numOfRows = 2;
			break;
		}
		case 1:
		{
			numOfRows = 1;
			break;
		}
			
		default:
			break;
	}
	return numOfRows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
  		
	switch (indexPath.section) 
	{
		case 0:
		{
			UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 20.0, 230.0, 20.0)];
			lbTitle.backgroundColor = [UIColor clearColor];
			lbTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
			[cell addSubview:lbTitle];
			
			/*
			UILabel* lbDescription = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 25.0, 230.0, 33.0)];
			lbDescription.backgroundColor = [UIColor clearColor];
			lbDescription.numberOfLines = 2;
			lbDescription.font = [UIFont fontWithName:@"Helvetica" size:12.0];
			[cell addSubview:lbDescription];
			*/
			
			UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 5.0, 50, 50)];
			[cell addSubview:imgV];
			
			switch (indexPath.row) 
			{
				case 0:
				{
					lbTitle.text = @"Chat";		
					//lbDescription.text = [_dictLocalize objectForKey:@"ChatDescription"];
					XMPPClient *client = [MessengerViewController getXmppClient];
					if(client != nil && [client isAuthenticated])
						imgV.image = [UIImage imageNamed:@"onlineicon.png"];
					else
						imgV.image = [UIImage imageNamed:@"offlineicon.png"];
					
					break;
				}
				
				case 1:
				{
					lbTitle.text = @"Files";
					//lbDescription.text = [_dictLocalize objectForKey:@"FileDescription"];
					imgV.image = [UIImage imageNamed:@"filesApp.png"];
					break;
				}
					
				default:
					break;
			}
			
			break;
		}
		
		case 1:
		{
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			switch (indexPath.row) 
			{
				case 0:
				{					
					[[_gadgetViewController view] setFrame:CGRectMake(15.0, 5.0, 290, 445)];
					[_gadgetViewController loadGateInDbItems:_arrGateInDbItems];
					[cell addSubview:[_gadgetViewController view]];
					UIButton* bg = [[UIButton alloc] initWithFrame:[cell frame]];
					[bg setUserInteractionEnabled:NO];
					[bg setBackgroundImage:[UIImage imageNamed:@"GadgetsContainerBackground.png"] forState:UIControlStateNormal];
					[cell setBackgroundView:bg];
					break;
				}	
				default:
					break;
			}
			
			break;
		}
			
		default:
			break;
	}
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	switch (indexPath.section) 
	{
		case 0:
		{
			switch (indexPath.row) 
			{
				case 0:
				{
					[_delegate startMessengerApplication];
					break;
				}
					
				case 1:
				{
					[_delegate startFilesApplication];
					break;
				}
					
				default:
					break;
			}
			
			break;
		}
		
		default:
			break;
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
