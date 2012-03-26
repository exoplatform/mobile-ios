//
//  eXoFileCopyMove.m
//  eXoApp
//
//  Created by exo on 11/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "eXoFileCopyMove.h"
#import "eXoApplicationsViewController.h"
#import "eXoFilesView.h"
#import "eXoAccount.h"

@implementation eXoFileCopyMove

@synthesize copyFile, _fileView, sourceURL, destinationURL;

- (id)initWithStyle:(UITableViewStyle)style delegate:(eXoApplicationsViewController *)delegate {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		
		sourceURL = [[NSString alloc] initWithString:@""];
		destinationURL = [[NSString alloc] initWithString:@""];
		
		_delegate = [[eXoApplicationsViewController alloc] initWithNibName:@"eXoApplicationsViewController" bundle:nil];
		_delegate._copyMoveFile = YES;
		
		_btnClose = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self
																  action:@selector(closeCopyMove)];
		
		_btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self
																 action:@selector(doneCopyMove)];
		_delegate._dictLocalize = delegate._dictLocalize;
		_dictLocalize = delegate._dictLocalize;
		_delegate._currentDirectory = delegate._currentDirectory;
		
    }
    return self;
}

-(void)closeCopyMove
{
	[self dismissModalViewControllerAnimated:YES];
}

-(void)doneCopyMove
{
	if(copyFile)
		[_delegate fileAction:@"COPY" source:destinationURL destination:sourceURL data:nil];
	else
		[_delegate fileAction:@"MOVE" source:sourceURL destination:destinationURL data:nil];
	
	[self dismissModalViewControllerAnimated:YES];
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[_btnDone setTitle:[_dictLocalize objectForKey:@"DoneButton"]];
	[_btnClose setTitle:[_dictLocalize objectForKey:@"CancelCopyButton"]];
	
	if(copyFile)
	{
		self.title = [_dictLocalize objectForKey:@"CopyTitle"];
	}	
	else
	{	
		self.title = [_dictLocalize objectForKey:@"MoveTitle"];
	}
	self.navigationItem.leftBarButtonItem = _btnClose;
	self.navigationItem.rightBarButtonItem = _btnDone;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	self.navigationItem.leftBarButtonItem = _btnClose;
	self.navigationItem.rightBarButtonItem = _btnDone;
	if(_delegate._currentDirectory == nil || [_delegate._currentDirectory length] == 0)
	{
		sourceURL = @"";
		destinationURL = @"";
	}
	if(_delegate._sourceDesURL == 1)
	{
		sourceURL = _delegate._currentDirectory;
		
	}else if(_delegate._sourceDesURL == 3) {
		
		NSMutableString *tmpDes = [[NSMutableString alloc] initWithString:_delegate._currentDirectory];
		if(![_delegate isFolder:tmpDes]){
			tmpDes = [NSMutableString stringWithString:[_delegate._currentDirectory stringByDeletingLastPathComponent]];
			if([tmpDes length] > 0)
			{
				[tmpDes insertString:@"/" atIndex:6];
				[tmpDes appendFormat:@"/%@", [sourceURL lastPathComponent]];
			}
			
		}else
			if(!([tmpDes characterAtIndex:[tmpDes length] - 1] == '/'))
				[tmpDes appendFormat:@"/%@", [sourceURL lastPathComponent]];
		
		destinationURL = [tmpDes retain];
	}
	
	
	if([sourceURL isEqualToString:@""] || [destinationURL isEqualToString:@""])
		self.navigationItem.rightBarButtonItem.enabled = FALSE;
	else
		self.navigationItem.rightBarButtonItem.enabled = TRUE;
	
	
	[self.tableView reloadData];
}


