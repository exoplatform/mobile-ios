//
//  FilesViewController_iPhone.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 22/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilesViewController_iPhone.h"
#import "eXoWebViewController.h"
#import "CustomBackgroundForCell_iPhone.h"

#define kTagForCellSubviewTitleLabel 222
#define kTagForCellSubviewImageView 333


#pragma mark -
#pragma mark Private

// =================================
// = Interface for private methods
// =================================
@interface FilesViewController_iPhone (PrivateMethods)

- (void)startRetrieveDirectoryContent;
- (void)setTitleForFilesViewController;
- (void)contentDirectoryIsRetrieved;
- (void)showActionsPanelFromNavigationBarButton;

@end


// =====================================
// = Implementation of private methods
// =====================================

@implementation FilesViewController_iPhone (PrivateMethods)

-(void)startRetrieveDirectoryContent {
    
    NSAutoreleasePool *pool =  [[NSAutoreleasePool alloc] init];
    
    if (_filesProxy == nil) _filesProxy = [[FilesProxy alloc] init];
    
    if (_rootFile == nil) _rootFile = [_filesProxy initialFileForRootDirectory:_isCompatibleWithSocial];
    
    _arrayContentOfRootFile = [_filesProxy getPersonalDriveContent:_rootFile];
    
    [pool release];
    
    //Call in the main thread update method
    [self performSelectorOnMainThread:@selector(contentDirectoryIsRetrieved) withObject:nil waitUntilDone:NO];
}

- (void)contentDirectoryIsRetrieved {
    //Now update the HUD
    //TODO Localize this string
    [_hudFolder setCaption:@"Folder content updated"];
    [_hudFolder setActivity:NO];
    [_hudFolder setImage:[UIImage imageNamed:@"19-check"]];
    [_hudFolder update];
    [_hudFolder hideAfter:1.0];
    
    //And finally reload the content of the tableView
    [self.tableView reloadData];
}

- (void)setTitleForFilesViewController {
    if (_rootFile) {
        self.title = _rootFile.fileName;
    } else {
        self.title = @"Documents";
    }
}

@end



#pragma mark -
#pragma mark Implementation

// ================================
// = Implementation for FilesViewController_iPhone
// ================================
@implementation FilesViewController_iPhone

@synthesize _isCompatibleWithSocial;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


//Use this method to init the Controller with a root file
- (id) initWithRootFile:(File *)rootFile {
    if ((self = [super initWithNibName:@"FilesViewController_iPhone" bundle:nil])) {
        //Set the rootFile 
        _rootFile = [rootFile retain];
    }
    return self;
}


