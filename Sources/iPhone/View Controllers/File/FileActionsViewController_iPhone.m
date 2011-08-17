//
//  FileActionsViewController_iPhone.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 24/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileActionsViewController_iPhone.h"
#import "FileActionsBackgroundView.h"
#import "File.h"

#import "AppDelegate_iPhone.h"



static NSString *kCellIdentifier = @"MyIdentifier";
#define kTagForCellSubviewTitleLabel 222
#define kTagForCellSubviewImageView 333

static File *copyMoveFile;
static short fileActionMode = 0;//1:copy, 2:move



@implementation FileActionsViewController_iPhone

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
        
        self.view.frame = CGRectMake(50, 60, 230, 270);
		
        fileActionsDelegate = actionsDelegate;
        
		_file = [fileForActions retain];
		_deleteFolderEnable = enable;
        
        _strTakePicture = [NSString stringWithString:[[AppDelegate_iPhone instance].dictLocalize objectForKey:@"TakePicture"]];
		_strDelete = [NSString stringWithString:[[AppDelegate_iPhone instance].dictLocalize objectForKey:@"Delete"]];
		_strCopy = [NSString stringWithString:[[AppDelegate_iPhone instance].dictLocalize objectForKey:@"Copy"]];
		_strMove = [NSString stringWithString:[[AppDelegate_iPhone instance].dictLocalize objectForKey:@"Move"]];
		_strPaste = [NSString stringWithString:[[AppDelegate_iPhone instance].dictLocalize objectForKey:@"Paste"]];
		_strCancel = [NSString stringWithString:[[AppDelegate_iPhone instance].dictLocalize objectForKey:@"Cancel"]]; 
        
        
        FileActionsBackgroundView *bgView = [[FileActionsBackgroundView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        self.view.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:bgView];
        [self.view sendSubviewToBack:bgView];
        
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
    
    
	_tblFileAction.scrollEnabled = NO;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(section == 0)
	{
		NSString *strFileFolderName = _file.fileName;
		strFileFolderName = [strFileFolderName stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
		if([strFileFolderName length] >= 15)
		{	
			strFileFolderName = [strFileFolderName substringToIndex:15];
			strFileFolderName = [strFileFolderName stringByAppendingString:@"..."];
		}
		return strFileFolderName;
	}
    
	
	return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section == 0)
		return 5;
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    int section = indexPath.section;
	int row = indexPath.row;
    
	if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
        
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
            [tmpButton setBackgroundImage:[UIImage imageNamed:@"cancelitem.png"] forState:UIControlStateNormal];
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
			imgViewFileAction.image = [UIImage imageNamed:@"TakePhoto.png"];
			titleLabel.text = _strTakePicture;
			if(!_file.isFolder)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
		}
		else if(row == 1)
		{
			imgViewFileAction.image = [UIImage imageNamed:@"delete.png"];
			titleLabel.text = _strDelete;
			if(!_deleteFolderEnable)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
		}
		else if(row == 2)
		{
			imgViewFileAction.image = [UIImage imageNamed:@"copy.png"];
			titleLabel.text = _strCopy;
			if(_file.isFolder)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
		}
		else if(row == 3)
		{
			imgViewFileAction.image = [UIImage imageNamed:@"move.png"];
			titleLabel.text = _strMove;
			if(_file.isFolder)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
		}
		else
		{
			imgViewFileAction.image = [UIImage imageNamed:@"paste.png"];
			titleLabel.text = _strPaste;
			if(fileActionMode <= 0 || !_file.isFolder)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
		}
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	int section = indexPath.section;
	int row = indexPath.row;
	
	if(section == 0)
	{
		//NSThread *startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInProgress) object:nil];
		//[startThread start];
		
		if(row == 0)
		{
			[fileActionsDelegate askToAddAPicture:_file.urlStr];
		}
		else if(row == 1)
		{
            [fileActionsDelegate deleteFile:_file.urlStr];
			//[_delegate fileAction:@"DELETE" source:_file._urlStr destination:nil data:nil];
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
		else
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
	}
}



@end
