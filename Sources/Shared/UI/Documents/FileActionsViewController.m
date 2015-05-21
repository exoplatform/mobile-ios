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

#import "FileActionsViewController.h"
#import "FileActionsBackgroundView.h"
#import "File.h"

#import "LanguageHelper.h"



static NSString *kCellIdentifier = @"MyIdentifier";
static File *copyMoveFile;
static short fileActionMode = 0;//1:copy, 2:move



@implementation FileActionsViewController

@synthesize tblFileAction = _tblFileAction;
@synthesize fileToApplyAction = _file;
@synthesize fileActionsDelegate;


//Constructor
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                 file:(File *)fileForActions 
                enableDeleteThisFolder:(BOOL)enableDeleteFolder
                enableCreateFolder:(BOOL)enableCreateFolder
                enableRenameFile:(BOOL)enableRenameFile
             delegate:(id<FileActionsProtocol>)actionsDelegate
{
    
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
        
        self.preferredContentSize = kPreferredContentSize;
        fileActionsDelegate = actionsDelegate;
        
		_file = [fileForActions retain];
		_deleteFolderEnable = enableDeleteFolder;
        _createFolderEnable = enableCreateFolder;
        _renameFileEnable = enableRenameFile;
        
        _strTakePicture = [Localize(@"AddAPhoto") copy];
		_strDelete = [Localize(@"Delete") copy];
		_strCopy = [Localize(@"Copy") copy];
		_strMove = [Localize(@"Move") copy];
		_strPaste = [Localize(@"Paste") copy];
		_strCancel = [Localize(@"Cancel") copy];
        _strNewFolder = [Localize(@"NewFolderTitle") copy];
        _strRenameFolder = [Localize(@"RenameTitle") copy];
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setFileToApplyAction:(File *)fileToApplyAction {
    
    [_file release];
    _file = [fileToApplyAction retain];
    [self.tblFileAction reloadData];
    
}


- (void)dealloc
{
    
    [_file release];	//file, folder info
    _file = nil;
    
    [_tblFileAction release]; 
	_tblFileAction = nil;
    
    fileActionsDelegate = nil;
    
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
    
    
	_tblFileAction.scrollEnabled = YES;
	_tblFileAction.backgroundColor = [UIColor clearColor];
	self.view.backgroundColor = [UIColor clearColor];
    
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



#pragma mark - Table View Delegate Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section == 0)
		return 7;
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    long section = indexPath.section;
	long row = indexPath.row;
    
	if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier]autorelease];
        if(section == 0) {
            [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            
        }else {
            UIButton* tmpButton = [[UIButton alloc] initWithFrame:[cell frame]];
            [tmpButton setBackgroundImage:[UIImage imageNamed:@"cancelitem"] forState:UIControlStateNormal];
            [tmpButton setTitle:_strCancel forState:UIControlStateNormal];
            [cell setBackgroundView:tmpButton];
            [tmpButton release];
        }
    }
    
    UILabel *titleLabel = cell.textLabel;
    UIImageView *imgViewFileAction = cell.imageView;
    
	if(section == 0)
	{
		if(row == 0)
		{
			imgViewFileAction.image = [UIImage imageNamed:@"DocumentActionPopupPhotoIcon"];
			titleLabel.text = _strTakePicture;
            // Check to support Add Photo action for "canAddChild" folder
			if(!_file.isFolder || !_file.canAddChild)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
		}
		else if(row == 1)
		{
            imgViewFileAction.image = [UIImage imageNamed:@"DocumentActionPopupCopyIcon"];
			titleLabel.text = _strCopy;
            // Check to support Copy action for folder
			if(_file.isFolder)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
			
		}
		else if(row == 2)
		{
			imgViewFileAction.image = [UIImage imageNamed:@"DocumentActionPopupCutIcon"];
			titleLabel.text = _strMove;
            // Check to support Cut action for "canRemove" folder
			if(_file.isFolder || !_file.canRemove)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
		}
		else if(row == 3)
		{
			imgViewFileAction.image = [UIImage imageNamed:@"DocumentActionPopupPasteIcon"];
			titleLabel.text = _strPaste;
            // Check to support Past action for "canAddChild" folder
			if(fileActionMode <= 0 || !_file.isFolder || !_file.canAddChild)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
		}
		else if(row == 4)
		{
			imgViewFileAction.image = [UIImage imageNamed:@"DocumentActionPopupDeleteIcon"];
			titleLabel.text = _strDelete;
            // Check to support Delete action for "canRemove" folder/file
			if(!_deleteFolderEnable || !_file.canRemove)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
		}
        else if(row == 5)
        {
            imgViewFileAction.image = [UIImage imageNamed:@"DocumentActionPopupAddFolderIcon"];
            titleLabel.text = _strNewFolder;
            // Check to support AddFolder action for "canAddChild" folder
			if(!_file.isFolder || !_file.canAddChild)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
        }
        else 
        {
            imgViewFileAction.image = [UIImage imageNamed:@"DocumentActionPopupRenameIcon"];
            titleLabel.text = _strRenameFolder;
            // Check to support Rename action for folder
			if(!_file.isFolder || !_renameFileEnable)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
        }
	}
    
    UIView *view = [[UIView alloc] initWithFrame:cell.frame];
    view.backgroundColor = [UIColor lightGrayColor];
	cell.selectedBackgroundView = view;
    [view release];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	long section = indexPath.section;
	long row = indexPath.row;
	
	if(section == 0)
	{
        if(row == 0)
        {
            [fileActionsDelegate askToAddPhoto:_file.path];
        }
		else if(row == 1)
		{
            fileActionMode = 1;
            [copyMoveFile release];
			copyMoveFile = [_file retain];
            [fileActionsDelegate moveOrCopyActionIsSelected];
		}
		else if(row == 2)
		{
			fileActionMode = 2;
            [copyMoveFile release];
			copyMoveFile = [_file retain];
            [fileActionsDelegate moveOrCopyActionIsSelected];
		}
		else if(row == 3)
		{
            if(fileActionMode == 1)
			{
                
                [fileActionsDelegate copyFileSource:copyMoveFile.path
                                      toDestination:[NSString stringWithFormat:@"%@/%@", _file.path, [copyMoveFile.path lastPathComponent]]];
			}
			else
			{	
                [fileActionsDelegate moveFileSource:copyMoveFile.path
                                      toDestination:[NSString stringWithFormat:@"%@/%@", _file.path, [copyMoveFile.path lastPathComponent]]];
				
			}
            [copyMoveFile release];
            copyMoveFile = nil;
            fileActionMode = 0;
			
		}
		else if (row == 4)
		{            
			[fileActionsDelegate deleteFile:_file.path];

		}
        else if (row == 5)
        {
            //Create a new folder
            [fileActionsDelegate askToMakeFolderActions:YES];
        }
        else if (row == 6)
        {
            [fileActionsDelegate askToMakeFolderActions:NO];
        }
	}
}



@end