- (void)dealloc
{
    //Release the FileProxy of the Controller.
    [_filesProxy release];
    _filesProxy = nil;
    
    //Release the rootFile
    [_rootFile release];
    _rootFile = nil;
    
    //Release the content of rootFile
    [_arrayContentOfRootFile release];
    _arrayContentOfRootFile = nil;
    
    [_actionsViewController release];
    _actionsViewController = nil;
    
    
    //Release the loader
    [_hudFolder release];
    _hudFolder = nil;
    
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
    
    _hudFolder = [[ATMHud alloc] initWithDelegate:self];
    [_hudFolder setAllowSuperviewInteraction:YES];
	[self.view addSubview:_hudFolder.view];
    
    //Set the background Color of the view
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    
    self.tableView.backgroundView = backgroundView;
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Set the title of the view controller
    [self setTitleForFilesViewController];
        
    //Add the "Actions" button
    //TODO localize this button
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithTitle:@"Actions" style:UIBarButtonItemStylePlain target:self action:@selector(showActionsPanelFromNavigationBarButton)];
    
    [self.navigationItem setRightBarButtonItem:actionButton];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_arrayContentOfRootFile == nil) {
        //TODO Localize this string
        [_hudFolder setCaption:[NSString stringWithFormat:@"Loading the content of the folder : %@",self.title]];
        [_hudFolder setActivity:YES];
        [_hudFolder show];
        
        //Start the request to load file content
        [self performSelectorInBackground:@selector(startRetrieveDirectoryContent) withObject:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

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
	return [_arrayContentOfRootFile count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *kCellIdentifier = @"CellIdentifierForFiles";
        CustomBackgroundForCell_iPhone *cell =  (CustomBackgroundForCell_iPhone*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if(cell == nil) {
            cell = [[[CustomBackgroundForCell_iPhone alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
            
            UIImageView* imgViewFile = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 40, 40)];
            cell.tag = kTagForCellSubviewImageView;
            [cell addSubview:imgViewFile];
            [imgViewFile release];
            
            UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 13.0, 200.0, 20.0)];
            titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.tag = kTagForCellSubviewTitleLabel;
            [cell addSubview:titleLabel];
            [titleLabel release];
            
            /*UIButton *btnFileAction = [[UIButton alloc] initWithFrame:CGRectMake(285.0, 9, 30, 30)];
            [btnFileAction setBackgroundImage:[UIImage imageNamed:@"action.png"] forState:UIControlStateNormal];
            [btnFileAction addTarget:self action:@selector(fileAction:) forControlEvents:UIControlEventTouchUpInside];
            btnFileAction.tag = indexPath.row;
            [cell addSubview:btnFileAction];
            [btnFileAction release];
            */
            
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
        
        File *file = [_arrayContentOfRootFile objectAtIndex:indexPath.row];
        
        
        UIImageView* imgViewFile = (UIImageView*)[cell viewWithTag:kTagForCellSubviewImageView];
        if(file.isFolder)
            imgViewFile.image = [UIImage imageNamed:@"folder.png"];
        else
            imgViewFile.image = [UIImage imageNamed:[File fileType:file.fileName]];
        
        
        UILabel *titleLabel = (UILabel*)[cell viewWithTag:kTagForCellSubviewTitleLabel];
        titleLabel.text = file.fileName;
    
    
        
    /*
        
        if (imgViewEmptyPage == nil) {
            imgViewEmptyPage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
            imgViewEmptyPage.image = [UIImage imageNamed:@"emptypage.png"];
            
            labelEmptyPage = [[UILabel alloc] initWithFrame:CGRectMake(0, 280, 320, 40)];
            labelEmptyPage.backgroundColor = [UIColor clearColor];
            labelEmptyPage.textAlignment = UITextAlignmentCenter;
            labelEmptyPage.text = [_delegate._dictLocalize objectForKey:@"EmptyPage"];
            [imgViewEmptyPage addSubview:labelEmptyPage];
            [self addSubview:imgViewEmptyPage];
            
            imgViewEmptyPage.hidden = YES;
        }
      */  
        
    //Customize the cell background
    [cell setBackgroundForRow:indexPath.row inSectionSize:[self tableView:tableView numberOfRowsInSection:indexPath.section]];
    
        return cell;
    

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	//NSThread *startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInProgress) object:nil];
	//[startThread start];
	
    //Retrieve the File corresponding to the selected Cell
	File *fileToBrowse = [_arrayContentOfRootFile objectAtIndex:indexPath.row];
	
	if(fileToBrowse.isFolder)
	{
        
        //Create a new FilesViewController_iPhone to push it into the navigationController
        
        FilesViewController_iPhone *newViewControllerForFilesBrowsing = [[FilesViewController_iPhone alloc] initWithRootFile:fileToBrowse];
        
        
        
        [self.navigationController pushViewController:newViewControllerForFilesBrowsing animated:YES];
        
        
        /*
		_delegate._currenteXoFile = file;
		_delegate._fileNameStackStr = [_delegate._fileNameStackStr stringByAppendingPathComponent:file._fileName];
		_arrDicts = [_delegate getPersonalDriveContent:file];
		
		[self setDriverContent:_arrDicts withDelegate:_delegate];
		_delegate.navigationItem.leftBarButtonItem = _delegate._btnBack;
		
		if([_arrDicts count] == 0) {
			imgViewEmptyPage.hidden = NO;
		}
         */
		
	}
	else
	{
		NSURL *urlOfTheFileToOpen = [NSURL URLWithString:[fileToBrowse.urlStr stringByReplacingOccurrencesOfString:@" " 
                                                                                                        withString:@"%20"]];
		eXoWebViewController* fileWebViewController = [[eXoWebViewController alloc] initWithNibAndUrl:@"eXoWebViewController"
                                                                                               bundle:nil 
                                                                                                  url:urlOfTheFileToOpen
                                                                                             fileName:fileToBrowse.fileName];
		[self.navigationController pushViewController:fileWebViewController animated:YES];     
	}
	
	//[startThread release];
	//[self performSelectorOnMainThread:@selector(endProgress) withObject:nil waitUntilDone:NO];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    //Check if the _actionsViewController is already created or not
    if (_actionsViewController == nil) {
        
        _actionsViewController = [[FileActionsViewController_iPhone alloc] initWithNibName:@"FileActionsViewController_iPhone" 
                                                                                    bundle:nil 
                                                                                      file:[_arrayContentOfRootFile objectAtIndex:indexPath.row] 
                                                                    enableDeleteThisFolder:YES
                                                                                  delegate:self];
        if (_maskingViewForActions ==nil) {
            _maskingViewForActions = [[UIView alloc] initWithFrame:self.view.frame];
            _maskingViewForActions.backgroundColor = [UIColor blackColor];
            _maskingViewForActions.alpha = 0.45;
            
            //Add a Gesture Recognizer to remove the FileActionsPanel 
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideActionsPanel)];
            [_maskingViewForActions addGestureRecognizer:tapGesture];
            [tapGesture release];
        }
        
    }
    
    _actionsViewController.fileToApplyAction = [_arrayContentOfRootFile objectAtIndex:indexPath.row] ;
    
    [self.view addSubview:_maskingViewForActions];
	[self.view addSubview:_actionsViewController.view];
    self.tableView.scrollEnabled = NO;


}


#pragma mark - Panel Actions

-(void) showActionsPanelFromNavigationBarButton {

    //Check if the _actionsViewController is already created or not
    if (_actionsViewController == nil) {
        
        _actionsViewController = [[FileActionsViewController_iPhone alloc] initWithNibName:@"FileActionsViewController_iPhone" 
                                                                                    bundle:nil 
                                                                                      file:_rootFile 
                                                                    enableDeleteThisFolder:YES
                                                                                  delegate:self];
        if (_maskingViewForActions ==nil) {
            _maskingViewForActions = [[UIView alloc] initWithFrame:self.view.frame];
            _maskingViewForActions.backgroundColor = [UIColor blackColor];
            _maskingViewForActions.alpha = 0.45;
            
            //Add a Gesture Recognizer to remove the FileActionsPanel 
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideActionsPanel)];
            [_maskingViewForActions addGestureRecognizer:tapGesture];
            [tapGesture release];
        }
        
    }
    
    _actionsViewController.fileToApplyAction = _rootFile ;
    
    [self.view addSubview:_maskingViewForActions];
	[self.view addSubview:_actionsViewController.view];
    self.tableView.scrollEnabled = NO;

}