//- (void)setDictLocalize:(NSDictionary*)dict
//{
//	_dictLocalize = dict;
//	[_btnDone setTitle:[_dictLocalize objectForKey:@"DoneButton"]];
//	[_btnClose setTitle:[_dictLocalize objectForKey:@"CancelCopyButton"]];
//	
//	if(copyFile)
//	{
//		self.title = [_dictLocalize objectForKey:@"CopyTitle"];
//	}	
//	else
//	{	
//		self.title = [_dictLocalize objectForKey:@"MoveTitle"];
//	}
//}

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

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int n = 0;
	switch (indexPath.row) 
	{		
		case 0:
			n = 35;
			break;
		case 1:
			n = 110;
			break;
		case 2:
			n = 35;
			break;
		case 3:
			n = 110;
			break;	
		default:
			break;	
	}		
	return n;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
	UILabel* label;
	
	switch (indexPath.row) 
	{		
		case 0:
			cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
			cell.textLabel.numberOfLines = 2;
			cell.textLabel.text = [_dictLocalize objectForKey:@"SourceDescription"];
			break;
		case 1:
			label = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 5.0, 280, 100.0)];
			label.font = [UIFont fontWithName:@"Helvetica" size:14.0];
			label.numberOfLines = 5;
			label.lineBreakMode = UILineBreakModeHeadTruncation;
			if([sourceURL length] > 0)
			{	
				label.textAlignment = UITextAlignmentLeft;
				label.text = sourceURL;
			}
			else
			{
				label.textAlignment = UITextAlignmentCenter;				
				label.text = [_dictLocalize objectForKey:@"TouchHere"];				
			}
			[cell addSubview:label];
			break;
		case 2:
			cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
			cell.textLabel.numberOfLines = 2;
			cell.textLabel.text = [_dictLocalize objectForKey:@"DestinationDescription"];
			break;
		case 3:
			label = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 5.0, 280.0, 100.0)];
			label.font = [UIFont fontWithName:@"Helvetica" size:14.0];
			label.numberOfLines = 5;
			label.textAlignment = UITextAlignmentRight;
			label.lineBreakMode = UILineBreakModeHeadTruncation;			
			if([destinationURL length] > 0)
			{	
				label.textAlignment = UITextAlignmentLeft;
				label.text = destinationURL;				
			}
			else
			{
				label.textAlignment = UITextAlignmentCenter;
				label.text = [_dictLocalize objectForKey:@"TouchHere"];
			}
			[cell addSubview:label];			
			break;
			
		default:
			break;
	}
	
//	cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
//	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(117.0, 5.0, 180.0, 100.0)];
//	label.font = [UIFont fontWithName:@"Helvetica" size:14.0];
//	label.numberOfLines = 5;
//	label.textAlignment = UITextAlignmentRight;
//	label.lineBreakMode = UILineBreakModeHeadTruncation;
//	
//    // Set up the cell...
//	if(indexPath.row == 0)
//	{
//		
//		cell.textLabel.text = @"Source:";
//		label.text = sourceURL;
//		
//		[cell addSubview:label];
//	}
//	else
//	{
//		cell.textLabel.text = @"Destination:";
//		label.text = destinationURL;
//		
//		[cell addSubview:label];
//		
//	}

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if((indexPath.row == 1) || (indexPath.row == 3)) 
	{	
		NSThread *startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInProgress) object:nil];
		[startThread start];
		
		_delegate._sourceDesURL = indexPath.row;
		if(![_delegate isFolder:_delegate._currentDirectory])
		{
			NSMutableString *tmpUrl = [NSMutableString stringWithString:[_delegate._currentDirectory stringByDeletingLastPathComponent]];
			if([tmpUrl length] > 0)
			{
				[tmpUrl insertString:@"/" atIndex:6];
				_delegate._currentDirectory = tmpUrl;
			}
		}
		
		[_delegate createFileView];
		[self.navigationController pushViewController:_delegate animated:YES];
		
		
		[startThread release];
		[self performSelectorOnMainThread:@selector(endProgress) withObject:nil waitUntilDone:NO];
		
	}	
}

-(void)startInProgress {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	UIBarButtonItem* progressBtn = [[UIBarButtonItem alloc] initWithCustomView:_delegate._indicator];
	[[self navigationItem] setLeftBarButtonItem:progressBtn];
	self.navigationItem.rightBarButtonItem = nil;
	
	[pool release];
	
}

-(void)endProgress
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *tmpStr = [_delegate._currentDirectory lastPathComponent];
	if([tmpStr isEqualToString:@"Private"])
	{
		[_delegate addCloseBtn];
	}else
	{
		//[_delegate._btnBack setTitle:[_dictLocalize objectForKey:@"BackButton"]];
		_delegate.navigationItem.leftBarButtonItem = _delegate._btnBack;
	}
	
	if(_delegate._copyMoveFile)
	{
		if(_delegate._sourceDesURL == 1)
			_delegate.navigationItem.rightBarButtonItem = nil;
		else if(_delegate._sourceDesURL == 3)
			_delegate.navigationItem.rightBarButtonItem = _delegate._btnSelectCopy;
	}else
		_delegate.navigationItem.rightBarButtonItem = _delegate._btnFileAction;
	
	[pool release];
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


- (void)dealloc {
    [super dealloc];
}


@end

