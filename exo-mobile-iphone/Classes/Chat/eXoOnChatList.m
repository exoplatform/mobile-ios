//
//  eXoOnChatList.m
//  eXoApp
//
//  Created by exo on 1/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "eXoOnChatList.h"

@implementation chatItem

@synthesize userName, numOfMsg;

@end

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

static NSString *kCellIdentifier = @"MyIdentifier";

@implementation eXoOnChatList

@synthesize onChatList, tblView, btnDisplayOnChatList, isDisplayOnChatList;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.view.frame = CGRectMake(0, 50, 120, 100);
		
		tblView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 100, 80)];
		tblView.dataSource = self;
		tblView.delegate = self;
		[self.view addSubview:tblView];
		
		btnDisplayOnChatList = [[UIButton alloc] initWithFrame:CGRectMake(110, 10, 10, 40)];
		btnDisplayOnChatList.titleLabel.text = @">";
		[btnDisplayOnChatList addTarget:self action:@selector(displayOnChatList) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btnDisplayOnChatList];
		
    }
    return self;
}

-(void)displayOnChatList
{
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50.0;
}


// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [onChatList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
		cell.textLabel.font = [UIFont systemFontOfSize:18.0];
		cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
	}
	
	chatItem *item = (chatItem *)[onChatList objectAtIndex:indexPath.row];
	
	cell.textLabel.text = item.userName;
	
	UILabel* lbNumofMsg = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 10.0, 210.0, 20.0)];
	lbNumofMsg.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
	lbNumofMsg.text = [NSString stringWithFormat:@"%d", item.numOfMsg];
	[cell addSubview:lbNumofMsg];
	
	UIImage* img = [UIImage imageNamed:@"ChatIcon1.png"];
	cell.imageView.image = img;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	chatItem *item = (chatItem *)[onChatList objectAtIndex:indexPath.row];
	NSLog(item.userName);
}


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


- (void)dealloc {
    [super dealloc];
}


@end
