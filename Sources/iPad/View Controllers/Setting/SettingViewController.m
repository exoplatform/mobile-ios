//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import "SettingViewController.h"
#import "eXoMobileViewController.h"
#import "defines.h"
#import "Connection.h"
#import "LoginViewController.h"

static NSString* kCellIdentifier = @"MyIdentifier";
#define kTagForCellSubviewTitleLabel 222
#define kTagForCellSubviewImageView 333

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
    
    _delegate = nil;
    
    [_tblLanguage release];
    _tblLanguage = nil;
    
    [_dictLocalize release];
    _dictLocalize = nil;
    
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
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 13.0, 250.0, 20.0)];
        titleLabel.tag = kTagForCellSubviewTitleLabel;
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
		[cell addSubview:titleLabel];	
        [titleLabel release];
        
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(17.0, 14.0, 27, 17)];
        imgView.tag = kTagForCellSubviewImageView;
		imgView.image = [UIImage imageNamed:@"FR.gif"];
		[cell addSubview:imgView];	
        [imgView release];
    }
	
	if(indexPath.row == _intSelectedLanguage)
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
    UILabel* titleLabel = (UILabel*)[cell viewWithTag:kTagForCellSubviewTitleLabel];
    UIImageView* imgView = (UIImageView*)[cell viewWithTag:kTagForCellSubviewImageView];
    
	if(indexPath.row == 0)
	{
		imgView.image = [UIImage imageNamed:@"EN.gif"];
		titleLabel.text = [_dictLocalize objectForKey:@"English"];
	}
	else if(indexPath.row == 1)
	{
		imgView.image = [UIImage imageNamed:@"FR.gif"];
		titleLabel.text = [_dictLocalize objectForKey:@"French"];
	}

	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[_delegate setSelectedLanguage:indexPath.row];
	[_tblLanguage reloadData];
}

@end