-(void) hideActionsPanel {
    [_actionsViewController.view removeFromSuperview];
    [_maskingViewForActions removeFromSuperview];
    self.tableView.scrollEnabled = YES;
}


#pragma mark - FileAction delegate Methods


- (void)showErrorForFileAction:(NSString *)errorMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File error" message:errorMessage delegate:self 
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

//Use this method to do the delete action in a background thread
-(void)deleteFileInBackground:(NSString *)urlFileToDelete {
    
    NSString *errorMessage = [_filesProxy fileAction:kFileProtocolForDelete source:urlFileToDelete destination:nil data:nil];
    
    //check the status of the operation
    if (errorMessage) {
        //On main thread, as to send the AlertView
        [self performSelectorOnMainThread:@selector(showErrorForFileAction:) withObject:errorMessage waitUntilDone:NO];
    }
    
    //Need to reload the content of the folder
    [self startRetrieveDirectoryContent];
}

//Method needed to retrieve the delete action
-(void)deleteFile:(NSString *)urlFileToDelete {
    
    //Hide the action Panel
    [self hideActionsPanel];
    
    //TODO Localize this string
    [_hudFolder setCaption:@"Delete file..."];
    [_hudFolder setActivity:YES];
    [_hudFolder show];
    
    [self performSelectorInBackground:@selector(deleteFileInBackground:) withObject:urlFileToDelete];
}

-(void)moveOrCopyActionIsSelected {
    [self hideActionsPanel];
}


//Use this method to do the move action in a background thread
- (void)moveFileInBackgroundSource:urlSource
                     toDestination:urlDestination {
    
     
     NSString *errorMessage = [_filesProxy fileAction:kFileProtocolForMove source:urlSource destination:urlDestination data:nil];
     
     //Hide the action Panel
     [self hideActionsPanel];
     
     //check the status of the operation
     if (errorMessage) {
         [self performSelectorOnMainThread:@selector(showErrorForFileAction:) withObject:errorMessage waitUntilDone:NO];
     }
     
     //Need to reload the content of the folder
     [self startRetrieveDirectoryContent];
     
}


