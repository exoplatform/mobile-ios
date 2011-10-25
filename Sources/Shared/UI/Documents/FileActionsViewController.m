//
//  FileActionsViewController_iPhone.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 24/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileActionsViewController.h"
#import "FileActionsBackgroundView.h"
#import "File.h"

#import "LanguageHelper.h"



static NSString *kCellIdentifier = @"MyIdentifier";
#define kTagForCellSubviewTitleLabel 222
#define kTagForCellSubviewImageView 333

static File *copyMoveFile;
static short fileActionMode = 0;//1:copy, 2:move



@implementation FileActionsViewController

@synthesize tblFileAction = _tblFileAction;
@synthesize fileToApplyAction = _file;
@synthesize fileActionsDelegate;


//Constructor
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                 file:(File *)fileForActions 
enableDeleteThisFolder:(BOOL)enable 
             delegate:(id<FileActionsProtocol>)actionsDelegate
{
    
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
        self.contentSizeForViewInPopover = CGSizeMake(200, 280);
        self.view.frame = CGRectMake(0, 0, 200, 280);
		
        fileActionsDelegate = actionsDelegate;
        
		_file = [fileForActions retain];
		_deleteFolderEnable = enable;
        
        _strTakePicture = [Localize(@"TakePicture") copy];
        _stringPhotoAlbumm = [Localize(@"PhotoLibrary") copy];
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
		return 8;
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    int section = indexPath.section;
	int row = indexPath.row;
    
	if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier]autorelease];
        
        if(section == 0) {
            UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 10.0, 150.0, 20.0)];
            titleLabel.tag = kTagForCellSubviewTitleLabel;
            titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            titleLabel.backgroundColor = [UIColor clearColor];
            [cell addSubview:titleLabel];
            [titleLabel release];
            
            UIImageView* imgViewFileAction = [[UIImageView alloc] initWithFrame:CGRectMake(18.0, 8.0, 25, 25)];
            imgViewFileAction.tag = kTagForCellSubviewImageView;
            [cell addSubview:imgViewFileAction];
            [imgViewFileAction release];
        }else {
            
            UIButton* tmpButton = [[UIButton alloc] initWithFrame:[cell frame]];
            [tmpButton setBackgroundImage:[UIImage imageNamed:@"cancelitem"] forState:UIControlStateNormal];
            [tmpButton setTitle:_strCancel forState:UIControlStateNormal];
            [cell setBackgroundView:tmpButton];
            [tmpButton release];
        }
    }
    
	UILabel *titleLabel = (UILabel *)[cell viewWithTag:kTagForCellSubviewTitleLabel];
	UIImageView *imgViewFileAction = (UIImageView* )[cell viewWithTag:kTagForCellSubviewImageView];
    
	if(section == 0)
	{
		if(row == 0)
		{
			imgViewFileAction.image = [UIImage imageNamed:@"DocumentActionPopupPhotoIcon"];
			titleLabel.text = _strTakePicture;
			if(!_file.isFolder)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
		}
        else if(row == 1)
		{
			imgViewFileAction.image = [UIImage imageNamed:@"DocumentActionPopupPhotoIcon"];
			titleLabel.text = _stringPhotoAlbumm;
			if(!_deleteFolderEnable)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
		}
		else if(row == 2)
		{
            imgViewFileAction.image = [UIImage imageNamed:@"DocumentActionPopupCopyIcon"];
			titleLabel.text = _strCopy;
			if(_file.isFolder)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
			
		}
		else if(row == 3)
		{
			imgViewFileAction.image = [UIImage imageNamed:@"DocumentActionPopupCutIcon"];
			titleLabel.text = _strMove;
			if(_file.isFolder)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
		}
		else if(row == 4)
		{
			imgViewFileAction.image = [UIImage imageNamed:@"DocumentActionPopupPasteIcon"];
			titleLabel.text = _strPaste;
			if(fileActionMode <= 0 || !_file.isFolder)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
		}
		else if (row ==5)
		{
			imgViewFileAction.image = [UIImage imageNamed:@"DocumentActionPopupDeleteIcon"];
			titleLabel.text = _strDelete;
			if(!_deleteFolderEnable)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
		}
        else if (row == 6)
        {
            imgViewFileAction.image = [UIImage imageNamed:@"DocumentActionPopupAddFolderIcon"];
            titleLabel.text = _strNewFolder;
			if(!_file.isFolder)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
        }
        else 
        {
            imgViewFileAction.image = [UIImage imageNamed:@"DocumentActionPopupRenameIcon"];
            titleLabel.text = _strRenameFolder;
			if(!_file.isFolder)
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
	int section = indexPath.section;
	int row = indexPath.row;
	
	if(section == 0)
	{
        if(row == 0)
		{
			[fileActionsDelegate askToAddAPicture:_file.urlStr photoAlbum:NO];
		}
        else if(row == 1)
		{
            [fileActionsDelegate askToAddAPicture:_file.urlStr photoAlbum:YES];
		}
		else if(row == 2)
		{
            fileActionMode = 1;
			copyMoveFile = _file;
            [fileActionsDelegate moveOrCopyActionIsSelected];
		}
		else if(row == 3)
		{
			fileActionMode = 2;
			copyMoveFile = _file;
            [fileActionsDelegate moveOrCopyActionIsSelected];
		}
		else if(row == 4)
		{
            if(fileActionMode == 1)
			{
                
                [fileActionsDelegate copyFileSource:copyMoveFile.urlStr
                                      toDestination:[_file.urlStr stringByAppendingPathComponent:[copyMoveFile.urlStr lastPathComponent]]];
			}
			else
			{	
                [fileActionsDelegate moveFileSource:copyMoveFile.urlStr
                                      toDestination:[_file.urlStr stringByAppendingPathComponent:[copyMoveFile.urlStr lastPathComponent]]];
				fileActionMode = 0;
			}
			
		}
		else if (row == 5)
		{
			[fileActionsDelegate deleteFile:_file.urlStr];
		}
        else if (row == 6)
        {
            //Create a new folder
            [fileActionsDelegate askToMakeFolderActions:YES];
        }
        else if (row == 7)
        {
            [fileActionsDelegate askToMakeFolderActions:NO];
        }
	}
}



@end
