//
//  eXoFileAction.m
//  eXoMobile
//
//  Created by Mai Thanh Xuyen on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "eXoFileAction.h"
#import "eXoFilesView.h"
#import "eXoApplicationsViewController.h"
#import "eXoFileActionView.h"

static NSString *kCellIdentifier = @"MyIdentifier";
static eXoFile_iPhone *copyMoveFile;
static short fileActionMode = 0;//1:copy, 2:move

@implementation eXoFileAction


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(eXoApplicationsViewController *)delegate
									filesView:(eXoFilesView *)filesView file:(eXoFile_iPhone *)file enableDeleteThisFolder:(BOOL)enable {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		
		_delegate = delegate;
		_filesView = filesView;
		_file = file;
		_deleteFolderEnable = enable;
		
		strTakePicture = [NSString stringWithString:[_delegate._dictLocalize objectForKey:@"TakePicture"]];
		strDelete = [NSString stringWithString:[_delegate._dictLocalize objectForKey:@"Delete"]];
		strCopy = [NSString stringWithString:[_delegate._dictLocalize objectForKey:@"Copy"]];
		strMove = [NSString stringWithString:[_delegate._dictLocalize objectForKey:@"Move"]];
		strPaste = [NSString stringWithString:[_delegate._dictLocalize objectForKey:@"Paste"]];
		
		strCancel = [NSString stringWithString:[_delegate._dictLocalize objectForKey:@"Cancel"]];


    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	tblFileAction.scrollEnabled = NO;
	tblFileAction.backgroundColor = [UIColor clearColor];
	self.view.backgroundColor = [UIColor clearColor];

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(section == 0)
	{
		NSString *strFileFolderName = _file._fileName;
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
	
	cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
	
	int section = indexPath.section;
	int row = indexPath.row;
	
	UIImageView* imgViewFileAction = [[UIImageView alloc] initWithFrame:CGRectMake(18.0, 8.0, 25, 25)];	
	
	UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 10.0, 150.0, 20.0)];
	titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
	titleLabel.backgroundColor = [UIColor clearColor];
	
	if(section == 0)
	{
		if(row == 0)
		{
			imgViewFileAction.image = [UIImage imageNamed:@"TakePhoto.png"];
			titleLabel.text = strTakePicture;
			if(!_file._isFolder)
			{
				//cell.backgroundColor = [UIColor grayColor];
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
		}
		else if(row == 1)
		{
			imgViewFileAction.image = [UIImage imageNamed:@"delete.png"];
			titleLabel.text = strDelete;
			if(!_deleteFolderEnable)
			{
				//cell.backgroundColor = [UIColor grayColor];
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
		}
		else if(row == 2)
		{
			imgViewFileAction.image = [UIImage imageNamed:@"copy.png"];
			titleLabel.text = strCopy;
			if(_file._isFolder)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
		}
		else if(row == 3)
		{
			imgViewFileAction.image = [UIImage imageNamed:@"move.png"];
			titleLabel.text = strMove;
			if(_file._isFolder)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
		}
		else
		{
			imgViewFileAction.image = [UIImage imageNamed:@"paste.png"];
			titleLabel.text = strPaste;
			if(fileActionMode <= 0 || !_file._isFolder)
			{
				titleLabel.textColor = [UIColor grayColor];
				cell.userInteractionEnabled = NO;
			}
		}
		//UIButton* tmpButton = [[UIButton alloc] initWithFrame:[cell frame]];
		//[tmpButton setBackgroundImage:[UIImage imageNamed:@"actionitem.png"] forState:UIControlStateNormal];
		//[cell setBackgroundView:tmpButton];	
	}
	else
	{
		titleLabel.frame = CGRectMake(65.0, 10.0, 100.0, 20.0);
		titleLabel.text = strCancel;
		titleLabel.textColor = [UIColor whiteColor];
		titleLabel.textAlignment = UITextAlignmentCenter;
		UIButton* tmpButton = [[UIButton alloc] initWithFrame:[cell frame]];
		[tmpButton setBackgroundImage:[UIImage imageNamed:@"cancelitem.png"] forState:UIControlStateNormal];
		[cell setBackgroundView:tmpButton];
	}
	
	[cell addSubview:imgViewFileAction];	
	[cell addSubview:titleLabel];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	int section = indexPath.section;
	int row = indexPath.row;
	
	if(section == 0)
	{
		NSThread *startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInProgress) object:nil];
		[startThread start];
		
		NSString* currentFileFolderStr = [_file._fatherUrlStr stringByAppendingFormat:@"/%@/", 
										  [_file._fileName stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
		
		if(row == 0)
		{
			[self takePicture];
		}
		else if(row == 1)
		{
			[_delegate fileAction:@"DELETE" source:currentFileFolderStr destination:nil data:nil];
		}
		else if(row == 2)
		{
			fileActionMode = 1;
			copyMoveFile = _file;
		}
		else if(row == 3)
		{
			fileActionMode = 2;
			copyMoveFile = _file;
		}
		else
		{
			currentFileFolderStr = [currentFileFolderStr stringByAppendingString:[copyMoveFile._fileName stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
			NSString *destination = [copyMoveFile._fatherUrlStr stringByAppendingFormat:@"/%@", 
									 [copyMoveFile._fileName stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
			if(fileActionMode == 1)
			{
				[_delegate fileAction:@"COPY" source:currentFileFolderStr destination:destination data:nil];
			}
			else
			{	
				[_delegate fileAction:@"MOVE" source:destination destination:currentFileFolderStr data:nil];
				fileActionMode = 0;
			}
		}
		
		[_filesView._tblvFilesGrp reloadData];
		
		[startThread release];
		_delegate._indicator.frame = CGRectMake(75, 140, 40, 40);
	}
	
	
	[_filesView._fileActionViewShape removeFromSuperview];
	_filesView._tblvFilesGrp.userInteractionEnabled = YES;
	_delegate.navigationController.navigationBar.userInteractionEnabled = YES;
	_delegate.tabBarController.tabBar.userInteractionEnabled = YES;
	
	[self.view removeFromSuperview];
	
}

-(void)startInProgress {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	_delegate._indicator.frame = CGRectMake(105, 100, 30, 30);
	[self.view addSubview:_delegate._indicator];
	[pool release];
	
}

- (void)takePicture
{		
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
	{  
        UIImagePickerController *thePicker = [[UIImagePickerController alloc] init];
		thePicker.delegate = self;
		thePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		thePicker.allowsImageEditing = YES;
		[_delegate presentModalViewController:thePicker animated:YES];
		[thePicker release]; 
    }
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Take Picture" message:@"Camera are not available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo  
{
	UIImage* selectedImage = image;
	NSData* imageData = UIImagePNGRepresentation(selectedImage);
	
	
	if ([imageData length] > 0) 
	{
		[picker dismissModalViewControllerAnimated:YES];
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"dd-MM-yyy-HH-mm-ss"];
		NSString* tmp = [dateFormatter stringFromDate:[NSDate date]];
		tmp = [tmp stringByAppendingFormat:@".png"];
		
		NSString* _savedFileDirectory = [_delegate._currenteXoFile._fatherUrlStr stringByAppendingFormat:@"/%@/",
										 [_delegate._currenteXoFile._fileName stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
		if(_file != _delegate._currenteXoFile)
			_savedFileDirectory = [_savedFileDirectory stringByAppendingFormat:@"%@/", [_file._fileName stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
		
		_savedFileDirectory = [_savedFileDirectory stringByAppendingString:tmp];
		
		[_delegate fileAction:@"UPLOAD" source:_savedFileDirectory destination:nil data:imageData];
		
	}
	else
	{	
		[picker dismissModalViewControllerAnimated:YES];
	}
}  

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker  
{  
    [picker dismissModalViewControllerAnimated:YES];    
}  



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