//Method needed to retrieve the action to move a file
- (void)moveFileSource:urlSource
         toDestination:urlDestination {
    
    //Hide the action Panel
    [self hideActionsPanel];
    
    //TODO Localize this string
    [_hudFolder setCaption:@"Move file to wanted folder..."];
    [_hudFolder setActivity:YES];
    [_hudFolder show];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                [self methodSignatureForSelector:@selector(moveFileInBackgroundSource:toDestination:)]];
    [invocation setTarget:self];
    [invocation setSelector:@selector(moveFileInBackgroundSource:toDestination:)];
    [invocation setArgument:&urlSource atIndex:2];
    [invocation setArgument:&urlDestination atIndex:3];
    [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocation repeats:NO];
}

//Use this method to do the copy action in a background thread
- (void)copyFileInBackgroundSource:urlSource
         toDestination:urlDestination {
    
    NSString *errorMessage = [_filesProxy fileAction:kFileProtocolForCopy source:urlSource destination:urlDestination data:nil];
    
    //Hide the action Panel
    [self hideActionsPanel];
    
    //check the status of the operation
    if (errorMessage) {
        [self performSelectorOnMainThread:@selector(showErrorForFileAction:) withObject:errorMessage waitUntilDone:NO];
    }
    
    //Need to reload the content of the folder
    [self startRetrieveDirectoryContent];

}


//Method needed to retrieve the action to copy a file
- (void)copyFileSource:urlSource
         toDestination:urlDestination {
    
    //TODO Localize this string
    [_hudFolder setCaption:@"Copy file to wanted folder..."];
    [_hudFolder setActivity:YES];
    [_hudFolder show];
    
    //Hide the action Panel
    [self hideActionsPanel];
        
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                [self methodSignatureForSelector:@selector(copyFileInBackgroundSource:toDestination:)]];
    [invocation setTarget:self];
    [invocation setSelector:@selector(copyFileInBackgroundSource:toDestination:)];
    [invocation setArgument:&urlSource atIndex:2];
    [invocation setArgument:&urlDestination atIndex:3];
    [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocation repeats:NO]; 
        
}


- (void)askToAddAPicture {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
	{  
        UIImagePickerController *thePicker = [[UIImagePickerController alloc] init];
		thePicker.delegate = self;
		thePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		thePicker.allowsEditing = YES;
		[self.navigationController presentModalViewController:thePicker animated:YES];
		[thePicker release];
    }
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Take Picture" message:@"Camera are not available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
    
    [self hideActionsPanel];
    
    //Need to reload the content of the folder
    [self startRetrieveDirectoryContent];
}




#pragma mark - Pictures Management


- (void)sendImageInBackgroundForDirectory:(NSString *)directory data:(NSData *)imageData
{
    [_filesProxy fileAction:kFileProtocolForUpload source:directory destination:nil data:imageData];
    //Need to reload the content of the folder
    [self startRetrieveDirectoryContent];
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
        
        //release the date formatter because, not needed after that piece of code
        [dateFormatter release];
		tmp = [tmp stringByAppendingFormat:@".png"];
		
		NSString* _savedFileDirectory = [_rootFile.urlStr stringByAppendingFormat:@"/%@/", _rootFile.fileName];
		/*if(_file != _delegate._currenteXoFile)
			_savedFileDirectory = [_savedFileDirectory stringByAppendingFormat:@"%@/", [_file._fileName stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
		*/
		_savedFileDirectory = [_savedFileDirectory stringByAppendingString:tmp];
		
        //TODO Localize this string
        [_hudFolder setCaption:@"Sending image to wanted folder..."];
        [_hudFolder setActivity:YES];
        [_hudFolder show];
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:@selector(sendImageInBackgroundForDirectory:data:)]];
        [invocation setTarget:self];
        [invocation setSelector:@selector(sendImageInBackgroundForDirectory:data:)];
        [invocation setArgument:&_savedFileDirectory atIndex:2];
        [invocation setArgument:&imageData atIndex:3];
        [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocation repeats:NO];
        
		//[_filesProxy fileAction:kFileProtocolForUpload source:_savedFileDirectory destination:nil data:imageData];
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



#pragma mark - ATMHud Delegate
#pragma mark -
#pragma mark ATMHudDelegate
- (void)userDidTapHud:(ATMHud *)_hud {
	[_hud hide];
}

#pragma mark -
#pragma mark More examples
/*
// Uncomment this method to see a demonstration of playing a sound everytime a HUD appears.
- (void)hudDidAppear:(ATMHud *)_hud {
     NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"pop"
                                                               ofType: @"wav"];
     [_hud playSound:soundFilePath];
}*/




@end
