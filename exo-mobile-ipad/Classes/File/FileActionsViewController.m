//
//  FileActionsViewController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/25/10.
//  Copyright 2010 home. All rights reserved.
//

#import "FileActionsViewController.h"
#import "FilesViewController.h"


@implementation FileActionsViewController

@synthesize _tblvActions;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		// Custom initialization
		_bDelete = NO;
		_bNewFolder = NO;
		_bRename = NO;
		_bCopy = NO;
		_bMove = NO;
		_bPaste = NO;
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

- (void)enableDeleteAction:(BOOL)bDelete
{
	_bDelete = bDelete;
}

- (void)enableNewFolderAction:(BOOL)bNewFolder
{
	_bNewFolder = bNewFolder;
}

- (void)enableRenameAction:(BOOL)bRename
{
	_bRename = bRename;
}

- (void)enableCopyAction:(BOOL)bCopy
{
	_bCopy = bCopy;
}

- (void)enableMoveAction:(BOOL)bMove
{
	_bMove = bMove;
}

- (void)enablePasteAction:(BOOL)bEnable
{
	_bPaste = bEnable;
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
    int numOfRows = 6;	
	return numOfRows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(17.0, 5.0, 35.0, 34.0)];
	UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 13.0, 150.0, 20.0)];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];

	BOOL bOption = NO;
	
	if(indexPath.row == 0)
	{
		imgV.image = [UIImage imageNamed:@"delete.png"];
		titleLabel.text = [_dictLocalize objectForKey:@"DeleteButton"];
		bOption = _bDelete;
	}
	else if(indexPath.row == 1)
	{
		imgV.image = [UIImage imageNamed:@"addfolder.png"];
		titleLabel.text = [_dictLocalize objectForKey:@"NewFolderTitle"];
		bOption = _bNewFolder;
	}
	else if(indexPath.row == 2)
	{
		imgV.image = [UIImage imageNamed:@"rename.png"];
		titleLabel.text = [_dictLocalize objectForKey:@"RenameTitle"];
		bOption = _bRename;
	}
	else if(indexPath.row == 3)
	{
		imgV.image = [UIImage imageNamed:@"copy.png"];
		titleLabel.text = [_dictLocalize objectForKey:@"CopyTitle"];
		bOption = _bCopy;
	}
	else if(indexPath.row == 4)
	{
		imgV.image = [UIImage imageNamed:@"move.png"];
		titleLabel.text = [_dictLocalize objectForKey:@"MoveTitle"];				
		bOption = _bMove;
	}
	else if(indexPath.row == 5)
	{
		imgV.image = [UIImage imageNamed:@"paste.png"];
		titleLabel.text = [_dictLocalize objectForKey:@"PasteTitle"];				
		bOption = _bPaste;
	}
	
	if (bOption) 
	{
		[titleLabel setEnabled:YES];
	}
	else 
	{
		[titleLabel setEnabled:NO];
	}
	
	[cell addSubview:imgV];
	[cell addSubview:titleLabel];		
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
 	if(indexPath.row == 0)
	{
		if(_bDelete)
		{
			NSThread* startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInProgress) object:nil];
			[startThread start];
			
			[_delegate onAction:@"DELETE"];
			
			[startThread release];
			[self performSelectorOnMainThread:@selector(endProgress) withObject:nil waitUntilDone:NO];
		}	
	}	
	else if(indexPath.row == 1)
	{
		if(_bNewFolder)
		{
			[_delegate onAction:@"NEWFOLDER"];
		}	
	}	
	else if(indexPath.row == 2)
	{
		if(_bRename)
		{
			[_delegate onAction:@"RENAME"];
		}	
	}	
	else if(indexPath.row == 3)
	{
		if(_bCopy)
		{
			_delegate._fileForCopyMove = [_delegate._fileForDeleteRename retain];
			[_delegate onAction:@"COPY"];
		}	
	}	
	else if(indexPath.row == 4)
	{
		if(_bMove)
		{
			_delegate._fileForCopyMove = [_delegate._fileForDeleteRename retain];
			[_delegate onAction:@"MOVE"];
		}	
	}	
	else if(indexPath.row == 5)
	{
		if(_bPaste)
		{
			NSThread* startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInProgress) object:nil];
			[startThread start];
			
			[_delegate onAction:@"PASTE"];
			
			[startThread release];
			[self performSelectorOnMainThread:@selector(endProgress) withObject:nil waitUntilDone:NO];
		}	
	}	
	
}

-(void)startInProgress 
{	
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	UIBarButtonItem* progressBtn = [[UIBarButtonItem alloc] initWithCustomView:_delegate._actiLoading];
	[_delegate._navigationBar setLeftBarButtonItem:progressBtn];
	[pool release];	
}

-(void)endProgress
{	
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *tmpStr = _delegate._currenteXoFile._fileName;
	if([tmpStr isEqualToString:@"Private"])
	{
		[_delegate._navigationBar setTitle:@"Files Application"];
		[_delegate._navigationBar setLeftBarButtonItem:nil];
		//[_navigationBar setRightBarButtonItem:_bbtnActions];
	}
	else
	{
		[_delegate._navigationBar setTitle:tmpStr];
		[_delegate._navigationBar setLeftBarButtonItem:_delegate._bbtnBack];
	}	
	[pool release];
	
}


@end
